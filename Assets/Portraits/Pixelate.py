from PIL import Image
import os
import re
import sys

class ImagePixelator:
    def __init__(self, input_image_path, block_size = 8):
        self._input_image_path = input_image_path
        self._block_size = block_size
        self._directory, self._filename = os.path.split(input_image_path)
        self._base, self._ext = os.path.splitext(self._filename)
        self._base = re.sub(r'[\d-]+', '', self._base)
        self._output_directory = os.path.join(self._directory, 'Pixelated')
        self._output_image_path = os.path.join(self._output_directory, self._base + '.pixelated.png')

    def _get_valid_block_sizes(self, width, height):
        """Return a list of block sizes that are divisors of both width and height."""
        max_possible_size = min(width, height)
        return [i for i in range(1, max_possible_size + 1) if width % i == 0 and height % i == 0]

    def pixelate(self):
        """Pixelate the image with the specified block size."""
        if not os.path.exists(self._output_directory):
            os.makedirs(self._output_directory)

        with Image.open(self._input_image_path) as img:
            if img.mode != 'RGB':
                img = img.convert('RGB')

            width, height = img.size
            valid_sizes = self._get_valid_block_sizes(width, height)

            if self._block_size not in valid_sizes:
                print(f"Error: Block size {self._block_size} is not a valid divisor of image dimensions ({width}x{height}).")
                print("Valid block sizes are:", valid_sizes)
                return

            out_width = (width // self._block_size) * self._block_size
            out_height = (height // self._block_size) * self._block_size
            
            pixelated = img.resize((out_width // self._block_size, out_height // self._block_size), resample=Image.NEAREST)
            pixelated = pixelated.resize((out_width, out_height), resample=Image.NEAREST)

            pixelated.save(self._output_image_path)
            print(f"Pixelated image saved to {self._output_image_path}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_path = sys.argv[1]
        if len(sys.argv) > 2:
            try:
                block_size = int(sys.argv[2])
                pixelator = ImagePixelator(input_path, block_size)
                pixelator.pixelate()
            except ValueError:
                print("Please provide a valid integer for block size.")
        else:
            pixelator = ImagePixelator(input_path)
            pixelator.pixelate()
    else:
        print("Usage: python Pixelate.py <image_path> <block_size>")
