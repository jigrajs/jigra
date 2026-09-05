import Foundation

@objc(JIGAppPlugin)
public class JIGAppPlugin : JIGPlugin {
  var lastUrlOpenOptions: [String:Any?]?
  
  public override func load() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.handleUrlOpened(notification:)), name: Notification.Name(JIGNotifications.URLOpen.name()), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.handleUniversalLink(notification:)), name: Notification.Name(JIGNotifications.UniversalLinkOpen.name()), object: nil)
  }
  
  @objc func handleUrlOpened(notification: NSNotification) {
    guard let object = notification.object as? [String:Any?] else {
      return
    }
    
    notifyListeners("appUrlOpen", data: makeUrlOpenObject(object), retainUntilConsumed: true)
  }
  
  @objc func handleUniversalLink(notification: NSNotification) {
    guard let object = notification.object as? [String:Any?] else {
      return
    }
    
    notifyListeners("appUrlOpen", data: makeUrlOpenObject(object), retainUntilConsumed: true)
  }
  
  func makeUrlOpenObject(_ object: [String:Any?]) -> JSObject {
    guard let url = object["url"] as? NSURL else {
      return [:]
    }
    
    let options = object["options"] as? [String:Any?] ?? [:]
    return [
      "url": url.absoluteString ?? "",
      "iosSourceApplication": options[UIApplication.OpenURLOptionsKey.sourceApplication.rawValue] as? String ?? "",
      "iosOpenInPlace": options[UIApplication.OpenURLOptionsKey.openInPlace.rawValue] as? String ?? ""
    ]
  }
  
  func firePluginError(_ jsError: JSProcessingError) {
    notifyListeners("pluginError", data: [
      "message": jsError.localizedDescription
    ])
  }
  
  public func fireChange(isActive: Bool) {
    notifyListeners("appStateChange", data: [
      "isActive": isActive
    ])
  }
  
  @objc func exitApp(_ call: JIGPluginCall) {
    call.unimplemented()
  }

  @objc func getLaunchUrl(_ call: JIGPluginCall) {
    if let lastUrl = JIGBridge.getLastUrl() {
      let urlValue = lastUrl.absoluteString
      call.resolve([
        "url": urlValue
      ])
    }
    call.resolve()
  }

  @objc func getState(_ call: JIGPluginCall) {
    DispatchQueue.main.async {
      call.resolve([
        "isActive": UIApplication.shared.applicationState == UIApplication.State.active
      ])
    }
  }

  @objc func canOpenUrl(_ call: JIGPluginCall) {
    guard let urlString = call.getString("url") else {
      call.error("Must supply a URL")
      return
    }
    
    guard let url = URL.init(string: urlString) else {
      call.error("Invalid URL")
      return
    }

    DispatchQueue.main.async {
      let canOpen = UIApplication.shared.canOpenURL(url)
      
      call.success([
        "value": canOpen
      ])
    }
  }
  
  @objc func openUrl(_ call: JIGPluginCall) {
    guard let urlString = call.getString("url") else {
      call.error("Must supply a URL")
      return
    }
    
    guard let url = URL.init(string: urlString) else {
      call.error("Invalid URL")
      return
    }
    
    DispatchQueue.main.async {
      UIApplication.shared.open(url, options: [:]) { (completed) in
        call.success([
          "completed": completed
        ])
      }
    }
  }
}


