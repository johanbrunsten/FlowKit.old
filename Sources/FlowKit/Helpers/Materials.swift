//
//  Substance.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-10.
//

import Foundation

public struct Materials {
    /// The different pipe material with associated pipe roughness in meter
    public enum PipeMaterial: CaseIterable {
        case concrete
        case plastic
        
        public var value: (name: String, pipeRoughness: Double) {
            switch self {
            case .concrete: return ("Concrete", 0.001)
            case .plastic: return ("Plastic", 0.0002)
            }
        }
    }
    
    /// The different fluids that the pipes can drain with associated kinematic viscosity in m2 per sec
    /// and density in kg per m3
    public enum Fluid {
        case water
        case air
        case crankcaseOil
        
        public var value: (kinematicViscosity: Double, density: Double) {
            switch self {
            case .water: return (0.00000131, 1000)
            case .air: return (0.00001494, 1.225)
            case .crankcaseOil: return (0.0000198, 850)
            }
        }
    }
}
