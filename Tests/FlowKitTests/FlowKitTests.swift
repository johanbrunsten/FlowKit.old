import XCTest
@testable import FlowKit

final class FlowKitTests: XCTestCase {
    
    func testPipeData() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, pipeShape: .circular, gradient: 0.01)
        let pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water)
        XCTAssertEqual(round(pipeObject.fullPipeVelocity * 100) / 100, 1.22)
        
        let velocity = pipeObject.fullPipeVelocity
        XCTAssertEqual(round(velocity * 100) / 100, 1.22)
        
    }
    
    func testPartFullPipe() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, pipeShape: .circular, gradient: 0.01)
        var pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water)
        XCTAssertEqual(round(pipeObject.fullPipeFlowRate * 1000) / 1000, 0.048)
        
        pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .honey)
        XCTAssertEqual(round(pipeObject.fullPipeFlowRate * 1000) / 1000, 0.038)
        
        pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .oliveOil)
        XCTAssertEqual(round(pipeObject.fullPipeFlowRate * 1000) / 1000, 0.041)
        
        pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water)
        
        guard let partFull = pipeObject.currentFlowRate else {
            return
        }
        XCTAssertEqual(round(partFull * 10000) / 10000, 0.0499)
        
    }
    
    func testReynoldsNumber() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 0.225, pipeShape: .circular, gradient: 0.01)
        let pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water)
        
        guard let frictionFactor = pipeObject.frictionFactor else {
            return
        }
        XCTAssertEqual(round(frictionFactor * 10000) / 10000, 0.0298)
    }
    
    func testBrettingsFormula() {
        let pipe = FlowKit.PipeData(material: .plastic, dimension: 0.250, pipeShape: .circular, z1: 0.12, z2: 0.42, length: 14.7)
        let pipeObject = FlowKit.PipeObject(pipeData: pipe, fluid: .water, currentFlow: 0.06)
        
        
        let maxFlowRate = pipeObject.fullPipeFlowRate
        XCTAssertEqual(round(maxFlowRate * 1000) / 1000, 0.112)

        guard let frictionFactor = pipeObject.frictionFactor else {
            return
        }
        XCTAssertEqual(round(frictionFactor * 100000) / 100000, 0.01949)
    }

    static var allTests = [
        ("testPipeData", testPipeData),
        ("testPartFullPipe", testPartFullPipe),
        ("testReynoldsNumber", testReynoldsNumber),
        ("testBrettingsFormula", testBrettingsFormula)
    ]
}
