//
//  PipeData.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-06.
//

import Foundation

extension FlowKit {
    public struct PipeData {
        internal var material: Materials.Material
        public var dimension: Double {
            didSet {
                print("Dimension changed (\(self.dimension)")
            }
        }
        internal var pipeShape: PipeShape
        internal var gradient: Double
        
        /// Initialize a pipe object there the friction slope is known
        /// - Warning: This initializer is only suited for pipes with a circular cross-sectional shape
        /// - Parameters:
        ///   - material: The material of the pipe
        ///   - dimension: The pipe dimension in meter
        ///   - gradient: The hydraulic gradient, or friction slope, in meter per 100 meter
        public init(material: Materials.Material, dimension: Double, pipeShape: PipeShape, gradient: Double) {
            self.material = material
            self.dimension = dimension
            self.pipeShape = pipeShape
            self.gradient = gradient
        }
        
        /// Initialize a pipe object there the friction slope is unknown and is needed to be calculated
        /// - Warning: This initializer is only suited for pipes with a circular cross-sectional shape
        /// - Parameters:
        ///   - material: The material of the pipe
        ///   - dimension: The pipe dimension in meter
        ///   - z1: The first level in meter
        ///   - z2: The second level in meter
        ///   - length: The length of the pipe in meter
        public init(material: Materials.Material, dimension: Double, pipeShape: PipeShape, z1: Double, z2: Double, length: Double) {
            self.material = material
            self.dimension = dimension
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
