import Foundation
import Testing
@testable import __NAME__

struct __NAME__Tests {
    @Test func runsInsideTheApp() {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        #expect(displayName == "__DISPLAY_NAME__")
    }
}
