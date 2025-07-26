#pragma once

#include <QMap>
#include <QObject>
#include <QtQml>

class DefaultBricks : public QObject {
  Q_OBJECT
  QML_SINGLETON
  QML_ELEMENT

public:
  DefaultBricks(QObject *parent = nullptr);
  virtual ~DefaultBricks() = default;

  enum BrickSizes {
    H0, // 0 height
    H1, // 1 height
    H2, // 2 height
    H3, // 3 height
  };
  Q_ENUM(BrickSizes)

  enum BrickTypes { Base, Collapsed, Control };
  Q_ENUM(BrickTypes)

  enum BrickTypeRoles { Size, Type };
  Q_ENUM(BrickTypeRoles)

  enum DefaultBrickColors {
    Blue,
    Cyan,
    DarkBlue,
    Gold,
    DarkGreen,
    Green,
    LightOrange,
    Olive,
    Orange,
    Yellow,
    Violet,
    Pink,
    Red,
    Winered,
    White,
    TransparentWhite,
    TransparentBlack
  };
  Q_ENUM(DefaultBrickColors)

  enum BrickColorRoles { Color, Shade, Border, Text };
  Q_ENUM(BrickColorRoles)

  Q_PROPERTY(QVariantMap colorSchemes READ colorSchemes CONSTANT)
  Q_PROPERTY(QVariantList brickSizes READ brickSizes CONSTANT)
  Q_PROPERTY(QVariantList brickTypes READ brickTypes CONSTANT)

public:
  static const QVariantList brickTypes();
  static const QVariantList brickSizes();
  static const QVariantMap sizeSchemes();
  static const QVariantMap colorSchemes();
};
