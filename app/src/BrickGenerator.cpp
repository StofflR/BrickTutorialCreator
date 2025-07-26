#include "BrickGenerator.h"
#include "BaseBrickGenerator.h"
#include "BrickUtility.h"
#include <QSvgGenerator>
#include <QSvgRenderer>

void BrickGenerator::generateSVG(QFile &file, const QSize &generatorSize,
                                 std::function<void(QPainter *)> generateBrick,
                                 std::optional<QJsonObject> metadata) {
  QSvgGenerator svgGenerator;
  svgGenerator.setOutputDevice(&file);
  svgGenerator.setSize(generatorSize);

  if (metadata.has_value()) {
    const QJsonObject &meta = metadata.value();
    QJsonDocument doc(meta);
    svgGenerator.setDescription(QString::fromUtf8(doc.toJson()));
  }

  svgGenerator.setViewBox(
      QRect(0, 0, generatorSize.width(), generatorSize.height()));
  svgGenerator.setResolution(96.0); // Standard DPI
  QPainter filePainter(&svgGenerator);
  generateBrick(&filePainter);
}

QImage
BrickGenerator::generateImage(const QSize &generatorSize, QSize targetSize,
                              std::function<void(QPainter *)> generateBrick) {
  QImage image(generatorSize, QImage::Format_ARGB32);
  image.fill(Qt::transparent);
  QPainter imagePainter(&image);
  generateBrick(&imagePainter);
  return image.scaled(targetSize, Qt::AspectRatioMode::KeepAspectRatio,
                      Qt::TransformationMode::SmoothTransformation);
}

void BrickGenerator::generatePNG(QFile &file, const QSize &generatorSize,
                                 std::function<void(QPainter *)> generateBrick,
                                 QSize targetSize,
                                 std::optional<QJsonObject> metadata) {
  QImage image = generateImage(generatorSize, targetSize, generateBrick);
  if (metadata.has_value()) {
    const QJsonObject &meta = metadata.value();
    QJsonDocument doc(meta);
    image.setText("metadata", QString::fromUtf8(doc.toJson()));
  }

  image.save(&file, "PNG");
}

void BrickGenerator::generateContent(QPainter *painter, const int xPos,
                                     const int yPos, const int xEndPos,
                                     const QString &content) {
  if (content.isEmpty() || !painter)
    return;
  auto lines = content.split('\n');
  for (auto index = 0; index < lines.size(); ++index) {
    auto line = lines.at(index);
    auto lineStartY =
        yPos + (index + 1) * painter->fontMetrics().capHeight() * 1.4;
    auto end =
        QPointF(xEndPos, lineStartY - painter->fontMetrics().capHeight());
    handleLine(painter, QPointF(xPos, lineStartY), end, line);
  }
}

void BrickGenerator::handleLine(QPainter *painter, QPointF start,
                                const QPointF end, QString &content) {
  if (!painter || content.isEmpty())
    return;
  auto text = content.section(constants::variableMarker, 0, 0);
  auto rest = content.section(constants::variableMarker, 1);

  handleLineSegment(painter, start, end, text);

  if (rest.isEmpty() || text == content)
    return;

  auto variable = rest.section(constants::variableMarker, 0, 0);
  rest = rest.section(constants::variableMarker, 1);
  if (variable.isEmpty())
    return;

  auto font = painter->font();

  painter->setFont(
      QFont(font.family(), font.pointSizeF(), QFont::Weight::Light));
  QPointF newStart(start.x() +
                       painter->fontMetrics().horizontalAdvance(variable),
                   start.y());
  painter->drawText(start, variable);
  painter->setFont(font);

  painter->setPen(QPen(painter->pen().color(),
                       painter->fontMetrics().lineSpacing() * 0.05,
                       Qt::PenStyle::SolidLine, Qt::PenCapStyle::FlatCap));

  painter->setTransform(
      QTransform::fromTranslate(0, painter->fontMetrics().lineSpacing() * 0.1),
      true);
  painter->drawLine(start, newStart);
  painter->resetTransform();

  handleLine(painter, newStart, end, rest);
}

void BrickGenerator::handleLineSegment(QPainter *painter, QPointF &start,
                                       const QPointF end, QString &content) {
  if (!painter || content.isEmpty())
    return;
  auto text = content.section(constants::dropMarker, 0, 0);
  auto rest = content.section(constants::dropMarker, 1);

  painter->drawText(start, text);
  start.setX(start.x() + painter->fontMetrics().horizontalAdvance(text));

  if (rest.isEmpty() || text == content)
    return;

  auto drop = rest.section(constants::dropMarker, 0, 0);
  rest = rest.section(constants::dropMarker, 1);
  if (drop.isEmpty())
    return;

  auto font = painter->font();
  painter->setFont(
      QFont(font.family(), font.pointSizeF() * 0.8, QFont::Weight::Light));
  painter->setTransform(
      QTransform::fromTranslate(0, painter->fontMetrics().lineSpacing() * 0.1),
      true);
  painter->drawText(start, drop);
  painter->resetTransform();
  start.setX(start.x() + painter->fontMetrics().horizontalAdvance(drop));
  painter->setFont(font);

  QPointF points[3] = {
      QPointF(end.x(), end.y()),
      QPointF(end.x() - painter->fontMetrics().descent() * 2, end.y()),
      QPointF(end.x() - (painter->fontMetrics().descent()),
              end.y() + painter->fontMetrics().descent())};
  painter->setBrush(painter->pen().color());
  painter->drawPolygon(points, 3);

  handleLineSegment(painter, start, end, rest);
}