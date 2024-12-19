//
//  main.swift
//  SimpleTriangle
//
//  Created by Sebastian Juarez on 12/17/24.
//

import MetalKit

// Metal initialization.
let device = MTLCreateSystemDefaultDevice()!
let commandQueue = device.makeCommandQueue()!

func orthographicMatrix(left: Float, right: Float, bottom: Float, top: Float) -> matrix_float4x4 {
    let rl = 1.0 / (right - left)
    let tb = 1.0 / (top - bottom)

    return matrix_float4x4(columns: (
        SIMD4<Float>( 2.0 * rl,         0.0, 0.0, 0.0),
        SIMD4<Float>(       0.0,  2.0 * tb, 0.0, 0.0),
        SIMD4<Float>(       0.0,       0.0, 1.0, 0.0),
        SIMD4<Float>(-(right + left) * rl, -(top + bottom) * tb, 0.0, 1.0)
    ))
}

var orthoMatrix = orthographicMatrix(left: -1.0, right: 1.0, bottom: -1.0, top: 1.0)

let uniformBuffer = device.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [] )!
memcpy(uniformBuffer.contents(), &orthoMatrix, MemoryLayout<matrix_float4x4>.size)

// Load shaders.
let library = device.makeDefaultLibrary()!
let vertexFunction = library.makeFunction(name: "vertex_main")!
let fragmentFunction = library.makeFunction(name: "fragment_main")!

// Create render pipeline descriptor.
let pipelineDescriptor = MTLRenderPipelineDescriptor()
pipelineDescriptor.vertexFunction = vertexFunction
pipelineDescriptor.fragmentFunction = fragmentFunction
pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

// Create a vertex descriptor to describe the layout of the vertex data.
let vertexDescriptor = MTLVertexDescriptor()

vertexDescriptor.attributes[0].format = .float4
vertexDescriptor.attributes[0].offset = 0
vertexDescriptor.attributes[0].bufferIndex = 0

vertexDescriptor.attributes[1].format = .float4
vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.size * 4
vertexDescriptor.attributes[1].bufferIndex = 0

vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.size * 8
vertexDescriptor.layouts[0].stepFunction = .perVertex

pipelineDescriptor.vertexDescriptor = vertexDescriptor

// Create pipeline state.
let pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)

// Create vertex data (position and color for each vertex).
let vertexData: [Float] = [
    // Position         // Color (RGBA)
    0.0,  0.5, 0.0, 1.0,  1.0, 0.0, 0.0, 1.0, // Top vertex
   -0.5, -0.5, 0.0, 1.0,  0.0, 1.0, 0.0, 1.0, // Bottom-left vertex
    0.5, -0.5, 0.0, 1.0,  0.0, 0.0, 1.0, 1.0  // Bottom-right vertex
]
let vertexBuffer = device.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: [])

// Create a drawable surface.
let metalView = MTKView()
metalView.device = device
metalView.colorPixelFormat = .bgra8Unorm

guard let vertexBuffer = device.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: []) else {
    fatalError("Failed to create vertex buffer.")
}

// Strong reference to the renderer
var renderer: Renderer?

// Assign the delegate to the metalView.
renderer = Renderer(device: device, commandQueue: commandQueue, pipelineState: pipelineState, vertexBuffer: vertexBuffer, uniformBuffer:uniformBuffer)
metalView.delegate = renderer

// Renderer class to handle drawing.
class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    let uniformBuffer: MTLBuffer
    
    init(device: MTLDevice, commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, vertexBuffer: MTLBuffer, uniformBuffer: MTLBuffer) {
        self.device = device
        self.commandQueue = commandQueue
        self.pipelineState = pipelineState
        self.vertexBuffer = vertexBuffer
        self.uniformBuffer = uniformBuffer
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

// Set up the Metal view and run the application.
let app = NSApplication.shared
let window = NSWindow(contentRect: NSMakeRect(0, 0, 800, 600), styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
window.contentView = metalView
window.makeKeyAndOrderFront(nil)
app.run()
