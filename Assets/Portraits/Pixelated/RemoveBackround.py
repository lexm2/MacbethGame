import os
import sys
from PIL import Image

class BackgroundRemover:
    def __init__(self, directory, output_directory, tolerance=10):
        self._directory = directory
        self._output_directory = output_directory
        self._tolerance = tolerance
        if not os.path.exists(self._output_directory):
            os.makedirs(self._output_directory)

    def _is_color_similar(self, color1, color2):
        """Check if two colors are similar within a given tolerance."""
        return all(abs(c1 - c2) <= self._tolerance for c1, c2 in zip(color1, color2))

    def _flood_fill(self, data, width, height, start_pos, target_color, replacement_color):
        """Perform a flood fill algorithm to change target_color to replacement_color with tolerance."""
        x, y = start_pos
        original_color = data[y * width + x]
        if not self._is_color_similar(original_color, target_color):
            return
        edge = [(x, y)]
        while edge:
            new_edge = []
            for (x, y) in edge:
                for (nx, ny) in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]:
                    if 0 <= nx < width and 0 <= ny < height:
                        current_color = data[ny * width + nx]
                        if current_color == replacement_color:
                            continue
                        if self._is_color_similar(current_color, target_color):
                            data[ny * width + nx] = replacement_color
                            new_edge.append((nx, ny))
            edge = new_edge

    def remove_background(self, image_path, output_path):
        """Remove the background of an image where the colors are within a tolerance."""
        with Image.open(image_path) as img:
            img = img.convert("RGBA")
            data = list(img.getdata())
            width, height = img.size
            corners = [data[0], data[width - 1], data[-1], data[-width]]
            background_color = max(corners, key=corners.count)
            transparent_color = (255, 255, 255, 0)
            
            for corner in [(0, 0), (width - 1, 0), (0, height - 1), (width - 1, height - 1)]:
                self._flood_fill(data, width, height, corner, background_color, transparent_color)
            
            img.putdata(data)
            img.save(output_path)
            print(f"Background removed and saved to {output_path}")

    def process_directory(self):
        """Process all image files in the directory."""
        for filename in os.listdir(self._directory):
            if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
                image_path = os.path.join(self._directory, filename)
                output_path = os.path.join(self._output_directory, os.path.splitext(filename)[0] + '_nobg.png')
                self.remove_background(image_path, output_path)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python RemoveBackground.py <input_directory> <output_directory> [tolerance]")
    else:
        input_directory = sys.argv[1]
        output_directory = sys.argv[2]
        tolerance = int(sys.argv[3]) if len(sys.argv) > 3 else 10  # Default tolerance is 10 if not specified
        remover = BackgroundRemover(input_directory, output_directory, tolerance)
        remover.process_directory()
