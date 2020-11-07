//
//  PipeNetwork.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-11-01.
//

import Foundation

extension FlowKit {
    public class PipeNetwork {
        // MARK: - Properties
        
        public var startNode: Node
        public var hydraulicsObjects: [Hydraulics]
        public var flowAtStartNode: Double {
            get {
                flowAtNodes[startNode.name]!
            }
        }
        public var flowAtNodes: [String: Double] {
            get {
                return calculateFlowAtNodes()
            }
        }
        
        // MARK: - Initializers
        
        public init(startNode: Node, hydraulicsObjects: [Hydraulics]) {
            self.startNode = startNode
            self.hydraulicsObjects = hydraulicsObjects
        }
        
        // MARK: - Methods
        
        /// Calculate the flow rate throw every node in the Pipe Network
        /// - Returns: Returns a dictionary with the node name as key and the flow rate thru that node in m3/s
        private func calculateFlowAtNodes() -> [String: Double] {
            var nodes: [String: Double] = [:]
            var summedUpFlow: Double = 0
            
            // Loop throw every object and sort out every node.
            // The order is reversed because we want to start from
            //  the top and go to the bottom.
            for object in hydraulicsObjects.reversed() {
                if let node = object as? Node {
                    summedUpFlow += node.addedFlow
                    nodes[node.name] = summedUpFlow
                }
            }
            nodes[startNode.name] = summedUpFlow + startNode.addedFlow
            
            return nodes
        }
    }
}
