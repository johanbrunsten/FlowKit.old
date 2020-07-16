import XCTest
@testable import FlowKit

final class FlowKitTests: XCTestCase {
    
    func testPipeData() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        let pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water, currentFlowRate: nil)
        
        let velocity = HydraulicEquations.velocity(pipeObject: pipeObject)
        XCTAssertEqual(round(velocity * 100) / 100, 1.22)
        
    }
    
    func testPartFullPipe() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        var pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water, currentFlowRate: nil)
        
        let fullPipe = FlowKit.FlowRate.maximumFlowRate(pipeObject: pipeObject)
        XCTAssertEqual(round(fullPipe * 1000) / 1000, 0.048)
        
        pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .oliveOil, currentFlowRate: nil)
        let fullPipe2 = FlowKit.FlowRate.maximumFlowRate(pipeObject: pipeObject)
        XCTAssertEqual(round(fullPipe2 * 1000) / 1000, 0.041)
        
        pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water, currentFlowRate: nil)
        let partFull = FlowKit.FlowRate.partFullFlowRate(pipeObject: pipeObject, flowDepth: 0.75)
        XCTAssertEqual(round(partFull * 10000) / 10000, 0.0499)
        
    }
    
    func testReynoldsNumber() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, gradient: 0.01)
        let pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water, currentFlowRate: nil)
        
        let re = HydraulicEquations.reynoldsNumber(pipeObject: pipeObject)
        XCTAssertEqual(round(re), 209119)
        
        let moody = HydraulicEquations.calculateFrictionFactor(pipeObject: pipeObject)
        XCTAssertEqual(round(moody * 10000) / 10000, 0.0298)
    }
    
    func testBrettingsFormula() {
        let pipe = FlowKit.PipeData(material: .plastic, dimension: 0.250, z1: 0.12, z2: 0.42, length: 14.7)
        let pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water, currentFlowRate: 0.06)
        
        let maxFlowRate = FlowKit.FlowRate.maximumFlowRate(pipeObject: pipeObject)
        XCTAssertEqual(round(maxFlowRate * 1000) / 1000, 0.112)

        let brettings = HydraulicEquations.velocityForPartFullPipe(pipeObject: pipeObject)
        XCTAssertEqual(round(brettings * 100) / 100, 2.06)
    }

    static var allTests = [
        ("testPipeData", testPipeData),
        ("testPartFullPipe", testPartFullPipe),
        ("testReynoldsNumber", testReynoldsNumber),
        ("testBrettingsFormula", testBrettingsFormula)
    ]
}
