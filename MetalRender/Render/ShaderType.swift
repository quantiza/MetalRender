//
//  ShaderType.swift
//  MetalRender
//
//  Created by Yang Long on 2025/4/14.
//

import Foundation
import simd

enum YLVertexInputIndex {
    case Vertices
    case ViewportSize
}

struct YLVertex {
    var position: vector_float2
    var color: vector_float4
}


