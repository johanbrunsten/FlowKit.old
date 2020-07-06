import XCTest
@testable import FlowKit

final class FlowKitTests: XCTestCase {
    
    func testPipeData() {
        let pipe = FlowKit.PipeData(material: .concrete, dimension: 12, slope: 1/100)
        XCTAssertEqual(pipe.dimension, 12)
        
        let secondPipe = FlowKit.PipeData(material: .plastic, dimension: 0.12, z1: 12.4, z2: 13.2, length: 11.4)
        XCTAssertEqual(round(secondPipe.slope*10000)/10000, 0.0702)
    }

    static var allTests = [
        ("testPipeData", testPipeData),
    ]
}
