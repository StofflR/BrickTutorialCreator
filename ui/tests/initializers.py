from PySide6.QtGui import QGuiApplication, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
import os
from modules.Utility import generateRequiredFolders
from modules.ConstDefs import *

from PIL import Image
import skimage
import numpy as np

app = None


def compareImages(img1, img2):
    # Convert images to grayscale if needed
    image1 = Image.open(img1)
    image2 = Image.open(img2)

    # Resize the image
    # Calculate SSIM
    ssim_value, _ = skimage.metrics.structural_similarity(
        np.array(image1), np.array(image2), full=True, data_range=1.0, win_size=3
    )
    image1.close()
    image2.close()
    print("comparing: ", img1, img2, ssim_value)
    return ssim_value


def initQt():
    generateRequiredFolders()
    global app
    if not app:
        app = QGuiApplication()
        assert (
            QFontDatabase.addApplicationFont(
                os.getcwd() + "/resources/fonts/Roboto-Bold.ttf"
            )
            != -1
        )
        assert (
            QFontDatabase.addApplicationFont(
                os.getcwd() + "/resources/fonts/Roboto-Light.ttf"
            )
            != -1
        )
    engine = QQmlApplicationEngine()
    fontStyles = QFontDatabase.styles("Roboto")

    for style in fontStyles:
        font = QFontDatabase.font("Roboto", style, 12)
        engine.rootContext().setContextProperty(style.lower() + "Roboto", font)
