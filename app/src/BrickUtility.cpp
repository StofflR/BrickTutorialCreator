#include "BrickUtility.h"
#include "BaseBrickGenerator.h"
#include "Brick.h"
#include "DefaultBricks.h"
#include "DefaultColors.h"
#include "StatusHandler.h"
#include <QDir>
#include <QThreadPool>
#include <QtConcurrent>

namespace {
/*
drawable_dpis["mdpi"] = {"width": 56, "1h": 46, "2h": 73, "3h": 96}
drawable_dpis["hdpi"] = {"width": 83, "1h": 66, "2h": 109, "3h": 143}
drawable_dpis["xhdpi"] = {"width": 111, "1h": 90, "2h": 144, "3h": 190}
drawable_dpis["ldpi"] = {"width": 43, "1h": 35, "2h": 55, "3h": 73}
drawable_dpis["xxhdpi"] = {"width": 164, "1h": 134, "2h": 216, "3h": 284}
*/
static QMap<QString, QMap<QString, int>> drawable_dpi_height = {
    {"H1",
     {{"mdpi", 46},
      {"hdpi", 66},
      {"xhdpi", 90},
      {"ldpi", 35},
      {"xxhdpi", 134}}},
    {"H2",
     {{"mdpi", 73},
      {"hdpi", 109},
      {"xhdpi", 144},
      {"ldpi", 55},
      {"xxhdpi", 216}}},
    {"H3",
     {{"mdpi", 96},
      {"hdpi", 143},
      {"xhdpi", 190},
      {"ldpi", 73},
      {"xxhdpi", 284}}}};

static QMap<QString, int> drawable_dpi_width = {
    {"mdpi", 56}, {"hdpi", 83}, {"xhdpi", 111}, {"ldpi", 43}, {"xxhdpi", 164}};

static void generateAllBricks(
    std::function<void(const QString &, const QString &, const QString &,
                       const QString &, const QString &, const QString &,
                       const QString &)>
        generate) {
  const auto sizeSchemes = DefaultBricks::sizeSchemes();
  const auto colorSchemes = DefaultBricks::colorSchemes();

  const auto brickTypeRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickTypeRoles>();
  const auto size = brickTypeRolesEnum.key(DefaultBricks::BrickTypeRoles::Size);
  const auto type = brickTypeRolesEnum.key(DefaultBricks::BrickTypeRoles::Type);

  size_t count = 0;

  QMetaEnum brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();
  const auto color =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Color);
  const auto shade =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Shade);
  const auto border =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Border);
  const auto text =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Text);

  for (const auto &sizeTypeKey : sizeSchemes.keys()) {
    const auto sizeTypeMap = sizeSchemes.value(sizeTypeKey).toMap();

    for (const auto &colorName : colorSchemes.keys()) {
      const auto colorMap = colorSchemes[colorName].toMap();

      generate(colorName, sizeTypeMap.value(type).toString(),
               sizeTypeMap.value(size).toString(), colorMap[color].toString(),
               colorMap[shade].toString(), colorMap[border].toString(),
               colorMap[text].toString());

      BrickUtility::updateStatusMessage(
          QString("Generated %1 bricks.").arg(++count));
    }
  }
}

