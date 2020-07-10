import XCTest
@testable import FlowKit

final class FlowKitTests: XCTestCase {
    
    func testPipeData() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        
        let velocity = ColebrookWhite.velocity(pipeData: pipe, substance: .water)
        XCTAssertEqual(round(velocity * 100) / 100, 1.22)
        
    }
    
    func testPartFullPipe() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        
        let fullPipe = FlowKit.FlowRate.maximumFlowRate(pipeData: pipe, substance: .water)
        XCTAssertEqual(round(fullPipe * 1000) / 1000, 0.048)
        
        let fullPipe2 = FlowKit.FlowRate.maximumFlowRate(pipeData: pipe, substance: .oliveOil)
        XCTAssertEqual(round(fullPipe2 * 1000) / 1000, 0.041)
        
        let partFull = FlowKit.FlowRate.partFullFlowRate(pipeData: pipe, substance: .water, flowDepth: 0.75)
        XCTAssertEqual(round(partFull * 10000) / 10000, 0.0499)
        
    }

    static var allTests = [
        ("testPipeData", testPipeData),
        ("testPartFullPipe", testPartFullPipe)
    ]
}
