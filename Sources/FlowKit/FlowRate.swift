//
//  FlowRate.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-08.
//

import Foundation

extension FlowKit {
    public class FlowRate {
        /// A method that calculates the maximum flow-rate the pipe can drain
        /// - Parameter pipeData: A PipeData object
        /// - Parameter substance: The substance what is sent throw the pipe
        /// - Returns: Returns a double with the flow-rate in m3/s
        public class func maximumFlowRate(pipeObject: FlowKit.PipeObject) -> Double {
            let velocity = HydraulicEquations.velocity(pipeObject: pipeObject)
            let pipeArea = pow(pipeObject.pipeData.dimension, 2) * Double.pi / 4

            let flowRate = velocity * pipeArea
            return flowRate
        }
        
        /// A method that calculates the flow-rate in the pipe based on the flow depth
        /// - Parameters:
        ///   - pipeData: A PipeData object
        ///   - substance: The substance what is sent throw the pipe
        ///   - flowDepth: A number between 0.0 and 1.0 indicating the flow depth
        /// - Returns: Retuns a double with the flow-rate in m3/s
        public class func partFullFlowRate(pipeObject: FlowKit.PipeObject, flowDepth: Double) -> Double {
            let partFullFlowDepth =  DegreesToRadians.radians(from: flowDepth * 360)
            
            let area = pow(pipeObject.pipeData.dimension, 2) / 8 * (partFullFlowDepth - sin(partFullFlowDepth))
            let wettedPerimeter = pipeObject.pipeData.dimension * partFullFlowDepth / 2
            let hydraulicRadius = area / wettedPerimeter
            pipeObject.pipeData.hydraulicRadius = hydraulicRadius
            
            let velocity = HydraulicEquations.velocity(pipeObject: pipeObject)
            let flowRate = velocity * area
            
            return flowRate
        }
    }
}
