#include "BrickLoader.h"
#include "BrickGenerator.h"
#include "BrickUtility.h"
#include "JSONGenerator.h"

BrickLoader::BrickLoader(QObject *parent) : QObject(parent) {}

void BrickLoader::loadFile(const QUrl &filePath) {
  QFile file(filePath.toLocalFile());
  if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    BrickUtility::updateStatusMessage(
        QString("Could not open file: %1").arg(filePath.toString()));
    return;
  }
  if (filePath.toString().endsWith(utility::svgSuffix, Qt::CaseInsensitive)) {
    loadFromSVG(&file);
  } else if (filePath.toString().endsWith(utility::jsonSuffix,
                                          Qt::CaseInsensitive)) {
    loadFromJSON(&file);
  } else if (filePath.toString().endsWith(utility::pngSuffix,
                                          Qt::CaseInsensitive)) {
    loadFromPNG(&file);
  } else {
    BrickUtility::updateStatusMessage(
        QString("Unsupported file type: %1").arg(filePath.toString()));
  }
  file.close();
}

void BrickLoader::loadJSONDocument(const QByteArray &data) {
  auto document = QJsonDocument::fromJson(data);
  if (document.isNull() || !document.isObject()) {
    BrickUtility::updateStatusMessage("Invalid JSON format.");
    return;
  }
  QString _size, _type, _color, _shade, _border, _textColor, _content;
  int _width = 0;
  double _xPos = 0.0, _yPos = 0.0;

  if (!JSONGenerator::readJSON(document.object(), _size, _type, _color, _shade,
                               _border, _textColor, _width, _xPos, _yPos,
                               _content))
    return;

  emit fileLoaded(_content, _type, _size, _color, _shade, _border, _textColor);
  emit positionLoaded(_xPos, _yPos);
  emit widthLoaded(_width);
  BrickUtility::updateStatusMessage("File loaded successfully.");
}

void BrickLoader::loadFromPNG(QFile *file) {
  if (!file || !file->isOpen()) {
    BrickUtility::updateStatusMessage("Could not open file.");
    return;
  }
  QImage image(file->fileName(), "PNG");
  if (image.isNull()) {
    BrickUtility::updateStatusMessage(
        QString("Failed to load image: %1").arg(file->fileName()));
    return;
  }
  QString metadata = image.text("metadata");
  if (metadata.isEmpty()) {
    BrickUtility::updateStatusMessage(
        QString("No metadata found in: %1").arg(file->fileName()));
    return;
  }
  loadJSONDocument(metadata.toUtf8());
}

void BrickLoader::loadFromSVG(QFile *file) {
  if (!file || !file->isOpen()) {
    BrickUtility::updateStatusMessage("Could not open file.");
    return;
  }
  // read <desc> tag for metadata
  QString svgContent = QString::fromUtf8(file->readAll());
  QRegularExpression descTag(QRegularExpression::escape("<desc>") + "(.*)" +
                                 QRegularExpression::escape("</desc>"),
                             QRegularExpression::DotMatchesEverythingOption);
  if (auto match = descTag.match(svgContent); match.hasMatch()) {
    QTextDocument textDoc;
    textDoc.setHtml(match.captured(1));
    loadJSONDocument(textDoc.toPlainText().toUtf8());
  } else {
    BrickUtility::updateStatusMessage(
        QString("No metadata found in: %1").arg(file->fileName()));
  }
}

void BrickLoader::loadFromJSON(QFile *file) {
  if (!file || !file->isOpen()) {
    BrickUtility::updateStatusMessage("Could not open file.");
    return;
  }
  loadJSONDocument(file->readAll());
}