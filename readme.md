# SimpleTriangle Project

## Overview
This project demonstrates a basic implementation of a 3D triangle rendered using **Metal**, Apple's GPU programming framework. It includes features like Lambertian lighting and ambient light to provide realistic shading effects on the triangle.

## Features
- Renders a simple 3D triangle.
- Implements Lambertian reflection for diffuse lighting.
- Adds ambient lighting for consistent visibility in unlit areas.
- Allows customization of vertex normals and light direction.

## File Structure
- **`main.swift`**: Initializes the Metal pipeline, configures vertex data, and handles rendering.
- **`VertexShader.metal`**: Processes vertex positions and passes attributes (e.g., normals, colors) to the fragment shader.
- **`FragmentShader.metal`**: Calculates lighting effects and produces the final pixel colors.

## Key Concepts
### Lambertian Reflection
Lambertian shading calculates the diffuse light intensity using the dot product of the surface normal and the light direction:
```metal
float lambertian = max(dot(normalizedNormal, normalizedLight), 0.0);

