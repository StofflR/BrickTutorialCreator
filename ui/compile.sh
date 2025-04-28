#!bin/bash
source venv/bin/activate
python -m pip freeze > requirements_linux.txt
python -m nuitka --standalone --include-qt-plugins=sensible,styles,qml --plugin-enable=pyside6 --include-data-dir=qml=qml --follow-imports BrickTutorialCreator.py
mkdir -p BrickTutorialCreator.dist/resources/tmp
mkdir -p BrickTutorialCreator.dist/resources/out
mkdir -p BrickTutorialCreator.dist/resources/fonts
cp -r venv/lib/python3.10/site-packages/PySide6/Qt/ BrickTutorialCreator.dist/PySide6/
cp -r base/ BrickTutorialCreator.dist/
cp resources/fonts/Roboto-Bold.ttf BrickTutorialCreator.dist/resources/fonts/Roboto-Bold.ttf
cp resources/fonts/Roboto-Light.ttf BrickTutorialCreator.dist/resources/fonts/Roboto-Light.ttf
cp resources/ccbysa.svg BrickTutorialCreator.dist/resources/ccbysa.svg

mv BrickTutorialCreator.dist BrickTutorialCreator
tar -czvf BrickTutorialCreator.tar.gz BrickTutorialCreator
mv BrickTutorialCreator BrickTutorialCreator.dist
