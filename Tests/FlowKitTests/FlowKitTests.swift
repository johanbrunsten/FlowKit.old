import XCTest
@testable import FlowKit

final class FlowKitTests: XCTestCase {
    
    func testPipeData() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        
        let capacity = FlowKit.FlowRate.maximumFlowRate(pipeData: pipe)
        
        XCTAssertEqual(round(capacity * 1000) / 1000, 0.048)
        
        let velocity = ColebrookWhite.velocity(pipeData: pipe)
        XCTAssertEqual(round(velocity * 100) / 100, 1.22)
        
    }

    static var allTests = [
        ("testPipeData", testPipeData),
    ]
}
