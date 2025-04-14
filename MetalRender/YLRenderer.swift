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
    
    init(mtkView: MTKView) {
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
    }
}

extension YLRenderer: MTKViewDelegate {

    // 在此方法中，您创建一个命令缓冲区，编码告诉 GPU 绘制什么内容以及何时在屏幕上显示它的命令，并将该命令缓冲区排队以供 GPU 执行。这有时被称为绘制一帧。您可以将帧视为生成显示在屏幕上的单个图像所需完成的所有工作。在交互式应用程序（如游戏）中，您每秒可能会绘制多帧。
    func draw(in view: MTKView) {
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
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
    
    // 当内容大小发生变化时, 这发生在包含视图的窗口被调整大小时，或在设备方向改变时（在 iOS 上）
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
