# Coordinate Spaces and Transforms

## Overview

This project explores the concept of coordinate spaces and transformations in computer graphics, focusing on orthographic projections.

## Key Features

- **Vertex Shader Enhancement**:
  - Modified to apply a simple orthographic projection.
- **Uniform Buffer Setup**:
  - A uniform buffer is configured on the CPU side to hold an orthographic projection matrix.
  - This matrix is passed to the vertex shader for processing.
- **Rendering in World Space**:
  - Renders a triangle where vertex positions are defined in a "world space."
  - An orthographic projection is applied to shift the coordinates into Normalized Device Coordinates (NDC) range.

## References

- [OpenGL Orthographic Projection](https://www.khronos.org/opengl/wiki/Orthographic_Projection)
- [Coordinate Spaces in Graphics](https://learnopengl.com/Getting-started/Coordinate-Systems)

