#include "BrickSizeModel.h"
#include "BrickUtility.h"
#include "DefaultBricks.h"

BrickSizeModel::BrickSizeModel(QObject *parent)
    : QAbstractListModel(parent), _sizes(DefaultBricks::sizeSchemes()),
      _defaultIndex(DefaultBricks::BrickSizes::H1) {}

int BrickSizeModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent)
  return _sizes.size();
}

QVariant BrickSizeModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= _sizes.size()) {
    return QVariant();
  }
  const auto brickTypeRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickTypeRoles>();
  const QString size =
      brickTypeRolesEnum.key(DefaultBricks::BrickTypeRoles::Size);
  const QString type =
      brickTypeRolesEnum.key(DefaultBricks::BrickTypeRoles::Type);

  const QVariantMap &sizeData =
      _sizes.value(_sizes.keys().at(index.row())).toMap();
  switch (role) {
  case NameRole:
    return _sizes.keys().at(index.row());
  case SizeRole:
    return sizeData.value(size);
  case TypeRole:
    return sizeData.value(type);
  default:
    return QVariant();
  }
}

int BrickSizeModel::setTypeAndSize(const QString &type, const QString &size) {
  const auto brickTypeRolesEnum =
      QMetaEnum::fromType<DefaultBricks::BrickTypeRoles>();
  const QString sizeKey =
      brickTypeRolesEnum.key(DefaultBricks::BrickTypeRoles::Size);
  const QString typeKey =
      brickTypeRolesEnum.key(DefaultBricks::BrickTypeRoles::Type);

  for (int i = 0; i < _sizes.size(); i++) {
    const QVariantMap &sizeData = _sizes.value(_sizes.keys().at(i)).toMap();
    if (sizeData.value(typeKey).toString() == type &&
        sizeData.value(sizeKey).toString() == size) {
      return i;
    }
  }
  BrickUtility::updateStatusMessage(
      QString("No matching brick size found for type %1 and size %2")
          .arg(type)
          .arg(size));
  return _defaultIndex;
}

QHash<int, QByteArray> BrickSizeModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[NameRole] = "name";
  roles[SizeRole] = "size";
  roles[TypeRole] = "type";
  return roles;
}