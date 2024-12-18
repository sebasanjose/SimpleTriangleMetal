//
//  FragmentShader.metal
//  SimpleTriangle
//
//  Created by Sebastian Juarez on 12/17/24.
//

#include <metal_stdlib>
using namespace metal;

// Input structure from the vertex shader.
struct VertexOut {
    float4 position [[position]]; // Position in clip space.
    float4 color;                 // Color passed from the vertex shader.
};

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color; // Output the color passed from the vertex shader.
}
