/**
 * Notificaton types for NSNotificationCenter
 */
@objc public enum JIGNotifications: Int {
  case URLOpen
  case UniversalLinkOpen
  case ContinueActivity
  case DidRegisterForRemoteNotificationsWithDeviceToken
  case DidFailToRegisterForRemoteNotificationsWithError
  case DecidePolicyForNavigationAction
  
  public func name() -> String {
    switch self {
      case .URLOpen: return "JIGNotificationsURLOpen"
      case .UniversalLinkOpen: return "JIGUniversalLinkOpen"
      case .ContinueActivity: return "JIGNotificationsContinueActivity"
      case .DidRegisterForRemoteNotificationsWithDeviceToken: return "JIGDidRegisterForRemoteNotificationsWithDeviceToken"
      case .DidFailToRegisterForRemoteNotificationsWithError: return "JIGDidFailToRegisterForRemoteNotificationsWithError"
      case .DecidePolicyForNavigationAction: return "JIGDecidePolicyForNavigationAction"
    }
  }
}
