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
        
        internal var currentFlowRate: Double?
        
        public init(pipeData: FlowKit.PipeData, fluid: Materials.Fluid) {
            self.pipeData = pipeData
            self.fluid = fluid
        }
        
        public init(pipeData: FlowKit.PipeData, fluid: Materials.Fluid, currentFlowRate: Double?) {
            self.pipeData = pipeData
            self.fluid = fluid
            self.currentFlowRate = currentFlowRate
        }
    }
}
