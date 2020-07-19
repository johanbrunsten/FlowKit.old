//
//  PipeObject.swift
//  FlowKit
//
//  Created by Johan Brunsten on 2020-07-15.
//

import Foundation

extension FlowKit {
    public class PipeObject {
        internal var pipeData: PipeData
        internal var fluid: Materials.Fluid
        internal var hydraulicRadius: Double
        
        internal var maximumFlowRate: Double?
        internal var maximumFlowRateVelocity: Double?
        internal var currentFlowRate: Double?
        internal var currentVelocity: Double?
        internal var currentArea: Double?
        internal var frictionFactor: Double?
        
        public init(pipeData: FlowKit.PipeData, fluid: Materials.Fluid) {
            self.pipeData = pipeData
            self.fluid = fluid
            self.hydraulicRadius = pipeData.dimension / 4
        }
        
        public init(pipeData: FlowKit.PipeData, fluid: Materials.Fluid, currentFlowRate: Double?) {
            self.pipeData = pipeData
            self.fluid = fluid
            self.hydraulicRadius = pipeData.dimension / 4
            
            self.currentFlowRate = currentFlowRate
        }
    }
}
