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
    float2 texCoords;
};


fragment float4 fragment_main(
    VertexOut in [[stage_in]],
    constant float3 &lightDirection [[buffer(0)]],
    texture2d<float> texture [[texture(0)]]
) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    float4 textureColor = texture.sample(textureSampler, in.texCoords);
    
    float3 normalizedLight = normalize(float3(0.0, 0.0, 1.0));
    float3 normalizedNormal = normalize(in.normal);
    float lambertian = max(dot(normalizedNormal, normalizedLight), 0.0);
    
    // Combine texture color with lighting
    float3 litColor = textureColor.rgb * lambertian + float3(0.1);
    return float4(litColor, textureColor.a);
}







