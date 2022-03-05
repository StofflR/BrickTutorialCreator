# Brick Creator

The application can be run either using the precompiled executables (windows / linux), via QtCreator with Qt for Python capabilities or plain [Python](https://doc.qt.io/qtforpython/quickstart.html).
Note: when modifying the resources file, you will need to use `pyside6-rcc resources.qrc -o resources_rc.py` to make the resources avaiable for the application.
## Dependencies
### Python:
* [PySide6](https://pypi.org/project/PySide6/)

It is recommended to use Qt 6.x when running the application via QtCreator.

## Compiling
### Nukita
To compile the application from python source you need to install nuitka 
```
python3 -m pip install nuitka 
```
and execute the following install command in form the *../BrickCreator/ui* durectory
```
python3 -m nuitka --onefile --include-qt-plugins=sensible,styles,qml --plugin-enable=pyside6 --include-data-dir=qml=qml --follow-imports main.py
```

## Usage:
### Interface:
\#TODO: add GUI description

### Adding Content:
By writing data in the input field the content will be addded on the brick. There are various operators wihich can add the various brick features such as variables and dropdown elements.

* Variables: $ some sample var $
* New Line: \\n or Enter
* New Line with spacing: \\\\
* Dropdown: \* some sample var \*

## WIP:
* Help / About Text
* Tutorial export to / load from JSON
* OS specific text length calculation
* redo Brickcreator Bricks (missing json description)
* setup automatic testing pipeline
* bug fixes and functionality:
* * Tutorial Creator -> crash on path missing
* * Magic Word on Tutorial & SVGBrick JSON / SVG
* * Clear name for Tutorial
* * Ask vor overwrite / duplicate file
* * export / save sucessfull notification (bottom of window)
* * help / about messages
* * relativ path to files 
* * * create utility to clean up paths if not relative
* * ask if current tutorial should be appended or cleared on load
* * create Tutorial Class with functionality of creating the tutorial
