import re
import ui.modules.SVGBrick as SVGBrick
colorDict = {
    "408ac5": "brick_blue"
}
heigthDict = {
    "72": "1h",
    "71.739": "1h_control",
    "96": "2h",
    "95": "2h_control",
    "119.063": "3h"
}


def findHeight(text):
    # viewBox = "0 0 348 71.739" >
    print(text := text.replace("\n", "").strip())
    m = re.search(r"viewBox=\"0 0 ", text)
    sub = text.find("\">", m.span()[1])
    return (text[m.span()[1]:sub].split(" ")[1])


def findColor(text):
    # cls-4{fill:#408ac5;}
    print(text := text.replace("\n", "").replace(" ", ""))
    m = re.search(r"cls-4\{fill(.){8}", text)
    return (text[m.span()[1] - 6: m.span()[1]])


def findText(text):
    # <ns0:text id="text" x="43.0px" y="37.0px" fill="#ffffff" fill-opacity="1" font-weight="bold" xml:space="preserve"
    #          style="font-family: 'Roboto', sans-serif;font-size:12.0pt;">Create clone of </ns0:text>
    # <ns0:polygon points="307.0,43.0 319.0,43.0 313.0,55.0" id="triangle" stroke="white" fill="white" stroke-width="1"/>
    # <ns0:text id="drop" x="53.0px" y="55.0px" fill="#ffffff" fill-opacity="1" font-weight="normal" xml:space="preserve"
    #          style="font-family: 'Roboto Light', sans-serif;font-size:9.600000000000001pt;">yourself</ns0:text>


    #<ns0:text id="text" x="43.0px" y="37.0px" fill="#ffffff" fill-opacity="1" font-weight="bold" xml:space="preserve"
    #          style="font-family: 'Roboto', sans-serif;font-size:12.0pt;">For values from </ns0:text>
    #<ns0:line id="var_line" x1="163.0" y1="39.0" x2="183.0" y2="39.0" stroke="#ffffff" fill="#ffffff" stroke-width="1"/>
    #<ns0:text id="var" x="163.0px" y="37.0px" fill="#ffffff" fill-opacity="1" font-weight="normal" xml:space="preserve"
    #          style="font-family: 'Roboto Light', sans-serif;font-size:12.0pt;"> 1  </ns0:text>
    #<ns0:text id="text" x="183.0px" y="37.0px" fill="#ffffff" fill-opacity="1" font-weight="bold" xml:space="preserve"
    #          style="font-family: 'Roboto', sans-serif;font-size:12.0pt;"> to </ns0:text>
    #<ns0:line id="var_line" x1="203.0" y1="39.0" x2="232.0" y2="39.0" stroke="#ffffff" fill="#ffffff" stroke-width="1"/>
    #<ns0:text id="var" x="203.0px" y="37.0px" fill="#ffffff" fill-opacity="1" font-weight="normal" xml:space="preserve"
    #          style="font-family: 'Roboto Light', sans-serif;font-size:12.0pt;"> 10  </ns0:text>
    #<ns0:text id="text" x="232.0px" y="37.0px" fill="#ffffff" fill-opacity="1" font-weight="bold" xml:space="preserve"
    #          style="font-family: 'Roboto', sans-serif;font-size:12.0pt;"> in </ns0:text>
    #<ns0:polygon points="307.0,43.0 319.0,43.0 313.0,55.0" id="triangle" stroke="white" fill="white" stroke-width="1"/>
    #<ns0:text id="drop" x="53.0px" y="55.0px" fill="#ffffff" fill-opacity="1" font-weight="normal" xml:space="preserve"
    #          style="font-family: 'Roboto Light', sans-serif;font-size:9.600000000000001pt;">new...</ns0:text>
    search = True
    print(text := text.replace("\n", "").replace("\t"," ").strip(" "))
    end = text[0:-1].find("<ns0:text id=\"text\" ")
    data = []
    start_line = start_poly = start_text = 0
    while start_poly > -1 or start_line > -1 or start_text > -1:
        start_text = text[end:-1].find("<ns0:text id=\"text\" ")
        start_poly = text[end:-1].find("<ns0:polygon ")
        start_line = text[end:-1].find("<ns0:line ")
        text = text[end:-1]
        search_line = (start_line < start_poly or start_poly < 0) and (
                    start_line < start_text or start_text < 0) and start_line >= 0
        search_poly = (start_poly < start_line or start_line < 0) and (
                    start_poly < start_text or start_text < 0) and start_poly >= 0
        search_text = (start_text < start_poly or start_poly < 0) and (
                    start_text < start_line or start_line < 0) and start_text >= 0

        if search_text:
            start_text = text.find(";\">")
            end = text.find("</ns0:text>")
            if start_poly <= end:
                print(text[start_text + 3:end])
                data.append(text[start_text + 3:end])
            end = end + len("</ns0:text>")

        if search_poly:
            end = text.find("/>")
            end = end + 3
            if start_poly <= end:
                data.append("poly")

        if search_line:
            end = text.find("/>")
            end = end + 3
            if start_line <= end:
                data.append("line")
    return data


def convert(brick):
    file = open(brick, 'r')
    text = "\n".join(file.readlines())
    color = findColor(text)
    heigth = findHeight(text)
    data = findText(text)
    return {"color": colorDict[color], "height": heigthDict[heigth], "data": data}


def parse(param):
    line = False
    poly = False
    nl = False
    string = ""
    for element in param:
        if element == "nl":
            string += "\n"
        elif element != "line" and element != "poly":
            pad = "" + "$" * line + "*" * poly
            string = string + pad + element + pad
        line = element == "line"
        poly = element == "poly"
    return string


if __name__ == '__main__':
    f = []
    root_dir = "bricks"
    file_set = []

    for dir_, _, files in os.walk(root_dir):
        for file_name in files:
            rel_dir = os.path.relpath(dir_, root_dir)
            rel_file = os.path.join(rel_dir, file_name)
            file_set.append(os.path.join(root_dir, rel_file))
    print(file_set)
    bricks = [r"bricks\Sound\default\Speak_'Hello'_and_wait.svg"]
    base = r"..\..\BrickTutorialCreator\ui\base"
    for brick in bricks:
        print(brick)
        data = convert(brick)
        print(data)
        content = parse(data["data"])
        print(content)
        brick = SVGBrick.SVGBrick(data["color"], content, data["height"].replace("h", ""), base+"\\brick_"+data["color"]+"_"+data["height"]+".svg")
        brick.save()
        print("asd")