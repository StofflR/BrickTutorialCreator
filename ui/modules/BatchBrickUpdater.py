import re
import os, sys

class BatchBrickUpdater:
    def __init__(self, path: str):
        self.path = path
        self.colorDict = {
            "408ac5": "blue",
            "f99761": "lightorange",
            "cf5717": "orange",
            "305716": "darkgreen",
            "26a6ae": "cyan",
            "6b9c49": "green",
            "8f4cba": "violet",
            "cf7aa6": "pink",
            "fccb41": "yellow",
            "f24e50": "red",
            "95750c": "gold",
            "395cab": "darkblue",
            "aea626": "olive"
        }
        self.heigthDict = {
            "72": "1h",
            "71.739": "1h_control",
            "96": "2h",
            "95": "2h_control",
            "119.063": "3h"}

        self.unicodeDict = {
            "&#246;": "ö",
            "&#223;": "ß",
            "&#252;": "ü",
            "&#228;": "ä",
            "&#176;": "°",
            "&#178;": "²",
            "&lt;": "<",
            "&gt;": ">"}

    @staticmethod
    def findHeight(text):
        m = re.search(r"viewBox=\"0 0 ", text)
        sub = text.find("\">", m.span()[1])
        return text[m.span()[1]:sub].split(" ")[1]

    @staticmethod
    def findColor(text):
        m = re.search(r"cls-4\{fill(.){8}", text)
        return text[m.span()[1] - 6: m.span()[1]]

    @staticmethod
    def findText(text):
        end = text[0:-1].find("<ns0:text id=\"text\" ")
        data = []
        start_line = start_poly = start_text = 0
        x_pos = -1
        while start_poly > -1 or start_line > -1 or start_text > -1:
            start_text = text[end:-1].find("<ns0:text id=\"text\" ")
            start_poly = text[end:-1].find("<ns0:polygon ")
            start_line = text[end:-1].find("<ns0:line ")
            text = text[end:]
            search_line = (start_line < start_poly or start_poly < 0) and (
                    start_line < start_text or start_text < 0) and start_line >= 0
            search_poly = (start_poly < start_line or start_line < 0) and (
                    start_poly < start_text or start_text < 0) and start_poly >= 0
            search_text = (start_text < start_poly or start_poly < 0) and (
                    start_text < start_line or start_line < 0) and start_text >= 0
            if search_text:
                start = text.find(";\">")
                m = re.search(r'x="().{0,10}px"', text[start_text:start])
                if m:
                    match = m.string[m.span()[0]:m.span()[1]]
                    match = match.replace('x="', "").replace('px"', "")
                    match = float(match.replace(" ", ""))
                    print("line pos:", match)
                    if match > x_pos != -1:
                        data.append("nl")
                    if match > x_pos:
                        x_pos = match
                start_text = start
            search_text = (start_text < start_poly or start_poly < 0) and (
                    start_text < start_line or start_line < 0) and start_text >= 0

            if search_text:
                end = text.find("</ns0:text>")
                if start_poly <= end:
                    print(text[start_text + 3:end])
                    data.append(text[start_text + 3:end])
                end = end + len("</ns0:text>")

            if search_poly:
                end = text.find("/>")
                end = end + 2
                if start_poly <= end:
                    data.append("poly")

            if search_line:
                end = text.find("/>")
                end = end + 2
                if start_line <= end:
                    data.append("line")
        return data

    def convert(self, brick):
        file = open(brick, 'r')
        text = "\n".join(file.readlines())
        color = self.findColor(text)
        heigth = self.findHeight(text)
        data = self.findText(text)
        return {"color": self.colorDict[color], "height": self.heigthDict[heigth], "data": data}

    @staticmethod
    def parse(param):
        line, poly, nl = False
        string = ""
        for element in param:
            if element == "nl":
                string += "\n"
            elif element != "line" and element != "poly":
                pad = "" + "$" * line + "*" * poly
                if nl or poly or line:
                    element = element.strip(" ")
                string = string + pad + element + pad
            line = element == "line"
            poly = element == "poly"
            nl = element == "nl"
        return string


    def resolveBrick(self):
        data = self.convert(self.brick_path)
        content = re.sub(" +", " ", self.parse(data["data"]))
        for key in self.unicodeDict.keys():
            content = content.replace(key, self.unicodeDict.get(key))

        print("PATH:", self.brick_path)
        print("DATA:", data)
        print("CONTENT:", content)
        return data, content

    if __name__ == '__main__':

        from PySide6.QtCore import QUrl, Qt
        from PySide6.QtQuick import QQuickWindow, QSGRendererInterface
        from PySide6.QtWebEngineQuick import QtWebEngineQuick
        from PySide6.QtGui import QGuiApplication, QFontDatabase, QIcon
        from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, QQmlDebuggingEnabler

        QGuiApplication.setAttribute(Qt.AA_ShareOpenGLContexts, True)
        QQuickWindow.setGraphicsApi(QSGRendererInterface.OpenGLRhi)
        QtWebEngineQuick.initialize()
        app = QGuiApplication(sys.argv)
        QFontDatabase.addApplicationFont(QUrl.fromLocalFile(
            os.getcwd()).toString() + "/ui/qml/font/Roboto-Bold.ttf")
        QFontDatabase.addApplicationFont(QUrl.fromLocalFile(
            os.getcwd()).toString() + "/ui/qml/font/Roboto-Light.ttf")
        engine = QQmlApplicationEngine()
        f = []
        root_dir = "bricks"
        file_set = []

        for dir_, _, files in os.walk(root_dir):
            for file_name in files:
                rel_dir = os.path.relpath(dir_, root_dir)
                rel_file = os.path.join(rel_dir, file_name)
                file_set.append(os.path.join(root_dir, rel_file))
        print(file_set)
        bricks = [r"bricks\RaspberryPi\Set_Raspberry_Pi_PWM_pin_3_to_50_%_100_Hz.svg"]
        base = r"..\..\BrickTutorialCreator\ui\base"
        converted = 0
        total = len(file_set)
        if False:
            file_set = bricks
        for brick_path in file_set:
            data, content = BatchBrickUpdater(brick_path).resolveBrick()
            os.chdir(r".\ui")
            brick = SVGBrick.SVGBrick(data["color"], content, data["height"].replace("h", ""),
                                      "brick_" + data["color"] + "_" + data["height"] + ".svg")
            os.chdir("..")
            target_path = os.getcwd() + "/converted" + "\\".join(brick_path.replace("bricks", "").split("\\")[0:-1])
            if not os.path.exists(target_path):
                os.makedirs(target_path)
            print(target_path)
            brick.save(
                target_path + "\\" + re.sub(" +", " ", brick.contentPlain()).replace(" ", "_").replace("/", "")
                .replace(":", "").replace("<", " lt ").replace(">", " gt "))
            converted += 1
            print("Converted: ", converted / total * 100, "%")
