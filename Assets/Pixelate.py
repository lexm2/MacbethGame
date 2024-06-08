from PIL import Image
import os
import re
import sys

class ImagePixelator:
    def __init__(self, input_dir, block_size=8, average_alpha=False):
        self._input_dir = input_dir
        self._block_size = block_size
        self._average_alpha = average_alpha
        self._output_directory = os.path.join(input_dir, 'Pixelated')
        if not os.path.exists(self._output_directory):
            os.makedirs(self._output_directory)

    def _get_image_files(self):
        """Return a list of image file paths in the input directory."""
        supported_formats = ['.jpg', '.jpeg', '.png', '.bmp', '.gif']
        return [os.path.join(self._input_dir, f) for f in os.listdir(self._input_dir)
                if os.path.splitext(f)[1].lower() in supported_formats]

    def _get_valid_block_sizes(self, width, height):
        """Return a list of block sizes that are divisors of both width and height."""
        max_possible_size = min(width, height)
        return [i for i in range(1, max_possible_size + 1) if width % i == 0 and height % i == 0]
    def pixelate_image(self, image_path):
        """Pixelate a single image."""
        base, ext = os.path.splitext(os.path.basename(image_path))
        base = re.sub(r'[\d-]+', '', base)
        output_image_path = os.path.join(self._output_directory, base + '.pixelated.png')

        with Image.open(image_path) as img:
            if self._average_alpha and img.mode in ['RGBA', 'LA']:
                img = img.convert('RGBA')
            else:
                img = img.convert('RGB')

            width, height = img.size
            valid_sizes = self._get_valid_block_sizes(width, height)

            if self._block_size not in valid_sizes:
                print(f"Error: Block size {self._block_size} is not a valid divisor of image dimensions ({width}x{height}).")
                print("Valid block sizes are:", valid_sizes)
                return

            out_width = width // self._block_size
            out_height = height // self._block_size
            
            # Resize down to get the blocky effect using NEAREST resampling
            pixelated = img.resize((out_width, out_height), resample=Image.NEAREST)
            
            # If averaging alpha, calculate the average alpha for each block using NEAREST resampling
            if self._average_alpha and img.mode == 'RGBA':
                alpha = img.split()[3]  # Get the alpha channel
                small_alpha = alpha.resize((out_width, out_height), resample=Image.NEAREST)
                pixelated.putalpha(small_alpha)

            pixelated.save(output_image_path)
            print(f"Pixelated image saved to {output_image_path}")

    def pixelate(self):
        """Pixelate all images in the directory."""
        image_files = self._get_image_files()
        for image_path in image_files:
            self.pixelate_image(image_path)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_dir = sys.argv[1]
        block_size = int(sys.argv[2]) if len(sys.argv) > 2 else 8
        average_alpha = sys.argv[3].lower() == 'true' if len(sys.argv) > 3 else False
        pixelator = ImagePixelator(input_dir, block_size, average_alpha)
        pixelator.pixelate()
    else:
        print("Usage: python Pixelate.py <directory_path> <block_size> <average_alpha>")