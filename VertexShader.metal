//
//  VertexShader.metal
//  SimpleTriangle
//
//  Created by Sebastian Juarez on 12/17/24.
//

#include <metal_stdlib>
using namespace metal;

// Define the structure for the input vertex attributes.
struct Vertex {
    float4 position [[attribute(0)]]; // Position of the vertex.
    float4 color [[attribute(1)]];    // Color of the vertex.
};

// Define the structure for the output to the fragment shader.
struct VertexOut {
    float4 position [[position]];    // Position in clip space.
    float4 color;                    // Color to pass to the fragment shader.
};

vertex VertexOut vertex_main(Vertex in [[stage_in]]) {
    VertexOut out;
    out.position = in.position; // Pass position to the clip space.
    out.color = in.color;       // Pass color to the fragment shader.
    return out;
}

