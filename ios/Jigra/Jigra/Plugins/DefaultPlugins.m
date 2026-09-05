#import <Foundation/Foundation.h>

#import "JIGBridgedPlugin.h"

JIG_PLUGIN(JIGAccessibilityPlugin, "Accessibility",
  JIG_PLUGIN_METHOD(isScreenReaderEnabled, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(speak, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGAppPlugin, "App",
  JIG_PLUGIN_METHOD(exitApp, JIGPluginReturnNone);
  JIG_PLUGIN_METHOD(getLaunchUrl, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getState, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(canOpenUrl, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(openUrl, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGBackgroundTaskPlugin, "BackgroundTask",
  JIG_PLUGIN_METHOD(beforeExit, JIGPluginReturnCallback);
  JIG_PLUGIN_METHOD(finish, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGBrowserPlugin, "Browser",
  JIG_PLUGIN_METHOD(open, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(close, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(prefetch, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGCameraPlugin, "Camera",
  JIG_PLUGIN_METHOD(getPhoto, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGClipboardPlugin, "Clipboard",
  JIG_PLUGIN_METHOD(read, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(write, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGConsolePlugin, "Console",
  JIG_PLUGIN_METHOD(log, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGDevicePlugin, "Device",
  JIG_PLUGIN_METHOD(getInfo, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getBatteryInfo, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getLanguageCode, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGFilesystemPlugin, "Filesystem",
  JIG_PLUGIN_METHOD(readFile, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(writeFile, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(appendFile, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(deleteFile, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(mkdir, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(rmdir, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(readdir, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getUri, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(stat, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(rename, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(copy, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGGeolocationPlugin, "Geolocation",
  JIG_PLUGIN_METHOD(getCurrentPosition, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(watchPosition, JIGPluginReturnCallback);
  JIG_PLUGIN_METHOD(clearWatch, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGHapticsPlugin, "Haptics",
  JIG_PLUGIN_METHOD(impact, JIGPluginReturnNone);
  JIG_PLUGIN_METHOD(notification, JIGPluginReturnNone);
  JIG_PLUGIN_METHOD(selectionStart, JIGPluginReturnNone);
  JIG_PLUGIN_METHOD(selectionChanged, JIGPluginReturnNone);
  JIG_PLUGIN_METHOD(selectionEnd, JIGPluginReturnNone);
  JIG_PLUGIN_METHOD(vibrate, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGKeyboard, "Keyboard",
  JIG_PLUGIN_METHOD(show, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(hide, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(setAccessoryBarVisible, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(setStyle, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(setResizeMode, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(setScroll, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGLocalNotificationsPlugin, "LocalNotifications",
  JIG_PLUGIN_METHOD(schedule, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(requestPermission, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(cancel, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getPending, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(registerActionTypes, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(areEnabled, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(createChannel, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(deleteChannel, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(listChannels, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGModalsPlugin, "Modals",
  JIG_PLUGIN_METHOD(alert, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(prompt, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(confirm, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(showActions, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGNetworkPlugin, "Network",
  JIG_PLUGIN_METHOD(getStatus, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGPermissionsPlugin, "Permissions",
  JIG_PLUGIN_METHOD(query, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGPushNotificationsPlugin, "PushNotifications",
  JIG_PLUGIN_METHOD(register, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(requestPermission, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getDeliveredNotifications, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeDeliveredNotifications, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllDeliveredNotifications, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(createChannel, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(deleteChannel, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(listChannels, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(removeAllListeners, JIGPluginReturnNone);
)

JIG_PLUGIN(JIGPhotosPlugin, "Photos",
  JIG_PLUGIN_METHOD(getPhotos, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getAlbums, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(createAlbum, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(savePhoto, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGSharePlugin, "Share",
  JIG_PLUGIN_METHOD(share, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGSplashScreenPlugin, "SplashScreen",
  JIG_PLUGIN_METHOD(show, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(hide, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGStatusBarPlugin, "StatusBar",
  JIG_PLUGIN_METHOD(setStyle, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(setBackgroundColor, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(show, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(hide, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getInfo, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(setOverlaysWebView, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGStoragePlugin, "Storage",
  JIG_PLUGIN_METHOD(clear, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(get, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(set, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(remove, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(keys, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGToastPlugin, "Toast",
  JIG_PLUGIN_METHOD(show, JIGPluginReturnPromise);
)

JIG_PLUGIN(JIGWebViewPlugin, "WebView",
  JIG_PLUGIN_METHOD(setServerBasePath, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(getServerBasePath, JIGPluginReturnPromise);
  JIG_PLUGIN_METHOD(persistServerBasePath, JIGPluginReturnPromise);
)
