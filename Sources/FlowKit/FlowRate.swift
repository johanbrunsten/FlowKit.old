//
//  FlowRate.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-08.
//

import Foundation

extension FlowKit {
    internal enum FlowRateError: Error {
        case cantCalculateTheVelocity
        case cantCalculateTheArea
    }
    
    public class FlowRate {
        /// A method that calculates the flow-rate in the pipe based on the flow depth
        /// - Parameters:
        ///   - pipeObject: A PipeObject
        ///   - flowDepth: A number between 0.0 and 1.0 indicating the flow depth
        public class func partFullFlowRate(pipeObject: FlowKit.PipeObject, flowDepth: Double) throws {
            let partFullFlowDepth = DegreesToRadians.radians(from: flowDepth * 360)
            
            pipeObject.currentArea = pow(pipeObject.pipeData.dimension, 2) / 8 * (partFullFlowDepth - sin(partFullFlowDepth))
            let wettedPerimeter = pipeObject.pipeData.dimension * partFullFlowDepth / 2
            guard let currentArea = pipeObject.currentArea else {
                throw FlowRateError.cantCalculateTheArea
            }
            pipeObject.currentHydraulicRadius = currentArea / wettedPerimeter
            
            HydraulicEquations.velocityForPartFullPipe(pipeObject: pipeObject)
            guard let velocity = pipeObject.currentVelocity else {
                throw FlowRateError.cantCalculateTheVelocity
            }
            let flowRate = velocity * currentArea
            
            pipeObject.currentFlowRate = flowRate
        }
    }
}
