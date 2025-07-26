#include "DefaultBricks.h"
#include "DefaultColors.h"

namespace {
static QString toShade(QString colorName) { return colorName + "Shade"; }
static QString toBorder(QString colorName) { return colorName + "Border"; }
static QString toText(QString colorName) { return colorName + "Text"; }
} // namespace

DefaultBricks::DefaultBricks(QObject *parent) : QObject(parent) {}

const QVariantList DefaultBricks::brickTypes() {
  QMetaEnum brickTypesEnum = QMetaEnum::fromType<BrickTypes>();
  QVariantList result;
  for (int i = 0; i < brickTypesEnum.keyCount(); ++i) {
    result.append(brickTypesEnum.key(i));
  }
  return result;
}

const QVariantList DefaultBricks::brickSizes() {
  QMetaEnum brickSizesEnum = QMetaEnum::fromType<BrickSizes>();
  QVariantList result;
  for (int i = 0; i < brickSizesEnum.keyCount(); ++i) {
    result.append(brickSizesEnum.key(i));
  }
  return result;
}

const QVariantMap DefaultBricks::sizeSchemes() {
  const auto brickSizesEnum = QMetaEnum::fromType<BrickSizes>();
  const auto brickTypesEnum = QMetaEnum::fromType<BrickTypes>();
  const auto brickTypeRolesEnum = QMetaEnum::fromType<BrickTypeRoles>();

  QVariantMap result;

  const QString size = brickTypeRolesEnum.key(BrickTypeRoles::Size);
  const QString type = brickTypeRolesEnum.key(BrickTypeRoles::Type);

  for (auto i = 0; i < brickSizesEnum.keyCount(); i++) {
    const QString key = brickSizesEnum.key(i);
    if (brickSizesEnum.value(i) != BrickSizes::H0) {
      result.insert(
          key,
          QVariantMap{{size, key},
                      {type, brickTypesEnum.valueToKey(BrickTypes::Base)}});

      const QString controlKey =
          key + " - " + brickTypesEnum.valueToKey(BrickTypes::Control);

      if (brickSizesEnum.value(i) != BrickSizes::H3) {
        result.insert(controlKey,
                      QVariantMap{{size, key},
                                  {type, brickTypesEnum.valueToKey(
                                             BrickTypes::Control)}});
      }
    } else {
      const QString collapsedKey =
          key + " - " + brickTypesEnum.valueToKey(BrickTypes::Collapsed);
      result.insert(collapsedKey,
                    QVariantMap{{size, key},
                                {type, brickTypesEnum.valueToKey(
                                           BrickTypes::Collapsed)}});
    }
  }
  return result;
}

const QVariantMap DefaultBricks::colorSchemes() {
  const auto defaultColorsEnum = QMetaEnum::fromType<DefaultBrickColors>();
  const auto brickColorRolesEnum = QMetaEnum::fromType<BrickColorRoles>();

  QVariantMap result;
  const DefaultColors colors;

  const QString color = brickColorRolesEnum.key(BrickColorRoles::Color);
  const QString shade = brickColorRolesEnum.key(BrickColorRoles::Shade);
  const QString border = brickColorRolesEnum.key(BrickColorRoles::Border);
  const QString text = brickColorRolesEnum.key(BrickColorRoles::Text);

  for (auto i = 0; i < defaultColorsEnum.keyCount(); ++i) {
    QString value = defaultColorsEnum.key(i);

    if (value.length() == 0)
      continue;

    value = value.first(1).toLower() + value.sliced(1);
    result.insert(
        value,
        QVariantMap{
            {color, colors.property(value.toStdString().c_str())},
            {shade, colors.property(toShade(value).toStdString().c_str())},
            {border, colors.property(toBorder(value).toStdString().c_str())},
            {text, colors.property(toText(value).toStdString().c_str())}});
  }
  return result;
}