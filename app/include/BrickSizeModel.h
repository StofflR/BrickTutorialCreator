#pragma once

#include <QAbstractListModel>
#include <QColor>
#include <QObject>
#include <QQmlEngine>
#include <QVariantList>
#include <map>
#include <string>
#include <vector>

class BrickSizeModel : public QAbstractListModel {
  Q_OBJECT
  QML_ELEMENT

  Q_PROPERTY(quint32 defaultIndex MEMBER _defaultIndex CONSTANT)

public:
  enum SizeRoles { NameRole = Qt::UserRole + 1, SizeRole, TypeRole };

  explicit BrickSizeModel(QObject *parent = nullptr);
  virtual ~BrickSizeModel() = default;
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE int setTypeAndSize(const QString &type, const QString &size);

private:
  const QVariantMap _sizes;
  quint32 _defaultIndex = 0;
};
