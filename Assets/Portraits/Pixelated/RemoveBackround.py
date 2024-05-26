import os
from PIL import Image

def flood_fill(data, width, height, start_pos, target_color, replacement_color):
    """ Perform a flood fill algorithm to change target_color to replacement_color. """
    x, y = start_pos
    if data[y * width + x] != target_color:
        return
    edge = [(x, y)]
    while edge:
        new_edge = []
        for (x, y) in edge:
            for (nx, ny) in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]:
                if 0 <= nx < width and 0 <= ny < height and data[ny * width + nx] == target_color:
                    data[ny * width + nx] = replacement_color
                    new_edge.append((nx, ny))
        edge = new_edge

def remove_background(image_path, output_path):
    # Open the image
    with Image.open(image_path) as img:
        # Ensure the image has an alpha channel
        img = img.convert("RGBA")
        
        # Get pixel data
        data = list(img.getdata())
        
        # Determine the background color by checking the corners
        width, height = img.size
        corners = [data[0], data[width - 1], data[-1], data[-width]]
        background_color = max(corners, key=corners.count)  # Most common color among corners
        transparent_color = (255, 255, 255, 0)  # Fully transparent
        
        # Apply flood fill from each corner
        for corner in [(0, 0), (width - 1, 0), (0, height - 1), (width - 1, height - 1)]:
            flood_fill(data, width, height, corner, background_color, transparent_color)
        
        # Update image data
        img.putdata(data)
        
        # Save the new image
        img.save(output_path)

def process_all_png_files(directory):
    # Get all PNG files in the current directory
    for file in os.listdir(r'.'):
        print(file)
        if file.lower().endswith('.png'):
            full_path = os.path.join(directory, file)
            output_file = os.path.splitext(full_path)[0] + '_nobg.png'
            remove_background(full_path, output_file)
            print(f"Processed {file} and saved to {output_file}")

current_directory = os.getcwd()
process_all_png_files(current_directory)
