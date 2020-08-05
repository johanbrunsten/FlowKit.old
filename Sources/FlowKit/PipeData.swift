//
//  PipeData.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-06.
//

import Foundation

extension FlowKit {
    public class PipeData {
        public var material: Materials.Material
        public var dimension: Double
        public var length: Double
        public var gradient: Double
        public var pipeShape: PipeShape
        
        /// Initialize a pipe object there the friction slope is known
        /// - Warning: This initializer is only suited for pipes with a circular cross-sectional shape
        /// - Parameters:
        ///   - material: The material of the pipe
        ///   - dimension: The pipe dimension in meter
        ///   - length: The length of the pipe in meter
        ///   - gradient: The hydraulic gradient, or friction slope, in meter per 100 meter
        ///   - pipeShape: The shape of the pipe
        public init(material: Materials.Material, dimension: Double, length: Double, gradient: Double, pipeShape: PipeShape) {
            self.material = material
            self.dimension = dimension
            self.pipeShape = pipeShape
            self.gradient = gradient
            self.length = length
        }
        
        /// Initialize a pipe object there the friction slope is unknown and is needed to be calculated
        /// - Warning: This initializer is only suited for pipes with a circular cross-sectional shape
        /// - Parameters:
        ///   - material: The material of the pipe
        ///   - dimension: The pipe dimension in meter
        ///   - length: The length of the pipe in meter
        ///   - z1: The first level in meter
        ///   - z2: The second level in meter
        ///   - pipeShape: The shape of the pipe
        public init(material: Materials.Material, dimension: Double, length: Double, z1: Double, z2: Double, pipeShape: PipeShape) {
            self.material = material
            self.dimension = dimension
            self.length = length
            self.pipeShape = pipeShape
            
            // Calculates the gradient by calculate the absolut value between
            // the heights and divide it by its length
            self.gradient = fabs(z1 - z2) / length
        }
    }
    
    public enum PipeShape {
        case circular
    }
}
