//
//  DegreesToRadians.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-09.
//

import Foundation

internal class DegreesToRadians {
    /// A method that converts from degrees to radians
    /// - Parameter degrees: A value between 0 and 360 degrees
    /// - Returns: Returns the degrees converted to radians
    internal class func radians(from degrees: Double) -> Double {
        let radians = degrees * (Double.pi / 180)
        
        return radians
    }
}
