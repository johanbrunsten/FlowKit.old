//
//  ColebrookWhite.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-07.
//

import Foundation

internal class ColebrookWhite {
    private static let kinematicViscosity: Double = 0.00000131 // Kinematic viscosity of water
    private static let gravitationalAcceleration: Double = 9.82
    
    /// A method that calculates the mean velocity using the Colebrook-White equation
    /// - Parameter pipeData: A PipeData object
    /// - Returns: Returns a double with the velocity in m/s
    internal class func velocity(pipeData: FlowKit.PipeData) -> Double {
        let dimension = pipeData.dimension
        let frictionSlope = pipeData.slope
        let pipeRoughness = pipeData.material.rawValue
        
        let part1 = (2 * gravitationalAcceleration * dimension * frictionSlope).squareRoot()
        let part2 = pipeRoughness / (3.7 * dimension)
        let part3 = (2.51 * kinematicViscosity / (dimension * part1))
        let velocity = -2 * part1 * log10(part2 + part3)
        
        return velocity
    }
}
