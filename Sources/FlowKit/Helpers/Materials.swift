//
//  Substance.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-10.
//

import Foundation

public struct Materials {
    /// The different pipe material with associated pipe roughness in meter
    public enum Material: Double {
        case concrete = 0.001
        case plastic = 0.0002
    }
    
    /// The different fluids that the pipes can drain with associated viscosity in m2 per sec
    public enum Fluid: Double {
        case water = 0.00000131
    }
}
