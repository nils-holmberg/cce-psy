#!/bin/bash

if false; then
convert -size 100x100 canvas:cyan im1.png
convert -size 100x100 canvas:magenta im2.png
convert -size 100x100 canvas:yellow im3.png
convert -size 100x100 canvas:black im4.png
convert -size 100x100 canvas:white im5.png
convert -size 100x100 canvas:gray blank.png
convert -size 100x100 canvas:red name.png
convert -size 200x500 canvas:green ad1.png
convert -size 200x500 canvas:blue ad2.png
convert -size 980x720 canvas:lightgray sc1.png
convert -size 300x720 canvas:lightgray sc2.png
fi

# Array of your image files (excluding 'name.png' and 'blank.png')
images=("im1.png" "im2.png" "im3.png" "im4.png" "im5.png")

# Create an array to hold 25 images, initially filled with 'blank.png'
grid_images=($(for i in {1..25}; do echo "blank.png"; done))

# Replace 5 random positions (excluding the center) with unique images
for i in {1..5}; do
    # Generate a random position that's not the center (13th position)
    while : ; do
        pos=$(( $RANDOM % 25 ))
        if [ $pos -ne 12 ]; then
            # Check if the position already has a unique image
            if [[ ${grid_images[$pos]} == "blank.png" ]]; then
                # Select a random image and remove it from 'images' array
                random_index=$(($RANDOM % ${#images[@]}))
                grid_images[$pos]=${images[$random_index]}
                unset 'images[random_index]'
                images=("${images[@]}")
                break
            fi
        fi
    done
done

# Place 'name.png' in the center
grid_images[12]="name.png"

# Use ImageMagick to create a 5x5 grid
montage "${grid_images[@]}" -tile 5x5 -geometry 100x100+0+0 output.png

# Display path of the generated image
echo "Grid image created: output.png"

#
composite -geometry +370+110 output.png sc1.png main.png

#### some

# Path to your output image and ad1.png
output_image="output.png"  # Replace with your 500x500 output image path
output_image="main.png"  # Replace with your 500x500 output image path

ad1_image="ad1.png"        # Replace with your 200x500 ad1 image path
ad1_image="sc2.png"        # Replace with your 200x500 ad1 image path

# Loop to create 100 images
for i in {1..100}; do
    # Format the file number with leading zeroes
    file_number=$(printf "%03d" $i)

    # Combine the images horizontally and save them
    convert +append "$output_image" "$ad1_image" "image$file_number.png"
done

echo "100 images created."

#### task onset

# Path to your output image and ad2.png
#output_image="output.png"  # Replace with your 500x500 output image path

composite -gravity center some.png sc2.png task.png
ad2_image="ad2.png"        # Replace with your 200x500 ad2 image path
ad2_image="task.png"        # Replace with your 200x500 ad2 image path

# Generate a random starting point between 1 and 50
start=$((RANDOM % 50 + 1)); echo $start >> trials.txt

# Loop to create 50 images starting from the random point
for ((i=start; i<start+50; i++)); do
    # Format the file number with leading zeroes
    file_number=$(printf "%03d" $((i % 100 + 1)))

    # Combine the images horizontally and save them
    convert +append "$output_image" "$ad2_image" "image$file_number.png"
done

echo "50 images created starting from image$file_number."

ffmpeg -framerate 10 -i image%03d.png -c:v libx264 -pix_fmt yuv420p output_video.mp4
####
