//
//  Node.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-11-01.
//

import Foundation

extension FlowKit {
    public class Node: Hydraulics {
        public var name: String
        public var nodeType: Materials.NodeType
        public var groundLevel: Double? // Meters above the bottom of the pipe
        public var dimension: Double?
        public var addedFlow: Double
        public var hydraulicGradeLine: Double
        
        public init(name: String, nodeType: Materials.NodeType, groundLevel: Double?, dimension: Double?, addedFlow: Double = 0, hydraulicGradeLine: Double = 0) {
            self.name = name
            self.nodeType = nodeType
            self.groundLevel = groundLevel
            self.dimension = dimension
            self.addedFlow = addedFlow
            self.hydraulicGradeLine = hydraulicGradeLine
        }
    }
}
