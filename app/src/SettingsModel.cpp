#include "SettingsModel.h"

namespace {
static SettingsModel::Settings toSetting(const QString &roleName) {
  const auto settingsRolesEnum = QMetaEnum::fromType<SettingsModel::Settings>();
  return static_cast<SettingsModel::Settings>(
      settingsRolesEnum.keyToValue(roleName.toUtf8()));
}

static QString fromValue(size_t value) {
  const auto settingsRolesEnum = QMetaEnum::fromType<SettingsModel::Settings>();
  return settingsRolesEnum.valueToKey(static_cast<int>(value));
}

static bool isValidType(const QVariant &value,
                        SettingsModel::SettingType type) {
  switch (type) {
  case SettingsModel::SettingType::Boolean:
    return value.typeId() == QMetaType::Bool;
  case SettingsModel::SettingType::String:
    return value.typeId() == QMetaType::QString;
  case SettingsModel::SettingType::Integer:
    return value.typeId() == QMetaType::Int;
  case SettingsModel::SettingType::FolderDialog:
    return value.typeId() == QMetaType::QString;
  case SettingsModel::SettingType::FileDialog:
    return value.typeId() == QMetaType::QString ||
           value.typeId() == QMetaType::QUrl;
  }
  Q_UNREACHABLE();
}
static QVariant sanitize(const QVariant &value) {
  if (value.typeId() == QMetaType::QUrl) {
    return value.toUrl().toLocalFile();
  }
  return value;
}
} // namespace

SettingsModel::SettingsModel(QObject *parent) : QAbstractListModel(parent) {
  const auto settingsRolesEnum = QMetaEnum::fromType<SettingsModel::Settings>();

  for (auto i = 0; i < settingsRolesEnum.keyCount(); ++i) {
    const QString key = settingsRolesEnum.key(i);
    _settings.insert(key, _defaultValues.value(toSetting(key)));
  }
}

bool SettingsModel::setValue(const QString &_name, const QVariant &value) {
  const auto name = QString{_name}.replace(' ', '_');
  auto row = toSetting(name);
  if (!_settings.contains(name) &&
      isValidType(value, _settingTypes.value(row))) {
    return false;
  }
  _settings.insert(name, sanitize(value));

  dataChanged(index(row), index(row), {ValueRole});
  emit settingsChanged();
  return true;
}

int SettingsModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent)
  return _settings.size();
}

QVariant SettingsModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= _settings.size()) {
    return QVariant();
  }

  auto key = fromValue(index.row());

  switch (role) {
  case NameRole:
    return key.replace('_', ' ');
  case ValueRole:
    return _settings.value(key);
  case TypeRole:
    return _settingTypes.value(toSetting(key));
  case EnabledRole:
    return true;
  }

  return QVariant();
}

bool SettingsModel::setData(const QModelIndex &index, const QVariant &value,
                            int role) {
  Q_UNUSED(role);
  if (!index.isValid() || index.row() >= _settings.size()) {
    return false;
  }

  auto key = fromValue(index.row());

  return setValue(key, value);
}

QString SettingsModel::name() const {
  return _settings.value(fromValue(Settings::Name)).toString();
}
bool SettingsModel::autoSave() const {
  return _settings.value(fromValue(Settings::AutoSave)).toBool();
}
bool SettingsModel::exportSVG() const {
  return _settings.value(fromValue(Settings::Export_SVG)).toBool();
}
bool SettingsModel::exportPNG() const {
  return _settings.value(fromValue(Settings::Export_PNG)).toBool();
}
bool SettingsModel::exportJSON() const {
  return _settings.value(fromValue(Settings::Export_JSON)).toBool();
}
QString SettingsModel::exportPath() const {
  return _settings.value(fromValue(Settings::Export)).toString();
}
int SettingsModel::brickWidth() const {
  return _settings.value(fromValue(Settings::Width)).toInt();
}

void SettingsModel::loadWidth(const int width) {
  setValue(fromValue(Settings::Width), width);
}

QHash<int, QByteArray> SettingsModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[NameRole] = "settingName";
  roles[ValueRole] = "settingValue";
  roles[TypeRole] = "settingType";
  roles[EnabledRole] = "enabled";
  return roles;
}