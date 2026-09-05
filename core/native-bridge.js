//# sourceURL=jigra-runtime.js

(function(win) {
  win.Jigra = win.Jigra || {
    Plugins: {}
  };

  var jigra = Jigra;

  // Export Cordova if not defined
  win.cordova = win.cordova || {};

  // Add any legacy handlers to keep Cordova compat 100% good
  addLegacyHandlers(win);

  jigra.Plugins = jigra.Plugins || {};
  
  jigra.DEBUG = typeof jigra.DEBUG === 'undefined' ? true : jigra.DEBUG;

  // keep a collection of callbacks for native response data
  var calls = {};

  // Counter of callback ids, randomized to avoid
  // any issues during reloads if a call comes back with
  // an existing callback id from an old session
  var callbackIdCount = Math.floor(Math.random() * 134217728);

  var lastError = null;
  var errorModal = null;

  // create the postToNative() fn if needed
  if (win.androidBridge) {
    // android platform
    postToNative = function androidBridge(data) {
      win.androidBridge.postMessage(JSON.stringify(data));
    };
    jigra.isNative = true;
    jigra.isAndroid = true;
    jigra.platform = 'android';

  } else if (win.webkit && win.webkit.messageHandlers && win.webkit.messageHandlers.bridge) {
    // ios platform
    postToNative = function iosBridge(data) {
      data.type = 'message';
      win.webkit.messageHandlers.bridge.postMessage(data);
    };
    jigra.isNative = true;
    jigra.isIOS = true;
    jigra.platform = 'ios';
  }

  var useFallbackLogging = Object.keys(win.console).length === 0;
  if(useFallbackLogging) {
    win.console.warn('Advance console logging disabled.')
  }

  // patch window.console on iOS and store original console fns
  var orgConsole = jigra.isIOS ? {} : win.console;
  
  // list log functions bridged to native log
  var bridgedLevels = {
    debug: true,
    error: true,
    info: true,
    log: true,
    trace: true,
    warn: true,
  };
  if (jigra.isIOS) {
    Object.keys(win.console).forEach(function (level) {
      if (typeof win.console[level] === 'function') {
        // loop through all the console functions and keep references to the original
        orgConsole[level] = win.console[level];
        win.console[level] = function jigraConsole() {
          var msgs = Array.prototype.slice.call(arguments);

          // console log to browser
          orgConsole[level].apply(win.console, msgs);

          if (jigra.isNative && bridgedLevels[level]) {
            // send log to native to print
            try {
              // convert all args to strings
              msgs = msgs.map(function (arg) {
                if (typeof arg === 'object') {
                  try {
                    arg = JSON.stringify(arg);
                  } catch (e) {}
                }
                // convert to string
                return arg + '';
            });
              jigra.toNative('Console', 'log', {
                level: level,
                message: msgs.join(' ')
              });
            } catch (e) {
              // error converting/posting console messages
              orgConsole.error.apply(win.console, e);
            }
          }
        };
      }
    });
  }

  function addLegacyHandlers(win) {
    win.navigator.app = {
      exitApp: function() {
        jigra.toNative("App", "exitApp", {}, null);
      }
    }
    var documentAddEventListener = document.addEventListener;
    document.addEventListener = function() {
      var name = arguments[0];
      var handler = arguments[1];
      if (name === 'deviceready') {
        setTimeout(function() {
          handler && handler();
        });
      } else if (name === 'backbutton') {
        // Add a dummy listener so Jigra doesn't do the default
        // back button action
        Jigra.Plugins.App && Jigra.Plugins.App.addListener('backButton', function() {});
      }
      return documentAddEventListener.apply(document, arguments);
    }
  }

  /*
   * Check if a Plugin is available
   */
  jigra.isPluginAvailable = function isPluginAvailable(name) {
    return this.Plugins.hasOwnProperty(name);
  }

  jigra.convertFileSrc = function convertFileSrc(url) {
    if (!url) {
      return url;
    }
    if (url.startsWith('/')) {
      return window.WEBVIEW_SERVER_URL + '/_jigra_file_' + url;
    }
    if (url.startsWith('file://')) {
      return window.WEBVIEW_SERVER_URL + url.replace('file://', '/_jigra_file_');
    }
    if (url.startsWith('content://')) {
      return window.WEBVIEW_SERVER_URL + url.replace('content:/', '/_jigra_content_');
    }
    return url;
  }

  /*
   * Check running platform
   */
  jigra.getPlatform = function getPlatform() {
    return this.platform;
  }

  /**
   * Send a plugin method call to the native layer
   */
  jigra.toNative = function toNative(pluginId, methodName, options, storedCallback) {
    try {
      if (jigra.isNative) {
        var callbackId = '-1';

        if (storedCallback && (typeof storedCallback.callback === 'function' || typeof storedCallback.resolve === 'function')) {
          // store the call for later lookup
          callbackId = ++callbackIdCount + '';
          calls[callbackId] = storedCallback;
        }

        var call = {
          callbackId: callbackId,
          pluginId: pluginId,
          methodName: methodName,
          options: options || {}
        };

        if (jigra.DEBUG) {
          if (pluginId !== 'Console') {
            jigra.logToNative(call);
          }
        }

        // post the call data to native
        postToNative(call);

        return callbackId;

      } else {
        orgConsole.warn.call(win.console, 'browser implementation unavailable for: ' + pluginId);
      }

    } catch (e) {
      orgConsole.error.call(win.console, e);
    }

    return null;
  };

  /**
   * Process a response from the native layer.
   */
  jigra.fromNative = function fromNative(result) {
    if (jigra.DEBUG) {
      if (result.pluginId !== 'Console') {
        jigra.logFromNative(result);
      }
    }
    // get the stored call, if it exists
    try {
      var storedCall = calls[result.callbackId];

      if (storedCall) {
        // looks like we've got a stored call

        if (result.error && typeof result.error === 'object') {
          // ensure stacktraces by copying error properties to an Error
          result.error = Object.keys(result.error).reduce(function(err, key) {
            err[key] = result.error[key];
            return err;
          }, new Error());
        }

        if (typeof storedCall.callback === 'function') {
          // callback
          if (result.success) {
            storedCall.callback(result.data);
          } else {
            storedCall.callback(null, result.error);
          }

        } else if (typeof storedCall.resolve === 'function') {
          // promise
          if (result.success) {
            storedCall.resolve(result.data);
          } else {
            storedCall.reject(result.error);
          }

          // no need to keep this stored callback
          // around for a one time resolve promise
          delete calls[result.callbackId];
        }

      } else if (!result.success && result.error) {
        // no stored callback, but if there was an error let's log it
        orgConsole.warn.call(win.console, result.error);
      }

      if (result.save === false) {
        delete calls[result.callbackId];
      }

    } catch (e) {
      orgConsole.error.call(win.console, e);
    }

    // always delete to prevent memory leaks
    // overkill but we're not sure what apps will do with this data
    delete result.data;
    delete result.error;
  };

  jigra.logJs = function(message, level) {
    switch (level) {
      case 'error':
        console.error(message);
        break;
      case 'warn':
        console.warn(message);
        break;
      case 'info':
        console.info(message);
        break;
      default:
        console.log(message);
    }
  }

  jigra.withPlugin = function withPlugin(_pluginId, _fn) {
  };

  jigra.nativeCallback = function (pluginId, methodName, options, callback) {
    if(typeof options === 'function') {
      callback = options;
      options = null;
    }
    return jigra.toNative(pluginId, methodName, options, {
      callback: callback
    });
  };

  jigra.nativePromise = function (pluginId, methodName, options) {
    return new Promise(function (resolve, reject) {
      jigra.toNative(pluginId, methodName, options, {
        resolve: resolve,
        reject: reject
      });
    });
  };


  jigra.addListener = function(pluginId, eventName, callback) {
    var callbackId = jigra.nativeCallback(pluginId, 'addListener', {
      eventName: eventName
    }, callback);
    return {
      remove: function() {
        console.log('Removing listener', pluginId, eventName);
        jigra.removeListener(pluginId, callbackId, eventName, callback);
      }
    }
  };

  jigra.removeListener = function(pluginId, callbackId, eventName, callback) {
    jigra.nativeCallback(pluginId, 'removeListener', {
      callbackId: callbackId,
      eventName: eventName
    }, callback);
  }

  jigra.createEvent = function(type, data) {
    var event = document.createEvent('Events');
    event.initEvent(type, false, false);
    if (data) {
      for (var i in data) {
        if (data.hasOwnProperty(i)) {
          event[i] = data[i];
        }
      }
    }
    return event;
  }

  jigra.triggerEvent = function(eventName, target, data) {
    var eventData = data || {};
    var event = this.createEvent(eventName, eventData);
    if (target === "document") {
      if (cordova.fireDocumentEvent) {
        cordova.fireDocumentEvent(eventName, eventData);
      } else {
        document.dispatchEvent(event);
      }
    } else if (target === "window") {
      window.dispatchEvent(event);
    } else {
      var targetEl = document.querySelector(target);
      targetEl && targetEl.dispatchEvent(event);
    }
  }

  jigra.handleError = function(error) {
    console.error(error);
  }

  jigra.handleWindowError = function (msg, url, lineNo, columnNo, error) {
    var string = msg.toLowerCase();
    var substring = "script error";
    if (string.indexOf(substring) > -1) {
      // Some IE issue?
    } else {
      var errObj = {
        type: 'js.error',
        error: {
          message: msg,
          url: url,
          line: lineNo,
          col: columnNo,
          errorObject: JSON.stringify(error)
        }
      };
      if (error !== null) {
        win.Jigra.handleError(error);
      }
      if(jigra.isAndroid) {
        win.androidBridge.postMessage(JSON.stringify(errObj));
      } else if(jigra.isIOS) {
        win.webkit.messageHandlers.bridge.postMessage(errObj);
      }
    }

    return false;
  };

  jigra.logToNative = function(call) {
    if(!useFallbackLogging) {
        var c = orgConsole;
        c.groupCollapsed('%cnative %c' + call.pluginId + '.' + call.methodName + ' (#' + call.callbackId + ')', 'font-weight: lighter; color: gray', 'font-weight: bold; color: #000');
        c.dir(call);
        c.groupEnd();
    } else {
        win.console.log('LOG TO NATIVE: ', call);
        if (jigra.isIOS) {
            try {
                jigra.toNative('Console', 'log', {message: JSON.stringify(call)});
            } catch (e) {
                win.console.log('Error converting/posting console messages');
            }
        }
    }
  }

  jigra.logFromNative = function(result) {
      if(!useFallbackLogging) {
          var c = orgConsole;

          var success = result.success === true;

          var tagStyles = success ? 'font-style: italic; font-weight: lighter; color: gray' :
              'font-style: italic; font-weight: lighter; color: red';

          c.groupCollapsed('%cresult %c' + result.pluginId + '.' + result.methodName + ' (#' + result.callbackId + ')',
              tagStyles,
              'font-style: italic; font-weight: bold; color: #444');
          if (result.success === false) {
              c.error(result.error);
          } else {
              c.dir(result.data);
          }
          c.groupEnd();
      } else {
          if (result.success === false) {
              win.console.error(result.error);
          } else {
              win.console.log(result.data);
          }
      }
  }

  jigra.uuidv4 = function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  if (Jigra.DEBUG) {
    window.onerror = jigra.handleWindowError;
  }

  win.Family = win.Family || {};
  win.Family.WebView = win.Family.WebView || {};

  win.Family.WebView.getServerBasePath = function(callback) {
    Jigra.Plugins.WebView.getServerBasePath().then(function(result) {
      callback(result.path);
    });
  }

  win.Family.WebView.setServerBasePath = function (path) {
    Jigra.Plugins.WebView.setServerBasePath({"path": path});
  }

  win.Family.WebView.persistServerBasePath = function () {
    Jigra.Plugins.WebView.persistServerBasePath();
  }

  win.Family.WebView.convertFileSrc = function(url) {
    return Jigra.convertFileSrc(url);
  }

})(window);

