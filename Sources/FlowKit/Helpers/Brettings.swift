//
//  Brettings.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-14.
//

import Foundation

internal class Brettings {
    /// A method that calculates the velocity in a part-full pipe
    /// - Parameters:
    ///   - pipeData: A PipeData object
    ///   - substance: The substance what is sent throw the pipe
    ///   - flowRate: The current flow-rate in the pipe in m3/s
    /// - Returns: Retuns a double with the velocity in m/s
    internal class func velocityForPartFullPipe(pipeData: FlowKit.PipeData, substance: Materials.Fluid, flowRate: Double) -> Double {
        let maximumFlowRate = FlowKit.FlowRate.maximumFlowRate(pipeData: pipeData, substance: substance)
        // The percentage value of the flow-rate
        let partFullFlowRate = flowRate / maximumFlowRate
        
        // Check if the flow-rate is higher then the pipes capacity
        // If so - return a negative value
        // TODO: How to handle error messaging
        if partFullFlowRate > 1 {
            return -1
        }
        
        // The depth of flow is calculated using Betting's equation
        let depthOfFlow = pipeData.dimension / Double.pi * acos(3.125 - (pow(3.125, 2) - 5.25 + 12.5 * partFullFlowRate).squareRoot())
        
        // Calculate the part-full cross-sectional area
        // θ = 2 * cos^-1[1 - 2d / D]
        // A = D^2 / 8 * (θ - sin[θ])
        let angel = 2 * acos(1 - 2 * depthOfFlow / pipeData.dimension)
        let area = pow(pipeData.dimension, 2) / 8 * (angel - sin(angel))
        
        // The velocity is calculated by dividing the flow-rate with
        // the just calculated area
        let velocity = flowRate / area
        
        return velocity
    }
}
