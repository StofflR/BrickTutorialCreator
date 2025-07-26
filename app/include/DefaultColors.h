#pragma once

#include <QColor>
#include <QObject>
#include <QtQml>

class DefaultColors : public QObject {
  Q_OBJECT
  QML_SINGLETON
  QML_ELEMENT
public:
  DefaultColors(QObject *parent = nullptr) : QObject(parent) {};
  virtual ~DefaultColors() = default;

  Q_PROPERTY(QColor blue MEMBER _blue CONSTANT)
  Q_PROPERTY(QColor blueShade MEMBER _blueShade CONSTANT)
  Q_PROPERTY(QColor blueBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor blueText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor cyan MEMBER _cyan CONSTANT)
  Q_PROPERTY(QColor cyanShade MEMBER _cyanShade CONSTANT)
  Q_PROPERTY(QColor cyanBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor cyanText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor darkBlue MEMBER _darkBlue CONSTANT)
  Q_PROPERTY(QColor darkBlueShade MEMBER _darkBlueShade CONSTANT)
  Q_PROPERTY(QColor darkBlueBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor darkBlueText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor gold MEMBER _gold CONSTANT)
  Q_PROPERTY(QColor goldShade MEMBER _goldShade CONSTANT)
  Q_PROPERTY(QColor goldBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor goldText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor darkGreen MEMBER _darkGreen CONSTANT)
  Q_PROPERTY(QColor darkGreenShade MEMBER _darkGreenShade CONSTANT)
  Q_PROPERTY(QColor darkGreenBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor darkGreenText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor green MEMBER _green CONSTANT)
  Q_PROPERTY(QColor greenShade MEMBER _greenShade CONSTANT)
  Q_PROPERTY(QColor greenBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor greenText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor lightOrange MEMBER _lightOrange CONSTANT)
  Q_PROPERTY(QColor lightOrangeShade MEMBER _lightOrangeShade CONSTANT)
  Q_PROPERTY(QColor lightOrangeBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor lightOrangeText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor olive MEMBER _olive CONSTANT)
  Q_PROPERTY(QColor oliveShade MEMBER _oliveShade CONSTANT)
  Q_PROPERTY(QColor oliveBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor oliveText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor orange MEMBER _orange CONSTANT)
  Q_PROPERTY(QColor orangeShade MEMBER _orangeShade CONSTANT)
  Q_PROPERTY(QColor orangeBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor orangeText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor yellow MEMBER _yellow CONSTANT)
  Q_PROPERTY(QColor yellowShade MEMBER _yellowShade CONSTANT)
  Q_PROPERTY(QColor yellowBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor yellowText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor violet MEMBER _violet CONSTANT)
  Q_PROPERTY(QColor violetShade MEMBER _violetShade CONSTANT)
  Q_PROPERTY(QColor violetBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor violetText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor pink MEMBER _pink CONSTANT)
  Q_PROPERTY(QColor pinkShade MEMBER _pinkShade CONSTANT)
  Q_PROPERTY(QColor pinkBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor pinkText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor red MEMBER _red CONSTANT)
  Q_PROPERTY(QColor redShade MEMBER _redShade CONSTANT)
  Q_PROPERTY(QColor redBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor redText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor winered MEMBER _winered CONSTANT)
  Q_PROPERTY(QColor wineredShade MEMBER _wineredShade CONSTANT)
  Q_PROPERTY(QColor wineredBorder MEMBER _defaultBorder CONSTANT)
  Q_PROPERTY(QColor wineredText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor white MEMBER _white CONSTANT)
  Q_PROPERTY(QColor whiteShade MEMBER _whiteShade CONSTANT)
  Q_PROPERTY(QColor whiteBorder MEMBER _whiteBorder CONSTANT)
  Q_PROPERTY(QColor whiteText MEMBER _blueText CONSTANT)

  Q_PROPERTY(QColor transparentWhite MEMBER _transparentWhite CONSTANT)
  Q_PROPERTY(
      QColor transparentWhiteShade MEMBER _transparentWhiteShade CONSTANT)
  Q_PROPERTY(
      QColor transparentWhiteBorder MEMBER _transparentWhiteBorder CONSTANT)
  Q_PROPERTY(QColor transparentWhiteText MEMBER _blackText CONSTANT)

  Q_PROPERTY(QColor transparentBlack MEMBER _transparentBlack CONSTANT)
  Q_PROPERTY(
      QColor transparentBlackShade MEMBER _transparentBlackShade CONSTANT)
  Q_PROPERTY(
      QColor transparentBlackBorder MEMBER _transparentBlackBorder CONSTANT)
  Q_PROPERTY(QColor transparentBlackText MEMBER _defaultText CONSTANT)

  Q_PROPERTY(QColor textBlack MEMBER _blackText CONSTANT)
  Q_PROPERTY(QColor textBlue MEMBER _blueText CONSTANT)
  Q_PROPERTY(QColor textDefault MEMBER _defaultText CONSTANT)
  Q_PROPERTY(QColor borderDefault MEMBER _defaultBorder CONSTANT)

private:
  QColor _blue = QColor("#408ac5");
  QColor _blueShade = QColor("#27567c");
  QColor _cyan = QColor("#26a6ae");
  QColor _cyanShade = QColor("#2e7078");
  QColor _darkBlue = QColor("#395cab");
  QColor _darkBlueShade = QColor("#889dcd");
  QColor _gold = QColor("#95750c");
  QColor _goldShade = QColor("#57452c");
  QColor _darkGreen = QColor("#305716");
  QColor _darkGreenShade = QColor("#173718");
  QColor _green = QColor("#6b9c49");
  QColor _greenShade = QColor("#486822");
  QColor _lightOrange = QColor("#f99761");
  QColor _lightOrangeShade = QColor("#a86d45");
  QColor _olive = QColor("#aea626");
  QColor _oliveShade = QColor("#7e7a30");
  QColor _orange = QColor("#cf5717");
  QColor _orangeShade = QColor("#7a3a18");
  QColor _yellow = QColor("#fccb41");
  QColor _yellowShade = QColor("#aa8832");
  QColor _violet = QColor("#8f4cba");
  QColor _violetShade = QColor("#5d2d7c");
  QColor _pink = QColor("#cf7aa6");
  QColor _pinkShade = QColor("#935e7b");
  QColor _red = QColor("#f24e50");
  QColor _redShade = QColor("#ae2f2f");
  QColor _winered = QColor("#910d06");
  QColor _wineredShade = QColor("#750701");
  QColor _white = QColor("#ffffff");
  QColor _whiteShade = QColor("#a9b4cd");
  QColor _whiteBorder = QColor("#274383");
  QColor _transparentWhite = QColor(255, 255, 255, 255);
  QColor _transparentWhiteShade = QColor(255, 255, 255, 255);
  QColor _transparentWhiteBorder = QColor(255, 255, 255, 255);
  QColor _transparentBlack = QColor(0, 0, 0, 255);
  QColor _transparentBlackShade = QColor(0, 0, 0, 255);
  QColor _transparentBlackBorder = QColor(0, 0, 0, 255);
  QColor _defaultBorder = QColor("#383838");

  QColor _blackText = QColor("#000000");
  QColor _blueText = QColor("#0000ff");
  QColor _defaultText = QColor("#ffffff");
};