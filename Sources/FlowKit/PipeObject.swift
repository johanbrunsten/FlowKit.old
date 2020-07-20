//
//  PipeObject.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-15.
//

import Foundation

extension FlowKit {
    public class PipeObject {
        private static let gravitationalAcceleration: Double = 9.82
        
        internal var pipeData: PipeData
        internal var fluid: Materials.Fluid
        internal var maximumFlowRate: Double
        internal var maximumFlowRateVelocity: Double
        
        internal var currentFlowRate: Double?
        internal var currentVelocity: Double?
        internal var currentArea: Double?
        internal var currentHydraulicRadius: Double?
        internal var frictionFactor: Double?
        
        public init(pipeData: FlowKit.PipeData, fluid: Materials.Fluid) {
            self.pipeData = pipeData
            self.fluid = fluid
            
            self.maximumFlowRateVelocity = Self.velocity(pipeData: pipeData, fluid: fluid)
            self.maximumFlowRate = Self.flowRate(pipeData: pipeData, velocity: maximumFlowRateVelocity)
        }
        
        public init(pipeData: FlowKit.PipeData, fluid: Materials.Fluid, currentFlowRate: Double?) {
            self.pipeData = pipeData
            self.fluid = fluid
            
            self.maximumFlowRateVelocity = Self.velocity(pipeData: pipeData, fluid: fluid)
            self.maximumFlowRate = Self.flowRate(pipeData: pipeData, velocity: maximumFlowRateVelocity)
            
            self.currentFlowRate = currentFlowRate
        }
        
        // MARK: - Functions
        
        /// A method that calculates the mean velocity using the Colebrook-White equation
        /// - Parameter pipeData: A PipeData Object
        /// - Parameter fluid: The Pipe Fluid
        /// - Returns: Returns the velocity as a Double in m/s
        internal class func velocity(pipeData: FlowKit.PipeData, fluid: Materials.Fluid) -> Double {
            var dimension: Double
            let gradient = pipeData.gradient
            let pipeRoughness = pipeData.material.rawValue
            let kinematicViscosity = fluid.rawValue
            
            switch pipeData.pipeShape {
            case .circular:
                dimension = pipeData.dimension
            }
            
            // The equation for calculating the mean velocity using Colebrook-White:
            // -2 * sqrt(2 * g * D * S)* log10((k / (3,7 * D) + (2,51 * viscosity / (D * sqrt(2 * g * D * S)))))
            
            let part1 = (2 * gravitationalAcceleration * dimension * gradient).squareRoot()
            let part2 = pipeRoughness / (3.7 * dimension)
            let part3 = (2.51 * kinematicViscosity / (dimension * part1))
            let velocity = -2 * part1 * log10(part2 + part3)
            
            return velocity
        }
        
        /// A methods that caluclates the flow-rate in a pipe
        /// - Parameters:
        ///   - pipeData: A PipeData object
        ///   - velocity: The mean velocity
        /// - Returns: Returns the flow-rate i m3/s
        internal class func flowRate(pipeData: FlowKit.PipeData, velocity: Double) -> Double {
            var pipeArea: Double
            switch pipeData.pipeShape {
            case .circular:
                pipeArea = pow(pipeData.dimension, 2) * Double.pi / 4
            }
            let flowRate = velocity * pipeArea
            
            return flowRate
        }
    }
}
