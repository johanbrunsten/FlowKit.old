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
        /// - Parameter pipeObject: A PipeObject
        public class func maximumFlowRate(pipeObject: FlowKit.PipeObject) {
            HydraulicEquations.velocityForMaximumFlowRate(pipeObject: pipeObject)
            HydraulicEquations.velocityForMaximumFlowRate(pipeObject: pipeObject)
            guard let velocity = pipeObject.maximumFlowRateVelocity else {
                return
            }
            let pipeArea = pow(pipeObject.pipeData.dimension, 2) * Double.pi / 4

            let flowRate = velocity * pipeArea
            pipeObject.maximumFlowRate = flowRate
        }
        
        /// A method that calculates the flow-rate in the pipe based on the flow depth
        /// - Parameters:
        ///   - pipeObject: A PipeObject
        ///   - flowDepth: A number between 0.0 and 1.0 indicating the flow depth
        public class func partFullFlowRate(pipeObject: FlowKit.PipeObject, flowDepth: Double) {
            let partFullFlowDepth = DegreesToRadians.radians(from: flowDepth * 360)
            
            let area = pow(pipeObject.pipeData.dimension, 2) / 8 * (partFullFlowDepth - sin(partFullFlowDepth))
            let wettedPerimeter = pipeObject.pipeData.dimension * partFullFlowDepth / 2
            let hydraulicRadius = area / wettedPerimeter
            pipeObject.hydraulicRadius = hydraulicRadius
            
            HydraulicEquations.velocityForPartFullPipe(pipeObject: pipeObject)
            guard let velocity = pipeObject.currentVelocity else {
                return
            }
            let flowRate = velocity * area
            
            pipeObject.currentFlowRate = flowRate
        }
    }
}
