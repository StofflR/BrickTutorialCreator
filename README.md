# Brick Creator

The application can be run either using the [precompiled executables](https://github.com/StofflR/BrickTutorialCreator/releases), via QtCreator and Qt for Python or [Python3](https://doc.qt.io/qtforpython/quickstart.html).
## Dependencies
### Python:
* [PySide6](https://pypi.org/project/PySide6/)

It is recommended to use Qt 6.x when running the application via QtCreator.
## Running the application with python

Install the necessary dependencies with 
```python3 -m pip install PySide6 ```
after that simply run 
```python3 BrickTutorialCreator.py ```
from the containing folder.

### Using PyCharm
In the configuration sett the working directory to
```path\to\BrickTutorialCreator\ui```
and set the target for the script to
```BrickTutorialCreator\ui\BrickTutorialCreator.py```
.

## Compiling
### Nukita
To compile the application the scripts ```compile.sh``` or ```compile.bat``` can be used. To use the scripts it is necessary to create a [virtual environment](https://doc.qt.io/qtforpython/quickstart.html) in the same directory with ```python3 -m venv venv``` and installing the necessary dependencies in the virtual environment ```venv\path\to\python3 -m pip install nuitka PySide6```.

# 
Note: When modifying the resources file, you will need to use ```path\to\venv\pyside6-rcc resources.qrc -o resources_rc.py``` to make the resources avaiable for the application.