@ECHO off
.\venv\Scripts\python.exe -m nuitka --standalone --include-qt-plugins=all --plugin-enable=pyside6 --include-data-dir=qml=qml --windows-icon-from-ico=.\resources\icon.ico --follow-imports BrickTutorialCreator.py
copy .\venv\Lib\site-packages\PySide6\QtWebEngineProcess.exe .\BrickTutorialCreator.dist\PySide6\QtWebEngineProcess.exe
xcopy.exe .\venv\Lib\site-packages\PySide6\resources\ .\BrickTutorialCreator.dist\PySide6\resources\ /s
mkdir .\BrickTutorialCreator.dist\resources\tmp
xcopy.exe .\base\ .\BrickTutorialCreator.dist\base\ /s
copy .\resources\icon.svg .\BrickTutorialCreator.dist\resources\icon.svg
echo "Zipping Application ..."
ren BrickTutorialCreator.dist BrickTutorialCreator
tar.exe -a -cf BrickTutorialCreator.zip BrickTutorialCreator
ren BrickTutorialCreator BrickTutorialCreator.dist