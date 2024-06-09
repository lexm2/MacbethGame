import os
import sys
from PIL import Image

def crop_transparent_edges(image_path, divisible_height, divisible_width):
    image = Image.open(image_path)
    width, height = image.size
    alpha_data = image.getdata(3)

    top = 0
    bottom = height - 1
    left = 0
    right = width - 1

    while top < height and all(alpha == 0 for alpha in alpha_data[top * width : (top + 1) * width]):
        top += 1

    while bottom >= 0 and all(alpha == 0 for alpha in alpha_data[bottom * width : (bottom + 1) * width]):
        bottom -= 1

    while left < width and all(alpha_data[i] == 0 for i in range(left, height * width, width)):
        left += 1

    while right >= 0 and all(alpha_data[i] == 0 for i in range(right, height * width, width)):
        right -= 1

    cropped_width = right - left + 1
    cropped_height = bottom - top + 1

    # Adjust dimensions to be divisible by the input values
    new_width = (cropped_width // divisible_width) * divisible_width
    new_height = (cropped_height // divisible_height) * divisible_height

    cropped_image = image.crop((left, top, left + new_width, top + new_height))
    return cropped_image

def process_directory(directory, divisible_height, divisible_width):
    for filename in os.listdir(directory):
        if filename.lower().endswith(".png"):
            image_path = os.path.join(directory, filename)
            cropped_image = crop_transparent_edges(image_path, divisible_height, divisible_width)
            cropped_image.save(image_path)
            print(f"Processed: {filename}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <directory> <divisible_height> <divisible_width>")
        sys.exit(1)

    directory = sys.argv[1]
    divisible_height = int(sys.argv[2])
    divisible_width = int(sys.argv[3])

    process_directory(directory, divisible_height, divisible_width)
