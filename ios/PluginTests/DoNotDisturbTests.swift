import XCTest
@testable import DoNotDisturbPlugin

class DoNotDisturbTests: XCTestCase {
    func testStopListeningWithoutStartDoesNotCrash() {
        let implementation = DoNotDisturb()
        implementation.stopListening()
    }

    func testStartAndStopListeningDoesNotCrash() {
        let implementation = DoNotDisturb()
        implementation.startListening { }
        implementation.stopListening()
    }

    func testDoubleStopListeningDoesNotCrash() {
        let implementation = DoNotDisturb()
        implementation.startListening { }
        implementation.stopListening()
        implementation.stopListening()
    }
}
