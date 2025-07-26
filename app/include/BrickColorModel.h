#pragma once

#include <QAbstractListModel>
#include <QColor>
#include <QObject>
#include <QQmlEngine>
#include <QVariantList>
#include <map>
#include <string>
#include <vector>

class BrickColorModel : public QAbstractListModel {
  Q_OBJECT
  QML_ELEMENT

public:
  enum ColorRoles {
    NameRole = Qt::UserRole + 1,
    BorderRole,
    FillRole,
    ShadeRole,
    TextRole,
    EditableRole
  };

  explicit BrickColorModel(QObject *parent = nullptr);
  virtual ~BrickColorModel() = default;
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void addColor(const QString &name, const QColor border,
                            const QColor fill, const QColor shade,
                            const QColor text);
  Q_INVOKABLE void addCustomColor();
  Q_INVOKABLE void removeColor(size_t index);
  Q_INVOKABLE int setColors(const QString &fill, const QString &shade,
                            const QString &border, const QString &text);
  Q_INVOKABLE void renameColor(size_t index, const QString &newName);

private:
  QVariantMap _colors;
  size_t _standardColorsCount = 0;
  QStringList _originalColorNames;
};
