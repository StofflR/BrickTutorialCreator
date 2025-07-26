#pragma once

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

class JSONGenerator {
public:
  JSONGenerator() = delete;
  ~JSONGenerator() = delete;

  static void saveJSON(QFile &file, const QJsonObject &jsonObject);
  static QJsonObject createJSON(const QString &size, const QString &type,
                                const QString &color, const QString &colorShade,
                                const QString &colorBorder,
                                const QString &colorText, double width,
                                double xPos, double yPos,
                                const QString &content);
  static bool readJSON(const QJsonObject &jsonObject, QString &size,
                       QString &type, QString &color, QString &colorShade,
                       QString &colorBorder, QString &colorText, int &width,
                       double &xPos, double &yPos, QString &content);
};