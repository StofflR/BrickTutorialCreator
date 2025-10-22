#include "BrickLoader.h"
#include "BrickGenerator.h"
#include "BrickUtility.h"
#include "JSONGenerator.h"

BrickLoader::BrickLoader(QObject *parent) : QObject(parent) {}

QJsonObject BrickLoader::loadJSONObjectFromFile(QFile &file)
{
  QJsonObject result;
  auto data = file.readAll();

  if (data.isEmpty())
  {
    BrickUtility::updateStatusMessage(
        QString("File is empty: %1").arg(file.fileName()));
    return {};
  }

  if (file.fileName().endsWith(utility::svgSuffix, Qt::CaseInsensitive))
  {
    result = loadFromSVG(data);
  }
  else if (file.fileName().endsWith(utility::jsonSuffix,
                                    Qt::CaseInsensitive))
  {
    result = loadFromJSON(data);
  }
  else if (file.fileName().endsWith(utility::pngSuffix,
                                    Qt::CaseInsensitive))
  {
    result = loadFromPNG(data);
  }
  else
  {
    BrickUtility::updateStatusMessage(
        QString("Unsupported file type: %1").arg(file.fileName()));
  }
  return result;
}

void BrickLoader::loadFile(const QUrl &filePath)
{
  QFile file(filePath.toLocalFile());
  if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
  {
    BrickUtility::updateStatusMessage(
        QString("Could not open file: %1").arg(filePath.toString()));
    return;
  }
  auto jsonData = loadJSONObjectFromFile(file);
  file.close();

  QString _size, _type, _color, _shade, _border, _textColor, _content;
  int _width = 0;
  double _xPos = 0.0, _yPos = 0.0;
  if (!JSONGenerator::readJSON(jsonData, _size, _type, _color, _shade,
                               _border, _textColor, _width, _xPos, _yPos,
                               _content))
    return;
  emit fileLoaded(_content, _type, _size, _color, _shade, _border, _textColor);
  emit positionLoaded(_xPos, _yPos);
  emit widthLoaded(_width);
  BrickUtility::updateStatusMessage("File loaded successfully.");
  return;
}

QJsonObject BrickLoader::loadJSONDocument(const QByteArray &data)
{
  auto document = QJsonDocument::fromJson(data);
  if (document.isNull() || !document.isObject())
  {
    BrickUtility::updateStatusMessage("Invalid JSON format.");
    return {};
  }
  return document.object();
}

QJsonObject BrickLoader::loadFromPNG(const QByteArray &data)
{
  QImage image;
  if (!image.loadFromData(data, "PNG"))
  {
    BrickUtility::updateStatusMessage("Failed to load image from data.");
    return {};
  }
  if (image.isNull())
  {
    BrickUtility::updateStatusMessage(
        QString("Failed to load image from data."));
    return {};
  }
  QString metadata = image.text("metadata");
  if (metadata.isEmpty())
  {
    BrickUtility::updateStatusMessage(
        QString("No metadata found in PNG image."));
    return {};
  }
  return BrickLoader::loadJSONDocument(metadata.toUtf8());
}

QJsonObject BrickLoader::loadFromSVG(const QByteArray &data)
{
  if (data.isEmpty())
  {
    return {};
  }
  // read <desc> tag for metadata
  QString svgContent = QString::fromUtf8(data);
  QRegularExpression descTag(QRegularExpression::escape("<desc>") + "(.*)" +
                                 QRegularExpression::escape("</desc>"),
                             QRegularExpression::DotMatchesEverythingOption);
  if (auto match = descTag.match(svgContent); match.hasMatch())
  {
    QTextDocument textDoc;
    textDoc.setHtml(match.captured(1));
    return BrickLoader::loadJSONDocument(textDoc.toPlainText().toUtf8());
  }
  else
  {
    BrickUtility::updateStatusMessage(
        QString("No metadata found in SVG image."));
    return {};
  }
}

QJsonObject BrickLoader::loadFromJSON(const QByteArray &data)
{
  return BrickLoader::loadJSONDocument(data);
}