import Foundation
import Jigra

/**
 * Please read the Jigra iOS Plugin Development Guide
 * here: https://jigrajs.web.app/docs/plugins/ios
 */
@objc(CLASS_NAME)
public class CLASS_NAME: JIGPlugin {

    @objc func echo(_ call: JIGPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
}
