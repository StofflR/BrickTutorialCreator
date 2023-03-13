@ECHO off
.\venv\Scripts\python.exe -m nuitka --standalone --include-qt-plugins=all --plugin-enable=pyside6 --include-data-dir=qml=qml --follow-imports main.py
copy .\venv\Lib\site-packages\PySide6\QtWebEngineProcess.exe .\main.dist\PySide6\QtWebEngineProcess.exe
xcopy.exe .\venv\Lib\site-packages\PySide6\resources\ .\main.dist\PySide6\resources\ /s
mkdir .\main.dist\resources\tmp
xcopy.exe .\base\ .\main.dist\base\ /s
copy .\resources\icon.svg .\main.dist\resources\icon.svg