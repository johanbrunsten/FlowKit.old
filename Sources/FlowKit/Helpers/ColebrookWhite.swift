//
//  ColebrookWhite.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-07.
//

import Foundation

internal class ColebrookWhite {
    private static let gravitationalAcceleration: Double = 9.82
    
    /// A method that calculates the mean velocity using the Colebrook-White equation
    /// - Parameter pipeData: A PipeData object
    /// - Parameter substance: The substance what is sent throw the pipe
    /// - Returns: Returns a double with the velocity in m/s
    internal class func velocity(pipeData: FlowKit.PipeData, substance: Materials.Fluid) -> Double {
        let hydraulicRadius = 4 * pipeData.hydraulicRadius
        let frictionSlope = pipeData.gradient
        let pipeRoughness = pipeData.material.rawValue
        let kinematicViscosity = substance.rawValue
        
        // The equation for calculating the mean velocity using Colebrook-White:
        // -2 * sqrt(2 * g * D * S)* log10((k / (3,7 * D) + (2,51 * viscosity / (D * sqrt(2 * g * D * S)))))
        
        let part1 = (2 * gravitationalAcceleration * hydraulicRadius * frictionSlope).squareRoot()
        let part2 = pipeRoughness / (3.7 * hydraulicRadius)
        let part3 = (2.51 * kinematicViscosity / (hydraulicRadius * part1))
        let velocity = -2 * part1 * log10(part2 + part3)
        
        return velocity
    }
    
    // MARK: - Moody Chart Calculator
    // The Moody chart is based on the solutions to the Colebrook equation.
    // This calculator uses Newton's method for finding zeros to solve the Colebrook equation.
    
    /// A method that calculates reynolds number
    /// - Parameters:
    ///   - pipeData: A PipeData object
    ///   - substance: The substance what is sent throw the pipe
    /// - Returns: Returns reynolds number as a double
    internal class func reynoldsNumber(pipeData: FlowKit.PipeData, substance: Materials.Fluid) -> Double {
        let dimension = pipeData.dimension
        let kinematicViscosity = substance.rawValue
        let velocity = ColebrookWhite.velocity(pipeData: pipeData, substance: substance)
        
        let reynoldsNumber = velocity * dimension / kinematicViscosity
        return reynoldsNumber
    }
    
    /// A method for calculating the friction factor
    /// - Parameters:
    ///   - pipeData: A PipeData object
    ///   - substance: The substance what is sent throw the pipe
    /// - Returns: Return the fricton factor as a double
    internal class func calculateFrictionFactor(pipeData: FlowKit.PipeData, substance: Materials.Fluid) -> Double {
        // Special thank to
        // http://maleyengineeringprojects.weebly.com/moody-chart-calculator-design.html
        // for providing the formula
        
        // Calculate reynolds number
        let reynoldsNumber = Self.reynoldsNumber(pipeData: pipeData, substance: substance)
        
        if (reynoldsNumber <= 2300) {
            // Laminar flow
            return (64 / reynoldsNumber)
        } else if (reynoldsNumber < 4000) {
            // Transitional flow aka critical zone
            
            // A friction factor can't be calculated
            // without testing
            // TODO: How to handle error messaging
            return -1.0
        }
        
        // Turbulent flow
        let relativeRoughness = pipeData.material.rawValue / pipeData.dimension
        
        var x: Double
        var y: Double
        var dy: Double
        var a: Double
        var b: Double
        let i: Int
        
        a = relativeRoughness / 3.7
        b = 2.51 / reynoldsNumber
        i = 3 // Number of iterations for Newton's Method
        
        x = -1.8 * (log10((6.9 / reynoldsNumber) + (pow(a, 1.11))))
        
        for _ in 0...i {
            y = x + (2 * log10(a + (b * x)))
            dy = 1 + (2 * (b / log(10)) / (a + (b * x)))
            x = x - (y / dy)
        }
        
        return 1 / (pow(x,2))
    }
}
