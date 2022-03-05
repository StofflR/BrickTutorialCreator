from resources.modules.SVGBrick import SVGBrick


def test_svg_brick():
    print("Start testing")
    contents = [
        "Normal Text",
        "Normal Text\\Line break",
        "Normal $var$",
        "Long $var with default content$",
        "Long $var with incomplete content",
        "var $IIIIIIIllllll",
        "var $MMMMMMmmmmmm$",
        "Dropdown var *drop this*",
        "Dropdown var *incomplete drop",
    ]
    scale = 1
    base_file = "C:/Users/Stoffl/Documents/GIT/BrickTutorialCreator/TutorialCreator/resources/base/brick_blue_1h.svg"
    out_path = "resources/modules/out_test/"

    for content in contents:
        brick = SVGBrick(
            "blue", content, 1, base_file, scaling_factor=scale)
        brick.save(path=out_path +
                   brick.contentPlain().replace(" ", "_")+".svg")
        brick.savePNG(path=out_path +
                      brick.contentPlain().replace(" ", "_")+".svg")
    input()


if __name__ == '__main__':
    test_svg_brick()
