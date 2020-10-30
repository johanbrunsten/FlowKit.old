# FlowKit
FlowKit is a framework, written in Swift, for calculate the hydraulics in a pipe. The framework is designed for urban drainage but should be functinally for other simularly applications.
## Features
Calculate the flow and/or depth, velocity, friction loss and friction factor, both for maximum pipe flow and part-full pipe flow.
## How to use
1.  Create an pipeData object that contains the basic information about the pipe, as material, dimension, lenght, gradient/levels and shape.
    * let pipeData = FlowKit.PipeData(material: .concrete, dimension: 0.225, length: 10, gradient: 0.01, pipeShape: .circular)

2. Create an pipeObject that contains your pipeData object and the fluid in the pipe. Optional is also current flow rate or current depth in pipe, depending if one or the other is available.
    * let pipeObject = FlowKit.PipeObject(pipeData: pipeData, fluid: .water, currentFlow: 0.06)
3. To get the desired values, you just call the pipeObject with the corresponding method. For example:
    * let currentVelocity = pipeObject.currentVelocity
    * let currentFlowRate = pipeObject.currentFlowRate
    * let depth = pipeObject.depth
    * let frictionFactor = pipeObject.frictionFactor
## How to add the framework to your Xcode project
### Swift Package Manager
1. In Xcode select File -> Swift Packages -> Add Package Dependency...
2. Copy-paste repository URL: https://github.com/johanbrunsten/FlowKit
3. Hit Next two times and then Finish
## Example
<img src="Demo/FlowKit.gif" width="250" height="541" />
