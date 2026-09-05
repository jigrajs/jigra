public class JIGFile {
  var url: URL
  
  public init(url: URL) {
    self.url = url
  }
}

/**
 * JIGFileManager helps map file schemes to physical files, whether they are on
 * disk, in a bundle, or in another location.
 */
@objc public class JIGFileManager: NSObject {
  static func get(path: String) -> JIGFile? {
    let handlers: [String:JIGFileResolver.Type] = [
      "res://": JIGFileResolverResource.self,
      "file://": JIGFileResolverFile.self,
      "base64:": JIGFileResolverNotImplemented.self
    ]

    for (handlerPrefix, handler) in handlers {
      if path.hasPrefix(handlerPrefix) {
        return handler.resolve(path: path)
      }
    }
    
    return nil
  }
  
  public static func getPortablePath(host: String, uri: URL?) -> String? {
    if uri != nil {
        let uriWithoutFile = uri!.absoluteString.replacingOccurrences(of: "file://", with: "")
        return host + JIGBridge.JIG_FILE_START + uriWithoutFile
    }
    return nil
  }
}

private protocol JIGFileResolver {
  static func resolve(path: String) -> JIGFile?
}

private class JIGFileResolverFile: JIGFileResolver {
  public static func resolve(path: String) -> JIGFile? {
    let manager = FileManager.default
    let absPath = path.replacingOccurrences(of: "file:///", with: "")
    if !manager.fileExists(atPath: absPath) {
      return nil
    }
    return JIGFile(url: URL(fileURLWithPath: absPath))
  }
  
}

private class JIGFileResolverResource: JIGFileResolver {
  public static func resolve(path: String) -> JIGFile? {
    let manager = FileManager.default
    let bundle = Bundle.main
    let resourcePath = bundle.resourcePath
    
    var absPath = path.replacingOccurrences(of: "res://", with: "")
    absPath = resourcePath! + "/" + absPath
    if !manager.fileExists(atPath: absPath) {
      return nil
    }
    return JIGFile(url: URL(fileURLWithPath: absPath))
  }
}

private class JIGFileResolverNotImplemented: JIGFileResolver {
  public static func resolve(path: String) -> JIGFile? {
    return nil
  }
}
