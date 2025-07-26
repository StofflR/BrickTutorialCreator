#pragma once

#include <QPainter>
#include <QQmlEngine>
#include <QQuickPaintedItem>
#include <QSvgRenderer>
#include <QUrl>

class Brick : public QQuickPaintedItem {
  Q_OBJECT
  QML_ELEMENT

  // Qt Properties
  Q_PROPERTY(QString content MEMBER _content NOTIFY updateBrick)
  Q_PROPERTY(QString brickSize MEMBER _size NOTIFY sizeChanged)
  Q_PROPERTY(QString brickPath MEMBER _path NOTIFY updateBrick)
  Q_PROPERTY(QString brickName MEMBER _name NOTIFY updateBrick)
  Q_PROPERTY(double scalingFactor MEMBER _scalingFactor NOTIFY updateBrick)
  Q_PROPERTY(double xPos MEMBER _xPos NOTIFY updateBrick)
  Q_PROPERTY(double yPos MEMBER _yPos NOTIFY updateBrick)
  Q_PROPERTY(bool autoSave MEMBER _autoSave NOTIFY updateBrick)
  Q_PROPERTY(QString baseType MEMBER _baseType NOTIFY updateBrick)
  Q_PROPERTY(QString color MEMBER _color NOTIFY updateBrick)
  Q_PROPERTY(QString colorShade MEMBER _colorShade NOTIFY updateBrick)
  Q_PROPERTY(QString colorBorder MEMBER _colorBorder NOTIFY updateBrick)
  Q_PROPERTY(QString colorText MEMBER _colorText NOTIFY updateBrick)
  Q_PROPERTY(QFont font MEMBER _font NOTIFY updateBrick)

  Q_PROPERTY(bool toSVG MEMBER _toSVG NOTIFY updateBrick)
  Q_PROPERTY(bool toPNG MEMBER _toPNG NOTIFY updateBrick)
  Q_PROPERTY(bool toJSON MEMBER _toJSON NOTIFY updateBrick)

  Q_PROPERTY(double brickWidth MEMBER _width NOTIFY updateBrick)
  Q_PROPERTY(double brickHeight MEMBER _height NOTIFY updateBrick)

  Q_PROPERTY(double yStartPosition READ yPosStart NOTIFY updateSlider)

public:
  explicit Brick(QQuickItem *parent = nullptr);
  explicit Brick(const QJsonObject &jsonObject, QString name, QString path = "",
                 QFont font = QFont());
  virtual ~Brick() = default;
  void paint(QPainter *painter) override;

  Q_INVOKABLE void saveBrick();
  Q_INVOKABLE void saveSVG();
  Q_INVOKABLE void savePNG();
  Q_INVOKABLE void saveJSON();

  QImage generateImage();

  double yPosStart();
  QSize targetSize();

signals:
  void updateBrick();
  void updateSlider();
  void sizeChanged();

private:
  void generateBrick(QPainter *painter, QSvgRenderer &svgRenderer);
  void generateBrick(QPainter *painter);
  void updateFontSize(QPainter *painter);

  QString _content;
  QString _baseType;
  QString _color;
  QString _colorShade;
  QString _colorBorder;
  QString _colorText;
  QString _size;
  QString _path;
  QString _name;
  QFont _font;

  double _scalingFactor = 1.0;
  double _xPos;
  double _yPos;
  int _width;
  int _height;

  bool _autoSave;
  bool _toSVG;
  bool _toPNG;
  bool _toJSON;
};
