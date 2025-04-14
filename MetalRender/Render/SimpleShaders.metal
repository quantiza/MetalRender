//
//  SimpleShaders.metal
//  MetalRender
//
//  Created by Yang Long on 2025/4/14.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn2D {
    vector_float2 position;
    vector_float4 color;
};

struct RasterizerData {
    vector_float4 position [[position]];
    vector_float4 color;
};


vertex RasterizerData
vertexShader(uint vertexID [[vertex_id]],
            constant VertexIn2D *vertices [[buffer(0)]],
            constant vector_float2 * viewportSizePointer [[buffer(1)]]) {
            
    RasterizerData out;

    // Index into the array of positions to get the current vertex.
    // The positions are specified in pixel dimensions (i.e. a value of 100
    // is 100 pixels from the origin).
    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    // Get the viewport size and cast to float.
    vector_float2 viewportSize = *viewportSizePointer;
    

    // To convert from positions in pixel space to positions in clip-space,
    //  divide the pixel coordinates by half the size of the viewport.
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    // Pass the input color directly to the rasterizer.
    out.color = vertices[vertexID].color;

    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    // Return the interpolated color.
    return in.color;
}
