//
//  ViewController.swift
//  MetalRender
//
//  Created by Yang Long on 2025/4/14.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    var mtkView: MTKView!
    var render: YLRenderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mtkView = MTKView(frame:self.view.bounds)
        self.view.addSubview(mtkView)
        
        // 仅在需要更新内容时（例如当视图形状改变时）才进行绘制
        mtkView.enableSetNeedsDisplay = true
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        
        mtkView.clearColor = MTLClearColorMake(1.0, 0.5, 1.0, 1.0)
        
        render = YLRenderer(mtkView: mtkView)
        
        render.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        
        mtkView.delegate = render
    }
}

