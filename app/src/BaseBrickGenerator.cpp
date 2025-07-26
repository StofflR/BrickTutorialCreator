#include "BaseBrickGenerator.h"
#include "BrickUtility.h"
#include <QDir>
#include <QFile>

QUrl BaseBrickGenerator::generateBaseBrick(
    const QString &type, const QString &size, const QString &color,
    const QString &colorShade, const QString &colorBorder, QDir targetDir) {
  QString baseSVG = QString("%1_%2" + utility::svgSuffix)
                        .arg(size.toLower())
                        .arg(type.toLower());

  QString targetSVG = QString("%1_%2_%3" + utility::svgSuffix)
                          .arg(color.toLower())
                          .arg(size.toLower())
                          .arg(type.toLower());

  QFile targetFile = QFile(targetDir.filePath(targetSVG));

  QFile baseFile(":/app/resources/" + baseSVG);

  if (!baseFile.exists()) {
    BrickUtility::updateStatusMessage(
        QString("Base brick SVG file does not exist: %1").arg(baseSVG));
    return QUrl();
  }
  if (!baseFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
    BrickUtility::updateStatusMessage(
        QString("Could not open base brick SVG file: %1").arg(baseSVG));
    return QUrl();
  }

  QString svgContent = QString::fromUtf8(baseFile.readAll());
  baseFile.close();
  svgContent.replace("#BACKGROUND", color);
  svgContent.replace("#BORDER", colorBorder);
  svgContent.replace("#SHADE", colorShade);

  if (!targetDir.exists()) {
    targetDir.mkpath(".");
  }
  if (!targetFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
    BrickUtility::updateStatusMessage(
        QString("Could not open target brick SVG file for writing: %1")
            .arg(targetFile.fileName()));
    return QUrl();
  }
  targetFile.write(svgContent.toUtf8());
  targetFile.close();

  return QUrl::fromLocalFile(targetFile.fileName());
}