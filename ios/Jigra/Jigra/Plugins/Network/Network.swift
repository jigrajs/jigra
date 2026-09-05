import Foundation

@objc(JIGNetworkPlugin)
public class JIGNetworkPlugin : JIGPlugin {
  let reachability = Reachability()!
  
  public override func load() {
    JIGLog.print("Loading network plugin")
    reachability.whenReachable = { reachability in
      if reachability.connection == .wifi {
        JIGLog.print("Reachable via WiFi")
        self.notifyStatusChangeListeners(connected: true, type: "wifi")
      } else {
        JIGLog.print("Reachable via Cellular")
        self.notifyStatusChangeListeners(connected: true, type: "cellular")
      }
    }
    reachability.whenUnreachable = { _ in
      JIGLog.print("Not reachable")
      self.notifyStatusChangeListeners(connected: false, type: "none")
    }
  
    do {
      try reachability.startNotifier()
    } catch {
      JIGLog.print("Unable to start notifier")
    }
  }
  
  @objc func getStatus(_ call: JIGPluginCall) {
    var connected = false
    var type = ""
    if reachability.connection == .wifi {
      connected = true
      type = "wifi"
    }
    if reachability.connection == .cellular {
      connected = true
      type = "cellular"
    }
    
    call.success([
      "connected": connected,
      "connectionType": type
    ])
  }
  
  func notifyStatusChangeListeners(connected: Bool, type: String) {
    notifyListeners("networkStatusChange", data: [
      "connected": connected,
      "connectionType": type
    ])
  }
}
