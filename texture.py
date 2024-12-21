from PIL import Image
import random
import math

def generate_wood_texture(width, height, base_color, dark_grain_color, noise_scale, noise_intensity, filename="texture.png"):
    """Generates a wood texture and saves it as a PNG."""
    img = Image.new('RGB', (width, height), base_color)
    pixels = img.load()

    def noise(x,y):
      return (math.sin(x * noise_scale) + math.cos(y * noise_scale)) * 0.5 + 0.5

    for y in range(height):
      for x in range(width):
          n = noise(x, y)
          
          # Interpolate between base color and dark grain color
          r = int(base_color[0] + (dark_grain_color[0] - base_color[0]) * n * noise_intensity)
          g = int(base_color[1] + (dark_grain_color[1] - base_color[1]) * n * noise_intensity)
          b = int(base_color[2] + (dark_grain_color[2] - base_color[2]) * n * noise_intensity)
          pixels[x, y] = (min(255, max(0, r)), min(255, max(0, g)), min(255, max(0, b)))

    img.save(filename)
    print(f"Wood texture saved to {filename}")

if __name__ == "__main__":
    generate_wood_texture(512, 512, (200, 150, 100), (100, 50, 0), 0.03, 1) # Example colors and dimensions