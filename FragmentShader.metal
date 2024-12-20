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

//

//fragment float4 fragment_main(
//    VertexOut in [[stage_in]],
//    constant float3 &lightDirection [[buffer(0)]]
//) {
//    // Output the normal directly as a color
//    float3 normalizedNormal = normalize(in.normal);
//    return float4(normalizedNormal * 0.5 + 0.5, 1.0); // Map normal to [0, 1]
//}

//fragment float4 fragment_main(
//    VertexOut in [[stage_in]],
//    constant float3 &lightDirection [[buffer(0)]]
//) {
//    float3 normalizedLight = normalize(lightDirection);
//    float3 normalizedNormal = normalize(in.normal);
//
//    // Compute the dot product
//    float dotProduct = dot(normalizedNormal, normalizedLight);
//
//    // Output the dot product as grayscale
//    return float4(dotProduct * 0.5 + 0.5, dotProduct * 0.5 + 0.5, dotProduct * 0.5 + 0.5, 1.0);
//}

fragment float4 fragment_main(
    VertexOut in [[stage_in]],
    constant float3 &lightDirection [[buffer(0)]]
) {
    float3 normalizedLight = normalize(float3(0.0, 0.0, 1.0)); // Light pointing towards the screen
    float3 normalizedNormal = normalize(in.normal);

    // Compute Lambertian reflection
    float lambertian = dot(normalizedNormal, normalizedLight);
    
    float3 litColor = in.color.rgb * lambertian + float3(0.2); // Ambient intensity of 0.2
    return float4(litColor, in.color.a);


    // Output Lambertian coefficient as grayscale
//    return float4(lambertian, lambertian, lambertian, 1.0);
}


//fragment float4 fragment_main(
//    VertexOut in [[stage_in]],
//    constant float3 &lightDirection [[buffer(0)]]
//) {
//    // Normalize the surface normal
//    float3 normalizedNormal = normalize(in.normal);
//
//    // Visualize the normals as RGB colors
//    return float4(normalizedNormal * 0.5 + 0.5, 1.0); // Map [-1, 1] to [0, 1]
//}




