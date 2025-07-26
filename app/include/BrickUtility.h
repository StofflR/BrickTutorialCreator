#pragma once

#include <QDir>
#include <QFile>
#include <QObject>
#include <QQmlEngine>
#include <QRandomGenerator>
#include <QStandardPaths>
#include <QString>
#include <map>

namespace utility {
static QString svgSuffix = ".svg";
static QString pngSuffix = ".png";
static QString jsonSuffix = ".json";
} // namespace utility

namespace constants {
static constexpr double baseDPI = 96.0;

static const double h0_height = 15.95;
static const double h1_height = 72.95;
static const double h2_height = 94.748;
static const double h3_height = 94.748;

static const double base_line_scale = 1.0 / (6.25 * h1_height);
static const double topTabOffset = 4.0;

static std::map<QString, double> blockStartMap = {
    {"H0", 0},
    {"H1", 22.5 + 3.0 - topTabOffset},
    {"H2", 22.5 + 4.0 - topTabOffset},
    {"H3", 22.5 - 10.0 - topTabOffset}};

static std::map<QString, std::pair<double, double>> sizeMap = {
    {"H0", {348.181, h0_height}},
    {"H1", {348.181, h1_height}},
    {"H2", {348.181, h2_height}},
    {"H3", {348.181, h3_height}}};

static std::map<QString, double> lineWidthMap = {
    {"H0", (base_line_scale * h0_height)},
    {"H1", (base_line_scale * h1_height)},
    {"H2", (base_line_scale * h1_height * (h1_height / h2_height))},
    {"H3", (base_line_scale * h1_height * ((h1_height * 0.8) / h3_height))}};

static QString variableMarker = "_";
static QString dropMarker = "|";
}; // namespace constants

/**
 * @brief Utility functions for QML components
 *
 * This class provides various utility functions that can be
 * accessed from QML components, including file operations,
 * string manipulation, and path handling.
 */
class BrickUtility : public QObject {
  Q_OBJECT
  QML_ELEMENT
public:
  static void updateStatusMessage(const QString &message);
  Q_INVOKABLE void generateBasicBricks(const QUrl &folderPath);
  Q_INVOKABLE void generateDrawableBricks(const QUrl &folderPath);
  Q_INVOKABLE void generateReferenceBricks(const QUrl &folderPath,
                                           const QFont &font);
};
