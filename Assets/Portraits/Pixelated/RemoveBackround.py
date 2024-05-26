import os
from PIL import Image

def is_color_similar(color1, color2, tolerance):
    """Check if two colors are similar within a given tolerance."""
    return all(abs(c1 - c2) <= tolerance for c1, c2 in zip(color1, color2))

def flood_fill(data, width, height, start_pos, target_color, replacement_color, tolerance):
    """Perform a flood fill algorithm to change target_color to replacement_color with tolerance."""
    x, y = start_pos
    original_color = data[y * width + x]
    if not is_color_similar(original_color, target_color, tolerance):
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
                    if is_color_similar(current_color, target_color, tolerance):
                        data[ny * width + nx] = replacement_color
                        new_edge.append((nx, ny))
        edge = new_edge

def remove_background(image_path, output_path, tolerance=10):
    """Remove the background of an image where the colors are within a tolerance."""
    with Image.open(image_path) as img:
        img = img.convert("RGBA")
        data = list(img.getdata())
        width, height = img.size
        corners = [data[0], data[width - 1], data[-1], data[-width]]
        background_color = max(corners, key=corners.count)
        transparent_color = (255, 255, 255, 0)
        
        for corner in [(0, 0), (width - 1, 0), (0, height - 1), (width - 1, height - 1)]:
            flood_fill(data, width, height, corner, background_color, transparent_color, tolerance)
        
        img.putdata(data)
        img.save(output_path)

def process_all_png_files(directory):
    print("Script is starting...")
    print(f"Looking for PNG files in the directory and subdirectories: {directory}")
    found_png = False
    for dirpath, dirnames, filenames in os.walk(directory):
        for file in filenames:
            if file.lower().endswith('.png') and '_nobg' not in file.lower():
                found_png = True
                full_path = os.path.join(dirpath, file)
                output_file = os.path.splitext(full_path)[0] + '_nobg.png'
                print(f"Processing {full_path}...")
                remove_background(full_path, output_file, 5)
                print(f"Processed {file} and saved to {output_file}")
    if not found_png:
        print("No PNG files found in the directory or its subdirectories.")

# Example usage
current_directory = os.getcwd()  # Or specify any directory you want to process
process_all_png_files(current_directory)
