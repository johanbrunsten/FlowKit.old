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
                return calculateFlowAtStartNode()
            }
        }
        
        // MARK: - Initializers
        
        public init(startNode: Node, hydraulicsObjects: [Hydraulics]) {
            self.startNode = startNode
            self.hydraulicsObjects = hydraulicsObjects
        }
        
        // MARK: - Methods
        
        /// Calculate the theoretical maximum flow in the node downstream
        /// - Returns: Returns the flow in m3/s
        private func calculateFlowAtStartNode() -> Double {
            var maximumFlow: Double = 0
            
            for object in hydraulicsObjects {
                // Check if the object is a Node or not
                // If not - skip that object
                if let object = object as? Node {
                    // Check if the Node have some added flow
                    // If not - return a flow of zero
                    guard let addedFlow = object.addedFlow else { return 0 }
                    maximumFlow += addedFlow
                }
            }
            
            return maximumFlow
        }
    }
}
