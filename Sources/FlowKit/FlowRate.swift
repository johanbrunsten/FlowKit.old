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
        /// - Parameter pipeData: A PipeData object
        /// - Returns: Returns a double with the flow-rate in m3/s
        public class func maximumFlowRate(pipeData: FlowKit.PipeData) -> Double {
            let velocity = ColebrookWhite.velocity(pipeData: pipeData)
            let pipeArea = pow(pipeData.dimension, 2) * Double.pi / 4

            let flowRate = velocity * pipeArea
            return flowRate
        }
    }
}
