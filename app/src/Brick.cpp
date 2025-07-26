#include "Brick.h"
#include "BaseBrickGenerator.h"
#include "BrickGenerator.h"
#include "BrickUtility.h"
#include "JSONGenerator.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

Brick::Brick(QQuickItem *parent) : QQuickPaintedItem(parent) {
  connect(this, &Brick::updateBrick, this, [this]() {
    auto sizeIt = constants::sizeMap.find(_size);
    if (sizeIt == constants::sizeMap.end()) {
      sizeIt = constants::sizeMap.find("H1");
    }
    setHeight(width() * (sizeIt->second.second / sizeIt->second.first));
    _height = _width * (sizeIt->second.second / sizeIt->second.first);
    update();
  });
  connect(this, &Brick::sizeChanged, this, &Brick::updateBrick);
  connect(this, &QQuickPaintedItem::heightChanged, this, &Brick::updateSlider);
  connect(this, &Brick::sizeChanged, this, &Brick::updateSlider);
}

void Brick::updateFontSize(QPainter *painter) {

  auto fontScale = painter->device()->logicalDpiX() / constants::baseDPI;

  auto lineFactor = constants::lineWidthMap.find(_size);
  if (lineFactor == constants::lineWidthMap.end()) {
    lineFactor = constants::lineWidthMap.find("H1");
  }

  _font.setPointSizeF(
      height() * lineFactor->second * fontScale *
      _scalingFactor); // Adjust font size based on scaling factor
}

void Brick::paint(QPainter *painter) {
  if (!painter || _name.isEmpty() || _path.isEmpty())
    return;

  auto directory = QDir(_path);
  if (!directory.exists()) {
    qInfo() << "Creating directory:" << _path;
    directory.mkpath(".");
  }

  updateFontSize(painter);

  if (_autoSave) {
    BrickUtility::updateStatusMessage("Auto-saving brick...");
    saveBrick();
  }

  generateBrick(painter);
}

void Brick::generateBrick(QPainter *painter, QSvgRenderer &svgRenderer) {
  painter->setPen(QColor(_colorText));
  painter->setFont(_font);
  svgRenderer.render(painter);
  BrickGenerator::generateContent(painter, _xPos, _yPos, width() * 0.9,
                                  _content);
};

void Brick::generateBrick(QPainter *painter) {
  QSvgRenderer svgRenderer;
  svgRenderer.setAspectRatioMode(Qt::KeepAspectRatio);
  svgRenderer.load(BaseBrickGenerator::generateBaseBrick(
                       _baseType, _size, _color, _colorShade, _colorBorder)
                       .toLocalFile());
  generateBrick(painter, svgRenderer);
};

void Brick::saveBrick() {
  if (_toSVG)
    saveSVG();

  if (_toPNG)
    savePNG();

  if (_toJSON)
    saveJSON();
}

void Brick::saveSVG() {
  auto metadata = JSONGenerator::createJSON(
      _size, _baseType, _color, _colorShade, _colorBorder, _colorText, _width,
      _xPos, _yPos, _content);

  QFile file(QDir(_path).filePath(
      _name.endsWith(utility::svgSuffix) ? _name : _name + utility::svgSuffix));
  BrickGenerator::generateSVG(
      file, size().toSize(),
      [this](QPainter *filePainter) {
        updateFontSize(filePainter);
        generateBrick(filePainter);
      },
      metadata);
}

void Brick::savePNG() {
  auto metadata = JSONGenerator::createJSON(
      _size, _baseType, _color, _colorShade, _colorBorder, _colorText, _width,
      _xPos, _yPos, _content);
  QFile file(QDir(_path).filePath(
      _name.endsWith(utility::pngSuffix) ? _name : _name + utility::pngSuffix));
  BrickGenerator::generatePNG(
      file, size().toSize(),
      [this](QPainter *filePainter) {
        updateFontSize(filePainter);
        generateBrick(filePainter);
      },
      targetSize(), metadata);
}

QImage Brick::generateImage() {
  return BrickGenerator::generateImage(
      size().toSize(), targetSize(),
      [this](QPainter *filePainter) { this->generateBrick(filePainter); });
}

Brick::Brick(const QJsonObject &jsonObject, QString name, QString path,
             QFont font)
    : QQuickPaintedItem(), _path(path), _name(name), _font(font) {
  JSONGenerator::readJSON(jsonObject, _size, _baseType, _color, _colorShade,
                          _colorBorder, _colorText, _width, _xPos, _yPos,
                          _content);

  auto sizeIt = constants::sizeMap.find(_size);
  if (sizeIt == constants::sizeMap.end()) {
    sizeIt = constants::sizeMap.find("H1");
  }
  setWidth(_width);
  setHeight(width() * (sizeIt->second.second / sizeIt->second.first));
  _height = _width * (sizeIt->second.second / sizeIt->second.first);
}

double Brick::yPosStart() {
  auto yPosIt = constants::blockStartMap.find(_size);
  auto yHeightIt = constants::sizeMap.find(_size);
  if (yPosIt == constants::blockStartMap.end() ||
      yHeightIt == constants::sizeMap.end()) {
    yPosIt = constants::blockStartMap.find("H1");
    yHeightIt = constants::sizeMap.find("H1");
  }

  double yPos = yPosIt->second;
  double yHeight = yHeightIt->second.second;
  return yPos * (height() / yHeight);
}

void Brick::saveJSON() {
  QFile file(QDir(_path).filePath(_name.endsWith(utility::jsonSuffix)
                                      ? _name
                                      : _name + utility::jsonSuffix));
  QJsonObject jsonObject = JSONGenerator::createJSON(
      _size, _baseType, _color, _colorShade, _colorBorder, _colorText, _width,
      _xPos, _yPos, _content);
  JSONGenerator::saveJSON(file, jsonObject);
}

QSize Brick::targetSize() { return QSize(_width, _height); }