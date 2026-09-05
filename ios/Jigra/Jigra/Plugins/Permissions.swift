import Foundation
import Photos
import UserNotifications

/**
 * Allow to check hardware permissions
 */
@objc(JIGPermissionsPlugin)
public class JIGPermissionsPlugin: JIGPlugin {
  fileprivate static let uknownPermissionValue = "Unknown permission value"
  
  @objc func query(_ call: JIGPluginCall) {
    guard let name = call.getString("name") else {
      call.reject("Must provide a permission to check")
      return
    }
    
    switch (name) {
    case "camera":
      return checkCamera(call)
    case "geolocation":
      return checkGeolocation(call)
    case "notifications":
      return checkNotifications(call)
    case "clipboard-read", "clipboard-write":
      return checkClipboard(call)
    case "photos":
      return checkPhotos(call)
    case "microphone":
      return checkMicrophone(call)
    default:
      return call.reject("Unknown permission type")
    }
  }

  func checkCamera(_ call: JIGPluginCall) {
    let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    let ret: String
    switch (authStatus) {
    case .denied, .restricted:
      ret = "denied"
    case .authorized:
      ret = "granted"
    case .notDetermined:
      ret = "prompt"
    @unknown default:
      call.reject(JIGPermissionsPlugin.uknownPermissionValue)
      return
    }

    call.resolve([
      "state": ret
    ])
  }

  func checkPhotos(_ call: JIGPluginCall) {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    let ret: String
    switch (photoAuthorizationStatus) {
    case .denied, .restricted:
      ret = "denied"
    case .authorized:
      ret = "granted"
    #if swift(>=5.3)
    case .limited:
      // TODO: address this new case properly
      #warning(".limited != .authorized, authorization status should be revisited for iOS 14")
      ret = "granted"
    #endif
    case .notDetermined:
      ret = "prompt"
    @unknown default:
      call.reject(JIGPermissionsPlugin.uknownPermissionValue)
      return
    }
    
    call.resolve([
      "state": ret
    ])
  }

  func checkGeolocation(_ call: JIGPluginCall) {
    let ret: String
    if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
          ret = "denied"
        case .authorizedAlways, .authorizedWhenInUse:
          ret = "granted"
        case .notDetermined:
          ret = "prompt"
        @unknown default:
          call.reject(JIGPermissionsPlugin.uknownPermissionValue)
          return
        }
    } else {
      ret = "denied"
    }

    call.resolve([
      "state": ret
    ])
  }

  func checkNotifications(_ call: JIGPluginCall) {
    UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
      let ret: String
      switch settings.authorizationStatus {
      case .authorized, .provisional:
        ret = "granted"
      #if swift(>=5.3)
      case .ephemeral:
        ret = "granted"
      #endif
      case .denied:
        ret = "denied"
      case .notDetermined:
        ret = "prompt"
      @unknown default:
        call.reject(JIGPermissionsPlugin.uknownPermissionValue)
        return
      }
      
      call.resolve([
        "state": ret
      ])
    })
  }
  
  func checkClipboard(_ call: JIGPluginCall) {
    call.resolve([
      "state": "granted"
    ])
  }

  func checkMicrophone(_ call: JIGPluginCall) {
    let microStatus = AVCaptureDevice.authorizationStatus(for: .audio)

    let ret: String
    switch (microStatus) {
    case .authorized:
      ret = "granted"
    case .denied, .restricted:
      ret = "denied"
    case .notDetermined:
      ret = "prompt"
    @unknown default:
      call.reject(JIGPermissionsPlugin.uknownPermissionValue)
      return
    }

    call.resolve([
      "state": ret
    ])
  }
}
