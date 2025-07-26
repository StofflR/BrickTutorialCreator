#pragma once

#include <QFile>
#include <QImage>
#include <QJsonDocument>
#include <QJsonObject>
#include <QPainter>

class BrickGenerator {
public:
  BrickGenerator() = default;
  ~BrickGenerator() = default;

  static void generateSVG(QFile &file, const QSize &generatorSize,
                          std::function<void(QPainter *)> generateBrick,
                          std::optional<QJsonObject> metadata = std::nullopt);
  static QImage generateImage(const QSize &generatorSize, QSize targetSize,
                              std::function<void(QPainter *)> generateBrick);
  static void generatePNG(QFile &file, const QSize &generatorSize,
                          std::function<void(QPainter *)> generateBrick,
                          QSize targetSize,
                          std::optional<QJsonObject> metadata = std::nullopt);
  static void generateContent(QPainter *painter, const int xPos, const int yPos,
                              const int xEndPos, const QString &content);

private:
  static void handleLine(QPainter *painter, QPointF start, const QPointF end,
                         QString &content);
  static void handleLineSegment(QPainter *painter, QPointF &start,
                                const QPointF end, QString &content);
};