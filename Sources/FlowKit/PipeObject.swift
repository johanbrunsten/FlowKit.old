//
//  PipeObject.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-28.
//

import Foundation

extension FlowKit {
    public class PipeObject {
        // MARK: - Properties
        
        public var pipeData: PipeData
        internal var fluid: Materials.Fluid
        
        /*
        Current Depth
        The parameter named depth is being called
        but the value is stored in _depth
        */
        private var _depth: Double?
        public var depth: Double? {
            set {
                // Check so that the new value isn't larger then the pipes dimension
                if newValue ?? .nan <= pipeData.dimension {
                    // Assign the new value and calculate the flow-rate
                    _depth = newValue
                    self._currentFlowRate = calcFlowRate()
                } else {
                    // Can't assign the value - set current values to nil and print a message
                    print("\(String(describing: newValue)) is larger than the pipe dimension (\(self.pipeData.dimension)) and is not valid")
                    _depth = nil
                    _currentFlowRate = nil
                }
            } get {
                return _depth
            }
        }
        
        /*
         Current Flow-rate
         The parameter named currentFlowRate is being called
         but the value is stored in _currentFlowRate
         */
        private var _currentFlowRate: Double?
        public var currentFlowRate: Double? {
            set {
                // Check so that the new value isn't larger then the pipes capacity
                if newValue ?? .nan <= self.fullPipeFlowRate {
                    // Assign the new value and calculate the new depth
                    _currentFlowRate = newValue
                    self._depth = calcDepth()
                } else {
                    // Can't assign the value - set current values to nil and print a message
                    print("\(String(describing: newValue)) is larger than maximum flow-rate (\(self.fullPipeFlowRate)) and is not valid")
                    _currentFlowRate = nil
                    _depth = nil
                }
                
            } get {
                return _currentFlowRate
            }
        }
        
        public lazy var fullPipeVelocity: Double = {
            let gravitationalAcceleration = 9.82
            let diameter = pipeData.dimension
            let gradient = pipeData.gradient
            let pipeRoughness = pipeData.material.rawValue
            let kinematicViscosity = fluid.rawValue
            
            switch pipeData.pipeShape {
            case .circular:
                let part1 = (2 * gravitationalAcceleration * diameter * gradient).squareRoot()
                let part2 = pipeRoughness / (3.7 * diameter)
                let part3 = (2.51 * kinematicViscosity / (diameter * part1))
                let velocity = -2 * part1 * log10(part2 + part3)
                
                return velocity
            }
        }()
        
        public var fullPipeFlowRate: Double {
            get {
                // The equation works for all pipe shapes
                let area = Double.pi * pow(pipeData.dimension, 2) / 4
                let flowRate = fullPipeVelocity * area
                return flowRate
            }
        }
        
        private var _theta: Double?
        private var theta: Double? {
            set {
                switch pipeData.pipeShape {
                case .circular:
                    guard let depth = self.depth else { return }
                    _theta = 2 * acos(1 - 2 * depth / self.pipeData.dimension)
                }
            } get {
                return _theta
            }

        }
        
        public var currentVelocity: Double? {
            get {
                // The equation works for all pipe shapes
                guard let currentFlowRate = self.currentFlowRate, let area = self.area else { return nil }
                let velocity = currentFlowRate / area
                return velocity
            }
        }
        
         public var area: Double? {
            get {
                switch pipeData.pipeShape {
                case .circular:
                    guard let theta = self.theta else { return nil }
                    print("AREA: dimension \(pipeData.dimension) - theta \(theta)")
                    return pow(pipeData.dimension, 2) / 8 * (theta - sin(theta))
                }
            }
        }
        
        private var wettedPerimeter: Double? {
            get {
                switch pipeData.pipeShape {
                case .circular:
                    guard let theta = self.theta else { return nil }
                    return pipeData.dimension * theta / 2
                }
            }
        }
        
        private var hydraulicRadius: Double? {
            get {
                // The equation works for all pipe shapes
                guard let area = self.area, let wettedPerimeter = self.wettedPerimeter else { return nil }
                return area / wettedPerimeter
            }
        }
        
        public var frictionFactor: Double? {
            // Not certain that the equation works for different pipe shapes then circular.
            // I put it as an attribut for circular pipe shape for the moment.
            get {
                switch pipeData.pipeShape {
                case .circular:
                    return calcFrictionFactor()
                }
            }
        }
        
