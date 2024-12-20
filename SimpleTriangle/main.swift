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

vertexDescriptor.attributes[2].format = .float3
vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.size * 8
vertexDescriptor.attributes[2].bufferIndex = 0

vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.size * 11
vertexDescriptor.layouts[0].stepFunction = .perVertex

pipelineDescriptor.vertexDescriptor = vertexDescriptor

// Create pipeline state.
let pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)

// Create vertex data (position, color and normal for each vertex).

let vertexData: [Float] = [
    // Position         // Color (RGBA)      // Normal
     0.0,  1.0, 0.0, 1.0,  1.0, 0.0, 0.0, 1.0,  0.0,  0.5,  1.0, // Top vertex (angled slightly)
    -1.0, -1.0, 0.0, 1.0,  0.0, 1.0, 0.0, 1.0,  -0.5, -0.5, 1.0, // Bottom-left vertex
     1.0, -1.0, 0.0, 1.0,  0.0, 0.0, 1.0, 1.0,   0.5, -0.5, 1.0  // Bottom-right vertex
]


// Define the light direction.
let lightDirection: [Float] = [0.7, 0.7, -1.0, 0.0] // Light coming at an angle

let lightDirectionBuffer = device.makeBuffer(bytes: lightDirection, length: MemoryLayout<Float>.size * 4, options: [])!


// Create a drawable surface.
let metalView = MTKView()
metalView.device = device
metalView.colorPixelFormat = .bgra8Unorm
metalView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // Black background



guard let vertexBuffer = device.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: []) else {
    fatalError("Failed to create vertex buffer.")
}

// Strong reference to the renderer
var renderer: Renderer?

// Assign the delegate to the metalView.
renderer = Renderer(device: device, commandQueue: commandQueue, pipelineState: pipelineState, vertexBuffer: vertexBuffer)
metalView.delegate = renderer

// Renderer class to handle drawing.
class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    
    init(device: MTLDevice, commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, vertexBuffer: MTLBuffer) {
        self.device = device
        self.commandQueue = commandQueue
        self.pipelineState = pipelineState
        self.vertexBuffer = vertexBuffer
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // Bind the light direction buffer to index 0.
        renderEncoder.setFragmentBuffer(lightDirectionBuffer, offset: 0, index: 0)
        
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
