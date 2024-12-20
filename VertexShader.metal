//
//  VertexShader.metal
//  SimpleTriangle
//
//  Created by Sebastian Juarez on 12/17/24.
//

/**
 The vertex shader passes along the normal vector, and the fragment shader does the dot product with the light direction.
 */

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float3 normal [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float3 normal;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = in.position;
    out.color = in.color;
    out.normal = in.normal; // Pass the normal to the fragment shader.
    return out;
}


