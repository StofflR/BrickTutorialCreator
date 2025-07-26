#include "BrickColorModel.h"
#include "BrickUtility.h"
#include "DefaultBricks.h"

BrickColorModel::BrickColorModel(QObject *parent) : QAbstractListModel(parent) {
  _colors = DefaultBricks::colorSchemes();
  _standardColorsCount = _colors.size();
  _originalColorNames = _colors.keys();
}

int BrickColorModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent)
  return _colors.size();
}

QVariant BrickColorModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= _colors.size()) {
    return QVariant();
  }

  auto toHex = [](const QColor &color) { return color.name(); };

  const QVariantMap &colorData =
      _colors.value(_colors.keys().at(index.row())).toMap();

  const auto brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();

  const QString color =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Color);
  const QString shade =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Shade);
  const QString border =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Border);
  const QString text =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Text);

  switch (role) {
  case NameRole:
    return _colors.keys().at(index.row());
  case BorderRole:
    return toHex(colorData.value(border).value<QColor>());
  case FillRole:
    return toHex(colorData.value(color).value<QColor>());
  case ShadeRole:
    return toHex(colorData.value(shade).value<QColor>());
  case TextRole:
    return toHex(colorData.value(text).value<QColor>());
  case EditableRole:
    return !_originalColorNames.contains(_colors.keys().at(index.row()));

  default:
    return QVariant();
  }
}

QHash<int, QByteArray> BrickColorModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[NameRole] = "name";
  roles[BorderRole] = "borderColor";
  roles[FillRole] = "fillColor";
  roles[ShadeRole] = "shadeColor";
  roles[TextRole] = "textColor";
  roles[EditableRole] = "editable";
  return roles;
}

void BrickColorModel::addCustomColor() {
  auto name = QString("Custom %1");
  size_t count = _colors.size() - _standardColorsCount + 1;
  while (_colors.contains(name.arg(count))) {
    count--;
  }
  addColor(name.arg(count), QColor("#000000"), QColor("#FFFFFF"),
           QColor("#FFFFFF"), QColor("#000000"));
}

void BrickColorModel::addColor(const QString &name, QColor border, QColor fill,
                               QColor shade, QColor text) {
  const auto brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();

  const QString colorKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Color);
  const QString shadeKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Shade);
  const QString borderKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Border);
  const QString textKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Text);

  beginResetModel();
  _colors.insert(name, QVariantMap{{borderKey, border},
                                   {colorKey, fill},
                                   {shadeKey, shade},
                                   {textKey, text}});
  endResetModel();
}

void BrickColorModel::renameColor(size_t index, const QString &newName) {
  auto oldColorName = _colors.keys().at(index);
  if (newName == oldColorName) {
    return;
  }
  auto colorData = _colors.value(oldColorName).toMap();

  removeColor(index);
  const auto brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();

  const QString colorKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Color);
  const QString shadeKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Shade);
  const QString borderKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Border);
  const QString textKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Text);
  addColor(newName, colorData.value(borderKey).value<QColor>(),
           colorData.value(colorKey).value<QColor>(),
           colorData.value(shadeKey).value<QColor>(),
           colorData.value(textKey).value<QColor>());
}

void BrickColorModel::removeColor(size_t index) {
  auto colorName = _colors.keys().at(index);
  if (_originalColorNames.contains(colorName) ||
      index >= static_cast<size_t>(_colors.size())) {
    BrickUtility::updateStatusMessage(
        QString("Cannot remove standard color at index: %1").arg(index));
    return;
  }

  beginRemoveRows(QModelIndex(), index, index);
  _colors.remove(_colors.keys().at(index));
  endRemoveRows();
}

int BrickColorModel::setColors(const QString &fill, const QString &shade,
                               const QString &border, const QString &text) {
  const auto brickColorRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickColorRoles>();

  const QString colorKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Color);
  const QString shadeKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Shade);
  const QString borderKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Border);
  const QString textKey =
      brickColorRolesEnum.key(DefaultBricks::BrickColorRoles::Text);

  for (auto i = 0; i < _colors.size(); ++i) {
    const QVariantMap &colorData = _colors.value(_colors.keys().at(i)).toMap();
    if (colorData.value(colorKey).toString() == fill &&
        colorData.value(shadeKey).toString() == shade &&
        colorData.value(borderKey).toString() == border &&
        colorData.value(textKey).toString() == text) {
      return i;
    }
  }
  auto newColorName =
      QString("Custom %1").arg(_colors.size() - _standardColorsCount + 1);
  BrickUtility::updateStatusMessage(
      QString("Color combination not found, adding new color: %1")
          .arg(newColorName));
  addColor(newColorName, QColor(border), QColor(fill), QColor(shade),
           QColor(text));
  return _colors.size();
}