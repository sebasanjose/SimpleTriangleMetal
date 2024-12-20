//
//  FragmentShader.metal
//  SimpleTriangle
//
//  Created by Sebastian Juarez on 12/17/24.
//

/**
 In this example, we’ll compute a simple Lambertian diffuse color in the fragment shader. We’ll assume a single directional light with a known direction. 
 */

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float3 normal;
};


fragment float4 fragment_main(
    VertexOut in [[stage_in]],
    constant float3 &lightDirection [[buffer(0)]]
) {
    float3 normalizedLight = normalize(float3(0.0, 0.0, 1.0)); // Light pointing towards the screen
    float3 normalizedNormal = normalize(in.normal);

    // Compute Lambertian reflection
    float lambertian = max(dot(normalizedNormal, normalizedLight), 0.0);
    
    float3 litColor = in.color.rgb * lambertian + float3(0.1); // Ambient intensity of 0.2
    return float4(litColor, in.color.a);

}







