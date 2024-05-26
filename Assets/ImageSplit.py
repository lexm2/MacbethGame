from PIL import Image
import os

def split_image(image_path, output_folder, grid_size=(8, 8)):
    # Open the image
    image = Image.open(image_path)
    image_width, image_height = image.size

    # Calculate the size of each grid cell
    grid_width = image_width // grid_size[0]
    grid_height = image_height // grid_size[1]

    # Ensure the output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Iterate over the grid and save each part as a separate image
    for row in range(grid_size[1]):
        for col in range(grid_size[0]):
            left = col * grid_width
            top = row * grid_height
            right = (col + 1) * grid_width
            bottom = (row + 1) * grid_height

            # Crop the image to the current grid cell
            cropped_image = image.crop((left, top, right, bottom))

            # Save the cropped image
            cropped_image_path = os.path.join(output_folder, f'img_{row}_{col}.png')
            cropped_image.save(cropped_image_path)

            print(f'Saved {cropped_image_path}')

# Example usage
split_image(r"tileset.png", 'separated images',(10, 10))
