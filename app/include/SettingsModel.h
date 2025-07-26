#pragma once

#include <QAbstractListModel>
#include <QColor>
#include <QObject>
#include <QQmlEngine>
#include <QStandardPaths>
#include <QVariantList>
#include <map>
#include <string>
#include <vector>

class SettingsModel : public QAbstractListModel {
  Q_OBJECT
  QML_ELEMENT

  Q_PROPERTY(QString name READ name NOTIFY settingsChanged)
  Q_PROPERTY(bool autoSave READ autoSave NOTIFY settingsChanged)
  Q_PROPERTY(bool exportSVG READ exportSVG NOTIFY settingsChanged)
  Q_PROPERTY(bool exportPNG READ exportPNG NOTIFY settingsChanged)
  Q_PROPERTY(bool exportJSON READ exportJSON NOTIFY settingsChanged)
  Q_PROPERTY(QString exportPath READ exportPath NOTIFY settingsChanged)
  Q_PROPERTY(int brickWidth READ brickWidth NOTIFY settingsChanged)

public:
  enum SettingsRoles {
    NameRole = Qt::UserRole + 1,
    ValueRole,
    TypeRole,
    EnabledRole
  };
  Q_ENUM(SettingsRoles)

  enum Settings {
    Name,
    AutoSave,
    Export_SVG,
    Export_PNG,
    Export_JSON,
    Export,
    Width
  };
  Q_ENUM(Settings)

  enum SettingType { Boolean, String, Integer, FolderDialog, FileDialog };
  Q_ENUM(SettingType)

  explicit SettingsModel(QObject *parent = nullptr);
  virtual ~SettingsModel() = default;
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  bool setData(const QModelIndex &index, const QVariant &value,
               int role = Qt::EditRole) override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void loadWidth(const int width);

signals:
  void settingsChanged();

private:
  bool setValue(const QString &name, const QVariant &value);

  QString name() const;
  bool autoSave() const;
  bool exportSVG() const;
  bool exportPNG() const;
  bool exportJSON() const;
  QString exportPath() const;
  int brickWidth() const;

  QVariantMap _settings;
  const QMap<Settings, SettingType> _settingTypes = {
      {Settings::Name, SettingType::String},
      {Settings::AutoSave, SettingType::Boolean},
      {Settings::Export_SVG, SettingType::Boolean},
      {Settings::Export_PNG, SettingType::Boolean},
      {Settings::Export_JSON, SettingType::Boolean},
      {Settings::Export, SettingType::FolderDialog},
      {Settings::Width, SettingType::Integer},
  };
  const QMap<Settings, QVariant> _defaultValues = {
      {Settings::Name, "simple_brick"},
      {Settings::AutoSave, false},
      {Settings::Export_SVG, true},
      {Settings::Export_PNG, false},
      {Settings::Export_JSON, false},
      {Settings::Export, QUrl::fromLocalFile(QStandardPaths::writableLocation(
                             QStandardPaths::DocumentsLocation))},
      {Settings::Width, 1920},
  };
};
