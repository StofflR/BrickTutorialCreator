#pragma once

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QQmlEngine>
#include <QRegularExpression>
#include <QString>
#include <QTextDocument>
#include <QTextStream>

class BrickLoader : public QObject
{
  Q_OBJECT
  QML_ELEMENT
public:
  BrickLoader(QObject *parent = nullptr);
  ~BrickLoader() = default;

  Q_INVOKABLE void loadFile(const QUrl &filePath);
  static QJsonObject loadJSONObjectFromFile(QFile &file);

  static QJsonObject loadFromPNG(const QByteArray &data);
  static QJsonObject loadFromSVG(const QByteArray &data);
  static QJsonObject loadFromJSON(const QByteArray &data);

signals:
  void fileLoaded(const QString &content, const QString &type,
                  const QString &size, const QString &color,
                  const QString &shade, const QString &border,
                  const QString &textColor);
  void positionLoaded(double xPos, double yPos);
  void widthLoaded(int width);

private:
  static QJsonObject loadJSONDocument(const QByteArray &data);
};