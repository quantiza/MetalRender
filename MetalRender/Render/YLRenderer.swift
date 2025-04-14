//
//  YLRenderer.swift
//  MetalRender
//
//  Created by Yang Long on 2025/4/14.
//

import UIKit
import MetalKit

class YLRenderer: NSObject {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    private let pipelineState: MTLRenderPipelineState
    
    private var viewportSize: vector_float2
    
    
    init(mtkView: MTKView) {
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        self.viewportSize = vector_float2()
        
        // Load all the shader files with a .metal file extension in the project.
        let defaultLib = self.device.makeDefaultLibrary()
        let vertexFunc = defaultLib?.makeFunction(name: "vertexShader")
        let fragmentFunc = defaultLib?.makeFunction(name: "fragmentShader")

        // Configure a pipeline descriptor that is used to create a pipeline state.
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunc;
        pipelineStateDescriptor.fragmentFunction = fragmentFunc;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
    }
}

extension YLRenderer: MTKViewDelegate {

    // 在此方法中，您创建一个命令缓冲区，编码告诉 GPU 绘制什么内容以及何时在屏幕上显示它的命令，并将该命令缓冲区排队以供 GPU 执行。这有时被称为绘制一帧。您可以将帧视为生成显示在屏幕上的单个图像所需完成的所有工作。在交互式应用程序（如游戏）中，您每秒可能会绘制多帧。
    func draw(in view: MTKView) {
        
        let triangleVertices = [
            YLVertex(position: [ 250,  -250], color: [1, 0, 0, 1]),
            YLVertex(position: [-250,  -250], color: [0, 1, 0, 1]),
            YLVertex(position: [   0,   250], color: [0, 0, 1, 1]),
        ]
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            print("Create a Render Pass Descriptor Error!")
            return
        }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("Create Command Buffer Error!")
            return
        }
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            print("Create a Render Pass Error!")
            return
        }
        
        guard let drawable = view.currentDrawable else {
            print("Create Drawable Error!")
            return
        }
        
        commandBuffer.label = "MyCommand"
        commandEncoder.label = "MyCommandEncoder"
        
        // commandEncoder setting
        commandEncoder.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(viewportSize.x), height: Double(viewportSize.y), znear: 0, zfar: 1))
        commandEncoder.setRenderPipelineState(pipelineState)
        
        
        let vertextPointer = triangleVertices.withUnsafeBufferPointer {
            $0.baseAddress!
        }
        
        let byteCount = MemoryLayout<YLVertex>.stride * triangleVertices.count
        
        commandEncoder.setVertexBytes(vertextPointer, length: byteCount, index: 0)
        commandEncoder.setVertexBytes(&viewportSize, length: MemoryLayout<CGSize>.stride, index: 1)
        
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
    
    // 当内容大小发生变化时, 这发生在包含视图的窗口被调整大小时，或在设备方向改变时（在 iOS 上）
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize.x = Float(size.width)
        viewportSize.y = Float(size.height)
    }
}
