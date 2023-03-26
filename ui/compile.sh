#!bin/bash
sudo apt-get install python3-pip python3-venv patchelf ccache -y
python3 -m -venv venv
source venv/bin/activate
./venv/bin/python3 -m pip install PySide6 nuitka
./venv/bin/python3 -m nuitka --standalone --include-qt-plugins=sensible,styles,qml --plugin-enable=pyside6 --include-data-dir=qml=qml --follow-imports BrickTutorialCreator.py
mkdir -p BrickTutorialCreator.dist/resources/tmp
cp -r venv/lib/python3.10/site-packages/PySide6/Qt/ BrickTutorialCreator.dist/PySide6/
cp -r base/ BrickTutorialCreator.dist/
mv BrickTutorialCreator.dist BrickTutorialCreator
tar -czvf BrickTutorialCreator.tar.gz BrickTutorialCreator
mv BrickTutorialCreator BrickTutorialCreator.dist
