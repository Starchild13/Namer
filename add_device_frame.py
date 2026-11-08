from PIL import Image, ImageOps, ImageDraw

def frame_screenshot(input_path, output_path):
    # Open screenshot
    img = Image.open(input_path).convert("RGBA")
    width, height = img.size

    # Pixel device frame parameters
    border_width = 28
    corner_radius = 52
    bezel_color = (33, 33, 33, 255) # Google Pixel Obsidian / Dark Charcoal bezel

    # Create new image with bezel padding
    framed_width = width + (border_width * 2)
    framed_height = height + (border_width * 2)

    framed = Image.new("RGBA", (framed_width, framed_height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(framed)

    # Draw rounded rectangle for phone body
    draw.rounded_rectangle(
        [(0, 0), (framed_width - 1, framed_height - 1)],
        radius=corner_radius,
        fill=bezel_color
    )

    # Paste screenshot inside bezel
    framed.paste(img, (border_width, border_width))

    # Draw Google Pixel centered circular punch-hole camera
    camera_radius = 14
    camera_x = framed_width // 2
    camera_y = border_width + 16
    draw.ellipse(
        [(camera_x - camera_radius, camera_y - camera_radius),
         (camera_x + camera_radius, camera_y + camera_radius)],
        fill=(10, 10, 10, 255)
    )

    # Save output
    framed.save(output_path, "PNG")
    print(f"Saved Pixel-framed screenshot to {output_path}")

if __name__ == "__main__":
    frame_screenshot("assets/home_screen.png", "assets/home_screen_framed.png")
    frame_screenshot("assets/favorites_screen.png", "assets/favorites_screen_framed.png")
