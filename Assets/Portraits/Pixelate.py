from PIL import Image
import os
import re

def pixelate_image(input_image_path, block_size=8):

    directory, filename = os.path.split(input_image_path)
    base, ext = os.path.splitext(filename)

    base = re.sub(r'[\d-]+$', '', base)
    
    output_directory = os.path.join(directory, 'Pixelated')
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    output_image_path = os.path.join(output_directory, base + '.pixelated.png')

    with Image.open(input_image_path) as img:

        if img.mode != 'RGB':
            img = img.convert('RGB')

        width, height = img.size

        out_width = width // block_size
        out_height = height // block_size
        
        pixelated = Image.new('RGB', (out_width, out_height))
        

        for x0 in range(0, width, block_size):
            for y0 in range(0, height, block_size):

                x1 = min(x0 + block_size, width)
                y1 = min(y0 + block_size, height)
                block = img.crop((x0, y0, x1, y1))
                
                r_total = g_total = b_total = 0
                count = 0
                for x in range(block.width):
                    for y in range(block.height):
                        r, g, b = block.getpixel((x, y))
                        r_total += r
                        g_total += g
                        b_total += b
                        count += 1
                average_color = (r_total // count, g_total // count, b_total // count)

                out_x = x0 // block_size
                out_y = y0 // block_size
                pixelated.putpixel((out_x, out_y), average_color)
        
        pixelated.save(output_image_path)

input_path = r'C:\Users\lexkm\MacbethGame\Assets\Portraits\Banquo00015-1166207222.png'
pixelate_image(input_path)
