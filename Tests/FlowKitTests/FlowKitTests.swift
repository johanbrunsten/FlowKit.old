import XCTest
@testable import FlowKit

final class FlowKitTests: XCTestCase {
    
    func testPipeData() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        
        let velocity = HydraulicEquations.velocity(pipeData: pipe, substance: .water)
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
    
    func testReynoldsNumber() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        let re = HydraulicEquations.reynoldsNumber(pipeData: pipe, substance: .water)
        XCTAssertEqual(round(re), 209119)
        
        let moody = HydraulicEquations.calculateFrictionFactor(pipeData: pipe, substance: .water)
        XCTAssertEqual(round(moody * 10000) / 10000, 0.0298)
    }
    
    func testBrettingsFormula() {
        let pipe = FlowKit.PipeData(material: .plastic, dimension: 0.250, z1: 0.12, z2: 0.42, length: 14.7)
        
        let maxFlowRate = FlowKit.FlowRate.maximumFlowRate(pipeData: pipe, substance: .water)
        XCTAssertEqual(round(maxFlowRate * 1000) / 1000, 0.112)

        let brettings = HydraulicEquations.velocityForPartFullPipe(pipeData: pipe, substance: .water, flowRate: 0.06)
        XCTAssertEqual(round(brettings * 100) / 100, 2.06)
    }

    static var allTests = [
        ("testPipeData", testPipeData),
        ("testPartFullPipe", testPartFullPipe),
        ("testReynoldsNumber", testReynoldsNumber),
        ("testBrettingsFormula", testBrettingsFormula)
    ]
}
