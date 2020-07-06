//
//  PipeData.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-06.
//

import Foundation

extension FlowKit {
    public class PipeData {
        internal var material: Material
        internal var dimension: Double
        internal var slope: Double
        
        /// Initialize a pipe object there the friction slope is known
        /// - Parameters:
        ///   - material: The material of the pipe
        ///   - dimension: The pipe dimension in meter
        ///   - slope: The hydraulic gradient, or friction slope, in meter per 100 meter
        public init(material: Material, dimension: Double, slope: Double) {
            self.material = material
            self.dimension = dimension
            self.slope = slope
        }
        
        /// Initialize a pipe object there the friction slope is unknown
        /// - Parameters:
        ///   - material: The material of the pipe
        ///   - dimension: The pipe dimension in meter
        ///   - z1: The first height in meter
        ///   - z2: The second height in meter
        ///   - lenght: The length of the pipe in meter
        public init(material: Material, dimension: Double, z1: Double, z2: Double, length: Double) {
            self.material = material
            self.dimension = dimension
            
            self.slope = fabs(z1 - z2)/length
        }
        
        public enum Material {
            case concrete
            case plastic
        }
    }
}
