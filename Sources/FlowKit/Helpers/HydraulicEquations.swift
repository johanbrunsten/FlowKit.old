//
//  ColebrookWhite.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-07.
//

import Foundation

internal class HydraulicEquations {
    private static let gravitationalAcceleration: Double = 9.82
    
        // MARK: - Colebrook-White
    
    /// A method that calculates the mean velocity using the Colebrook-White equation
    /// - Parameter pipeObject: A PipeObject
    internal class func velocityForMaximumFlowRate(pipeObject: FlowKit.PipeObject) {
        let hydraulicRadius = 4 * pipeObject.hydraulicRadius
        let frictionSlope = pipeObject.pipeData.gradient
        let pipeRoughness = pipeObject.pipeData.material.rawValue
        let kinematicViscosity = pipeObject.fluid.rawValue
        
        // The equation for calculating the mean velocity using Colebrook-White:
        // -2 * sqrt(2 * g * D * S)* log10((k / (3,7 * D) + (2,51 * viscosity / (D * sqrt(2 * g * D * S)))))
        
        let part1 = (2 * gravitationalAcceleration * hydraulicRadius * frictionSlope).squareRoot()
        let part2 = pipeRoughness / (3.7 * hydraulicRadius)
        let part3 = (2.51 * kinematicViscosity / (hydraulicRadius * part1))
        let velocity = -2 * part1 * log10(part2 + part3)
        
        pipeObject.maximumFlowRateVelocity = velocity
    }
    
    // MARK: - Moody Chart Calculator
    // The Moody chart is based on the solutions to the Colebrook equation.
    // This calculator uses Newton's method for finding zeros to solve the Colebrook equation.
    
    /// A method that calculates reynolds number
    /// - Parameters:
    ///   - pipeObject: A PipeObject
    /// - Returns: Returns reynolds number as a double
    internal class func reynoldsNumber(pipeObject: FlowKit.PipeObject) -> Double? {
        let dimension = pipeObject.pipeData.dimension
        let kinematicViscosity = pipeObject.fluid.rawValue
        guard let velocity = pipeObject.currentVelocity else { return nil }
        
        let reynoldsNumber = velocity * dimension / kinematicViscosity
        return reynoldsNumber
    }
    
    /// A method for calculating the friction factor
    /// - Parameters:
    ///   - pipeObject: A PipeObject
    internal class func calculateFrictionFactor(pipeObject: FlowKit.PipeObject) {
        // Special thank to
        // http://maleyengineeringprojects.weebly.com/moody-chart-calculator-design.html
        // for providing the formula
        
        // Calculate reynolds number
        guard let reynoldsNumber = Self.reynoldsNumber(pipeObject: pipeObject) else {
            return
        }
        
        if (reynoldsNumber <= 2300) {
            // Laminar flow
            pipeObject.frictionFactor = 64 / reynoldsNumber
        } else if (reynoldsNumber < 4000) {
            // Transitional flow aka critical zone
            // A friction factor can't be calculated
            pipeObject.frictionFactor = nil
        }
        
        // Turbulent flow
        let relativeRoughness = pipeObject.pipeData.material.rawValue / pipeObject.pipeData.dimension
        
        var x: Double
        var y: Double
        var dy: Double
        var a: Double
        var b: Double
        let i: Int
        
        a = relativeRoughness / 3.7
        b = 2.51 / reynoldsNumber
        i = 3 // Number of iterations for Newton's Method
        
        x = -1.8 * (log10(6.9 / reynoldsNumber) + pow(a, 1.11))
        
        for _ in 0...i {
            y = x + (2 * log10(a + (b * x)))
            dy = 1 + (2 * (b / log(10)) / (a + (b * x)))
            x = x - (y / dy)
        }
        
        pipeObject.frictionFactor = 1 / pow(x, 2)
    }
    
    // MARK: - Brettings
    
    /// A method that calculates the velocity in a part-full pipe
    /// - Parameters:
    ///   - pipeObject: A PipeObject
    internal class func velocityForPartFullPipe(pipeObject: FlowKit.PipeObject) {
        guard let currentFlowRate = pipeObject.currentFlowRate else {
            // The pipe object have not been assigned a current flow-rate value
            // TODO: How to handle error messaging
            return
        }
        
        do {
            try FlowKit.FlowRate.maximumFlowRate(pipeObject: pipeObject)
        } catch {
            print(error)
        }
        
        guard let maximumFlowRate = pipeObject.maximumFlowRate else {
            return
        }
        // The percentage value of the flow-rate
        let partFullFlowRate = currentFlowRate / maximumFlowRate
        
        // Check if the flow-rate is higher then the pipes capacity
        // If so - return nil
        // TODO: How to handle error messaging
        if partFullFlowRate > 1 {
            pipeObject.currentVelocity = nil
        }
        
        // The depth of flow is calculated using Betting's equation
        let depthOfFlow = pipeObject.pipeData.dimension / Double.pi * acos(3.125 - (pow(3.125, 2) - 5.25 + 12.5 * partFullFlowRate).squareRoot())
        
        // Calculate the part-full cross-sectional area
        // θ = 2 * cos^-1[1 - 2d / D]
        // A = D^2 / 8 * (θ - sin[θ])
        let angel = 2 * acos(1 - 2 * depthOfFlow / pipeObject.pipeData.dimension)
        pipeObject.currentArea = pow(pipeObject.pipeData.dimension, 2) / 8 * (angel - sin(angel))
        
        // The velocity is calculated by dividing the flow-rate with
        // the just calculated area
        guard let currentArea = pipeObject.currentArea else {
            return
        }
        let velocity = currentFlowRate / currentArea
        
        pipeObject.currentVelocity = velocity
    }
}
