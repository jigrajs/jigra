import Foundation

@objc(JIGConsolePlugin)
public class JIGConsolePlugin : JIGPlugin {

  @objc public func log(_ call: JIGPluginCall) {
    let message = call.getString("message") ?? ""
    let level = call.getString("level") ?? "LOG"
    JIGLog.print("⚡️  [\(level)] - \(message)")
  }
}

