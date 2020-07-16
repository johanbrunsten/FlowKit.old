import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FlowKitTests.allTests),
        testCase(PipeObjectTests.allTests)
    ]
}
#endif
