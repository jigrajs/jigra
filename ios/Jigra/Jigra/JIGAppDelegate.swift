public final class JIGAppDelegate {
  public static let shared = JIGAppDelegate()
  
  public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return JIGBridge.handleOpenUrl(url, options)
  }
  
  public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    return JIGBridge.handleContinueActivity(userActivity, restorationHandler)
  }
  
  public func applicationDidBecomeActive(_ application: UIApplication) {
    return JIGBridge.handleAppBecameActive(application)
  }
}
