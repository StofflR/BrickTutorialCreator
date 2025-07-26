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

class BrickLoader : public QObject {
  Q_OBJECT
  QML_ELEMENT
public:
  BrickLoader(QObject *parent = nullptr);
  ~BrickLoader() = default;

  Q_INVOKABLE void loadFile(const QUrl &filePath);

signals:
  void fileLoaded(const QString &content, const QString &type,
                  const QString &size, const QString &color,
                  const QString &shade, const QString &border,
                  const QString &textColor);
  void positionLoaded(double xPos, double yPos);
  void widthLoaded(int width);

private:
  void loadJSONDocument(const QByteArray &data);
  void loadFromPNG(QFile *file);
  void loadFromSVG(QFile *file);
  void loadFromJSON(QFile *file);
};