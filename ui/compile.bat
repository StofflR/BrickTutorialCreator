@ECHO off
.\venv\Scripts\python.exe -m pip freeze > requirements_win.txt
.\venv\Scripts\python.exe -m nuitka --standalone --include-qt-plugins=all --plugin-enable=pyside6 --include-data-dir=qml=qml --windows-icon-from-ico=.\resources\icon.ico --follow-imports BrickTutorialCreator.py
copy .\venv\Lib\site-packages\PySide6\QtWebEngineProcess.exe .\BrickTutorialCreator.dist\PySide6\QtWebEngineProcess.exe
xcopy.exe .\venv\Lib\site-packages\PySide6\resources\ .\BrickTutorialCreator.dist\PySide6\resources\ /s
mkdir .\BrickTutorialCreator.dist\resources\tmp
mkdir .\BrickTutorialCreator.dist\resources\out
mkdir .\BrickTutorialCreator.dist\resources\fonts
xcopy.exe .\base\ .\BrickTutorialCreator.dist\base\ /s
copy .\resources\icon.svg .\BrickTutorialCreator.dist\resources\icon.svg
copy .\resources\fonts\Roboto-Bold.ttf .\BrickTutorialCreator.dist\resources\fonts\Roboto-Bold.ttf
copy .\resources\fonts\Roboto-Light.ttf .\BrickTutorialCreator.dist\resources\fonts\Roboto-Light.ttf
copy .\resources\ccbysa.svg .\BrickTutorialCreator.dist\resources\ccbysa.svg

echo "Zipping Application ..."
ren BrickTutorialCreator.dist BrickTutorialCreator
tar.exe -a -cf BrickTutorialCreator.zip BrickTutorialCreator
ren BrickTutorialCreator BrickTutorialCreator.dist
