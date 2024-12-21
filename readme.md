# SimpleTriangleMetal

SimpleTriangleMetal is a basic example demonstrating how to render a simple triangle using Apple's Metal framework. This project serves as an introduction to Metal's graphics rendering capabilities for developers new to the framework.

## Features

- **Basic Rendering**: Renders a single triangle on the screen using Metal.
- **Shader Implementation**: Includes vertex and fragment shaders written in Metal Shading Language.
- **Xcode Integration**: Configured with an Xcode project for easy setup and building.

## Project Structure

**SimpleTriangle.xcodeproj:** Xcode project file.

**SimpleTriangle:** Directory containing the main application source files.

**Shaders:**

**VertexShader.metal:** Defines the vertex shader.

**FragmentShader.metal:** Defines the fragment shader.

## Special Branches
As I kept adding things to this project, I decided to branch out every single new feature, in that way it's easier to compare among branches to see how I performed that specific challenge.

**[Branch ortographicProjection](https://github.com/sebasanjose/SimpleTriangleMetal/tree/orthographicProjection)** shows the usage of 2D-clipping for a camera POV

**[Branch lighting](https://github.com/sebasanjose/SimpleTriangleMetal/tree/lighting)** shows the usage of light reflection, using it's normals, and ambient light

**[Branch texture](https://github.com/sebasanjose/SimpleTriangleMetal/tree/texture)** shows the usage of fragment shader to load a sample texture 
