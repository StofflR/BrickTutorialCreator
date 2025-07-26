#include "JSONGenerator.h"
#include "Brick.h"
#include "BrickUtility.h"
#include "DefaultBricks.h"
#include "DefaultColors.h"
#include "SettingsModel.h"

void JSONGenerator::saveJSON(QFile &file, const QJsonObject &jsonObject) {
  if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
    BrickUtility::updateStatusMessage(
        QString("Could not open file for writing: %1").arg(file.fileName()));
    return;
  }

  QJsonDocument jsonDoc(jsonObject);
  file.write(jsonDoc.toJson(QJsonDocument::Indented));
  file.close();
}

QJsonObject JSONGenerator::createJSON(const QString &size, const QString &type,
                                      const QString &color,
                                      const QString &colorShade,
                                      const QString &colorBorder,
                                      const QString &colorText, double width,
                                      double xPos, double yPos,
                                      const QString &content) {
  QMetaEnum brickTypesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickTypeRoles>();
  QMetaEnum brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();
  QMetaEnum settingTypesEnum = QMetaEnum::fromType<SettingsModel::Settings>();

  QJsonObject jsonObject;
  jsonObject[brickTypesEnum.valueToKey(DefaultBricks::BrickTypeRoles::Size)] =
      size;
  jsonObject[brickTypesEnum.valueToKey(DefaultBricks::BrickTypeRoles::Type)] =
      type;

  jsonObject[brickColorRolesEnum.valueToKey(
      DefaultBricks::BrickColorRoles::Color)] = color;
  jsonObject[brickColorRolesEnum.valueToKey(
      DefaultBricks::BrickColorRoles::Shade)] = colorShade;
  jsonObject[brickColorRolesEnum.valueToKey(
      DefaultBricks::BrickColorRoles::Border)] = colorBorder;
  jsonObject[brickColorRolesEnum.valueToKey(
      DefaultBricks::BrickColorRoles::Text)] = colorText;

  jsonObject[settingTypesEnum.valueToKey(SettingsModel::Settings::Width)] =
      width;

  jsonObject["X"] = xPos;
  jsonObject["Y"] = yPos;
  jsonObject["Content"] = content;

  return jsonObject;
}

bool JSONGenerator::readJSON(const QJsonObject &jsonObject, QString &size,
                             QString &type, QString &color, QString &colorShade,
                             QString &colorBorder, QString &colorText,
                             int &width, double &xPos, double &yPos,
                             QString &content) {
  QMetaEnum brickTypesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickTypeRoles>();
  QMetaEnum brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();
  QMetaEnum settingTypesEnum = QMetaEnum::fromType<SettingsModel::Settings>();

  // check if all required keys are present
  QStringList requiredKeys = {
      brickTypesEnum.valueToKey(DefaultBricks::BrickTypeRoles::Size),
      brickTypesEnum.valueToKey(DefaultBricks::BrickTypeRoles::Type),
      brickColorRolesEnum.valueToKey(DefaultBricks::BrickColorRoles::Color),
      brickColorRolesEnum.valueToKey(DefaultBricks::BrickColorRoles::Shade),
      brickColorRolesEnum.valueToKey(DefaultBricks::BrickColorRoles::Border),
      brickColorRolesEnum.valueToKey(DefaultBricks::BrickColorRoles::Text),
      settingTypesEnum.valueToKey(SettingsModel::Settings::Width),
      "X",
      "Y",
      "Content"};

  for (const QString &key : requiredKeys) {
    if (!jsonObject.contains(key)) {
      BrickUtility::updateStatusMessage(
          QString("JSON object is missing required key: %1").arg(key));
      return false;
    }
  }

  size =
      jsonObject[brickTypesEnum.valueToKey(DefaultBricks::BrickTypeRoles::Size)]
          .toString();
  type =
      jsonObject[brickTypesEnum.valueToKey(DefaultBricks::BrickTypeRoles::Type)]
          .toString();

  color = jsonObject[brickColorRolesEnum.valueToKey(
                         DefaultBricks::BrickColorRoles::Color)]
              .toString();
  colorShade = jsonObject[brickColorRolesEnum.valueToKey(
                              DefaultBricks::BrickColorRoles::Shade)]
                   .toString();
  colorBorder = jsonObject[brickColorRolesEnum.valueToKey(
                               DefaultBricks::BrickColorRoles::Border)]
                    .toString();
  colorText = jsonObject[brickColorRolesEnum.valueToKey(
                             DefaultBricks::BrickColorRoles::Text)]
                  .toString();

  width =
      jsonObject[settingTypesEnum.valueToKey(SettingsModel::Settings::Width)]
          .toInteger();

  xPos = jsonObject["X"].toDouble();
  yPos = jsonObject["Y"].toDouble();
  content = jsonObject["Content"].toString();
  return true;
}