void generateBasicBricksImpl(const QUrl &folderPath) {
  QDir dir(folderPath.toLocalFile());
  if (!dir.exists()) {
    BrickUtility::updateStatusMessage("The specified folder does not exist.");
    return;
  }

  generateAllBricks([&](const QString &colorName, const QString &type,
                        const QString &size, const QString &color,
                        const QString &colorShade, const QString &colorBorder,
                        const QString &) {
    auto baseBrick = BaseBrickGenerator::generateBaseBrick(
        type, size, color, colorShade, colorBorder, dir);

    if (baseBrick.isEmpty()) {
      qWarning() << "Failed to generate base brick for"
                 << colorName + "_" + type + "_" + size;
      return;
    }
    QSvgRenderer svgRenderer(baseBrick.toLocalFile());
    auto brickSize = svgRenderer.viewBox().size();
    brickSize.scale(1920, 1080, Qt::KeepAspectRatio);

    QImage image(brickSize, QImage::Format_ARGB32);
    image.fill(Qt::transparent);

    QPainter painter(&image);
    svgRenderer.render(&painter);
    painter.end();

    if (!image.save(dir.filePath(colorName + "_" + type + "_" + size + ".png"),
                    "PNG")) {
      qWarning() << "Failed to save PNG:"
                 << dir.filePath(colorName + "_" + type + "_" + size + ".png");
    }
  });
}
void generateDrawableBricksImpl(const QUrl &folderPath) {
  QDir dir(folderPath.toLocalFile());
  if (!dir.exists()) {
    BrickUtility::updateStatusMessage("The specified folder does not exist.");
    return;
  }

  generateAllBricks([&](const QString &colorName, const QString &type,
                        const QString &size, const QString &color,
                        const QString &colorShade, const QString &colorBorder,
                        const QString &) {
    auto baseBrick = BaseBrickGenerator::generateBaseBrick(
        type, size, color, colorShade, colorBorder, dir);

    if (baseBrick.isEmpty()) {
      qWarning() << "Failed to generate base brick for"
                 << colorName + "_" + type + "_" + size;
      return;
    }
    QSvgRenderer svgRenderer(baseBrick.toLocalFile());
    auto brickSize = svgRenderer.viewBox().size();
    brickSize.scale(1920, 1080, Qt::KeepAspectRatio);

    QImage image(brickSize, QImage::Format_ARGB32);
    image.fill(Qt::transparent);

    QPainter painter(&image);
    svgRenderer.render(&painter);
    painter.end();

    if (!drawable_dpi_height.contains(size))
      return;

    auto dpiHeights = drawable_dpi_height.value(size);

    for (const auto &dpiKey : dpiHeights.keys()) {
      int height = dpiHeights.value(dpiKey);
      int width = drawable_dpi_width.value(dpiKey);

      if (type == "Control")
        width = static_cast<int>(width * 2.5);

      QSize targetSize(image.width() *
                           (image.height() / static_cast<double>(height)),
                       height);
      QImage scaledImage = image.scaled(targetSize, Qt::KeepAspectRatio,
                                        Qt::SmoothTransformation);

      QDir dpiDir(dir.filePath("drawable-" + dpiKey));
      if (!dpiDir.exists()) {
        dpiDir.mkpath(".");
      }

      scaledImage = scaledImage.copy(QRect(0, 0, width, height));
      if (!scaledImage.save(
              dpiDir.filePath(colorName + "_" + type + "_" + size + ".9.png"),
              "PNG")) {
        qWarning() << "Failed to save PNG:"
                   << dir.filePath(colorName + "_" + type + "_" + size +
                                   ".9.png");
      }
    }
  });
}
void generateReferenceBricksImpl(const QUrl &folderPath, const QFont &font) {
  QDir dir(folderPath.toLocalFile());

  if (!dir.exists()) {
    BrickUtility::updateStatusMessage("The specified folder does not exist.");
    return;
  }

  QDir referenceDir("../resources/ref_all_bricks");

  if (!referenceDir.exists()) {
    BrickUtility::updateStatusMessage(
        "The reference directory does not exist.");
    return;
  }

  size_t count = 0;
  // collect paths to all json files, recursive
  auto allReferenceDirs = referenceDir.entryList(
      QStringList(),
      QDir::Dirs | QDir::NoSymLinks | QDir::NoDotAndDotDot | QDir::AllDirs,
      QDir::Name);

  for (const auto &subDir : allReferenceDirs) {

    QDir jsonDir(referenceDir.filePath(subDir));
    auto jsonFiles = jsonDir.entryList(
        QStringList() << "*.json",
        QDir::Files | QDir::NoSymLinks | QDir::NoDotAndDotDot, QDir::Name);

    for (auto &file : jsonFiles) {
      QFile jsonFile(jsonDir.filePath(file));

      if (!jsonFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open JSON file:" << jsonFile.fileName();
        continue;
      }

      auto document = QJsonDocument::fromJson(jsonFile.readAll());

      if (document.isNull() || !document.isObject()) {
        qWarning() << "Invalid JSON format in file:" << jsonFile.fileName();
        continue;
      }

      auto brick =
          Brick(document.object(), file.replace(utility::jsonSuffix, ""),
                dir.path(), font);

      brick.saveSVG();

      qInfo() << "Generated SVG for" << jsonFile.fileName();
      BrickUtility::updateStatusMessage(
          QString("Generated reference brick (%2) from %1")
              .arg(jsonFile.fileName())
              .arg(++count));
    }
  }
}
} // namespace

void BrickUtility::updateStatusMessage(const QString &message) {
  auto *statusHandler = StatusHandlerProvider::getInstance();
  if (statusHandler) {
    statusHandler->setStatusMessage(message);
  }
}

void BrickUtility::generateBasicBricks(const QUrl &folderPath) {
  auto promise =
      QtConcurrent::run(QThreadPool::globalInstance(), [folderPath]() {
        generateBasicBricksImpl(folderPath);
      });
  if (!promise.isValid()) {
    updateStatusMessage("Failed to start brick generation task.");
    return;
  }
}
void BrickUtility::generateDrawableBricks(const QUrl &folderPath) {
  auto promise =
      QtConcurrent::run(QThreadPool::globalInstance(), [folderPath]() {
        generateDrawableBricksImpl(folderPath);
      });
  if (!promise.isValid()) {
    updateStatusMessage("Failed to start brick generation task.");
    return;
  }
}

void BrickUtility::generateReferenceBricks(const QUrl &folderPath,
                                           const QFont &font) {
  auto promise =
      QtConcurrent::run(QThreadPool::globalInstance(), [folderPath, font]() {
        generateReferenceBricksImpl(folderPath, font);
      });
  if (!promise.isValid()) {
    updateStatusMessage("Failed to start brick generation task.");
    return;
  }
}