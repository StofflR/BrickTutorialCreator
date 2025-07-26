#pragma once

#include <QDir>
#include <QStandardPaths>
#include <QString>
#include <QUrl>

class BaseBrickGenerator {
public:
  static QUrl generateBaseBrick(
      const QString &type, const QString &size, const QString &color,
      const QString &colorShade, const QString &colorBorder,
      QDir targetDir = QDir(
          QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)));
  ;
};
