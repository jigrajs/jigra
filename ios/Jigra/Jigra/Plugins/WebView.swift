import Foundation

@objc(JIGWebViewPlugin)
public class JIGWebViewPlugin : JIGPlugin {

  @objc func setServerBasePath(_ call: JIGPluginCall) {
    let path = call.getString("path")
    let vc = bridge.viewController as! JIGBridgeViewController
    vc.setServerBasePath(path: path!)
    call.success()
  }

  @objc func getServerBasePath(_ call: JIGPluginCall) {
    let vc = bridge.viewController as! JIGBridgeViewController
    let path = vc.getServerBasePath()
    call.success([
      "path": path
    ])
  }

  @objc func persistServerBasePath(_ call: JIGPluginCall) {
    let vc = bridge.viewController as! JIGBridgeViewController
    let path = vc.getServerBasePath()
    let defaults = UserDefaults.standard
    defaults.set(path, forKey: "serverBasePath")
    call.success()
  }
}
