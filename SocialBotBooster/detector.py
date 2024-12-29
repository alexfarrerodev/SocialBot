import pyautogui
import numpy as np
import cv2
import mss
import time
import keyboard
import sys

# Image paths to search for
images_to_find = ['photo1.PNG', 'photo2.PNG']  # Change this to the paths of your images
target_images = [cv2.imread(image) for image in images_to_find]

# Verify that the images were loaded correctly
for i, image in enumerate(target_images):
    if image is None:
        print(f"Could not load the image from {images_to_find[i]}. Make sure the path is correct.")
        sys.exit(1)

# Get the dimensions of the target images
dimensions = [(img.shape[0], img.shape[1]) for img in target_images]

# Function to capture the screen and search for the images
def search_and_click():
    scrolling = False  # Scroll state
    with mss.mss() as sct:
        while True:
            # Capture the screen
            screenshot = sct.grab(sct.monitors[1])
            img_screenshot = np.array(screenshot)

            # Convert the image to BGR format
            img_screenshot = cv2.cvtColor(img_screenshot, cv2.COLOR_BGRA2BGR)

            # Search for the images in the capture
            for i, target_image in enumerate(target_images):
                result = cv2.matchTemplate(img_screenshot, target_image, cv2.TM_CCOEFF_NORMED)

                # Set a threshold for detection
                threshold = 0.8
                locations = np.where(result >= threshold)

                # If the image is found, click on it
                for pt in zip(*locations[::-1]):  # Convert to (x, y) coordinates
                    center_x = pt[0] + dimensions[i][1] // 2
                    center_y = pt[1] + dimensions[i][0] // 2
                    pyautogui.click(center_x, center_y)
                    print(f"Clicked on the position of {images_to_find[i]}: ({center_x}, {center_y})")
                    break  # Click only on the first match

            # Scroll the page if the '+' key is pressed
            if keyboard.is_pressed('+'):
                scrolling = True
            elif keyboard.is_pressed('-'):
                scrolling = False

            if scrolling:
                pyautogui.scroll(-120)  # Scroll down
                time.sleep(0.1)  # Wait a moment for slow scrolling

            # Exit if Ctrl + 0 is pressed
            if keyboard.is_pressed('ctrl+0'):
                print("Exiting the program...")
                break

            time.sleep(0.20)  # Wait before the next capture

# Run the function
search_and_click()
