@ECHO off
python3 -m nuitka --onefile --include-qt-plugins=sensible,styles,qml --plugin-enable=pyside6 --include-data-dir=qml=qml --follow-imports main.py
