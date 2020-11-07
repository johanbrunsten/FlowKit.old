//
//  FlowKitNodeTests.swift
//  FlowKitTests
//
//  Created by Johan Brunsten on 2020-11-01.
//

import XCTest
import FlowKit

class FlowKitNodeTests: XCTestCase {
    func testNode() {
        let startNode = FlowKit.Node(nodeType: .breakpoint, dimension: nil, addedFlow: nil)
        let pipeData = FlowKit.PipeData(material: .concrete, dimension: 0.225, length: 20, gradient: 0.01, pipeShape: .circular)
        let pipeObject = FlowKit.PipeObject(pipeData: pipeData, fluid: .water)
        
        let pipeNetwork = FlowKit.PipeNetwork(startNode: startNode, hydraulicsObjects: [pipeObject])
        
        var node = FlowKit.Node(nodeType: .breakpoint, dimension: nil, addedFlow: 0.15)
        pipeNetwork.hydraulicsObjects.append(node)
        pipeNetwork.hydraulicsObjects.append(pipeObject)
        
        node = FlowKit.Node(nodeType: .breakpoint, dimension: nil, addedFlow: 0.12)
        pipeNetwork.hydraulicsObjects.append(node)
        
        let flow = pipeNetwork.flowAtStartNode
        XCTAssertEqual(flow, 0.27)
    }
    
    static var allTests = [
        ("testNode", testNode)
    ]

}
