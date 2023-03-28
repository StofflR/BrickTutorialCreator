import re

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
    while(search):
        start_text = text[end:-1].find("<ns0:text id=\"text\" ")
        start_poly = text[end:-1].find("<ns0:polygon ")
        start_line = text[end:-1].find("<<ns0:line ")

        start = start + text[start:-1].find(";\">")
        end = start + text[start:-1].find("</ns0:text>")
        search = start < end
        if(search):
            print(text[start+3:end])
            data.append(text[start+3:end])
    return data


def convert(brick):
    file = open(brick, 'r')
    text = "\n".join(file.readlines())
    color = findColor(text)
    heigth = findHeight(text)
    data = findText(text)
    return {"color": colorDict[color], "height": heigthDict[heigth], "data": data}


if __name__ == '__main__':
    bricks = ["bricks/ARDrone/Emergency_AR.Drone_2.0.svg"]
    for brick in bricks:
        data = convert(brick)
        print(data)