        // MARK: - Initializers
        
        /// Initialize a PipeObject with no current flow
        /// - Parameters:
        ///   - pipeData: A PipeData object
        ///   - fluid: The fluid the pipe is designed for
        public init(pipeData: PipeData, fluid: Materials.Fluid) {
            self.pipeData = pipeData
            self.fluid = fluid
        }
        
        /// Initialize a PipeObject where the depth of the fluid is known
        /// - Note: Depth will be set to nil if the specified depth is larger then the pipe dimension
        /// - Parameters:
        ///   - pipeData: A PipeData object
        ///   - fluid: The fluid the pipe is designed for
        ///   - depth: The depth in the pipe i meter
        public init(pipeData: PipeData, fluid: Materials.Fluid, depth: Double) {
            self.pipeData = pipeData
            self.fluid = fluid
            self.depth = depth
        }
        
        /// Initialize a PipeObject where the current flow is known
        /// - Note: CurrentFlow will be set to nil if the specified flow is higher then the pipe capacity when full
        /// - Parameters:
        ///   - pipeData: A PipeData object
        ///   - fluid: The fluid the pipe is designed for
        ///   - currentFlow: The current flow in the pipe in m3/s
        public init(pipeData: PipeData, fluid: Materials.Fluid, currentFlow: Double) {
            self.pipeData = pipeData
            self.fluid = fluid
            self.currentFlowRate = currentFlow
        }
        
        // MARK: - Methods
        
        /// Method for calculate the depth in the pipe if the current flow is known
        /// - Returns: Returns a double for the depth in meter
        private func calcDepth() -> Double? {
            guard let currentFlowRate = self.currentFlowRate else {
                return nil }
            let partFullFlowRate = currentFlowRate / fullPipeFlowRate
            
            // The depth of flow is calculated using Bretting's equation
            let depthOfFlow = pipeData.dimension / Double.pi * acos(3.125 - (pow(3.125, 2) - 5.25 + 12.5 * partFullFlowRate).squareRoot())
            return depthOfFlow
        }
        
        /// Method for calculate the current flow in the pipe if the depth is known
        /// - Returns: Returns a double for the flow in m3/s
        public func calcFlowRate() -> Double? {
            guard let depth = self.depth else { return nil }
            let partFull = depth / self.pipeData.dimension
            
            // The flow is calculated using Bretting's equation
            let partFlowRate = 0.46 - 0.5 * cos(Double.pi * partFull) + 0.04 * cos(2 * Double.pi * partFull)
            return partFlowRate * fullPipeFlowRate
        }
        
        /// A method for calculating the friction factor for a pipe using Colebrook equation
        /// - Returns: Returns a double with the friction factor
        private func calcFrictionFactor() -> Double? {
            // Special thank to
            // http://maleyengineeringprojects.weebly.com/moody-chart-calculator-design.html
            // for providing the formula
            
            // Calculate reynolds number (RN)
            // If the pipe has no assigned current flow (with associated
            // velocity) the equation will use the velocity for a pipe
            // with the whole cross-section filled
            let velocity = self.currentVelocity ?? self.fullPipeVelocity
            let reynoldsNumber = velocity * pipeData.dimension / fluid.rawValue
            
            if (reynoldsNumber <= 2300) {
                // If RN is 2300 or lower the flow is laminar and a
                // simplified equation can be used
                return 64 / reynoldsNumber
            } else if (reynoldsNumber < 4000) {
                // If RN is between 2300+ and 4000 the flow is
                // transitional (aka critical zone) and a friction
                // factor can not be calculated for this kind of flow
                return nil
            }
            
            // If RN is above 4000 the flow is turbulent and can be
            // calculated with a more cumbersome equation then for
            // a laminar flow
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
            
            x = -1.8 * (log10(6.9 / reynoldsNumber) + pow(a, 1.11))
            
            for _ in 0...i {
                y = x + (2 * log10(a + (b * x)))
                dy = 1 + (2 * (b / log(10)) / (a + (b * x)))
                x = x - (y / dy)
            }
            
            let frictionFactor = 1 / pow(x, 2)
            return frictionFactor
        }
    }
}
