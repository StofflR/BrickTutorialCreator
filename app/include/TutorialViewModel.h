#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include "TutorialModel.h"

class TutorialViewModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(size_t elementWidth MEMBER _elementWidth NOTIFY elementWidthChanged)

public:
    enum TutorialRoles
    {
        ElementRole = Qt::UserRole + 1,
        TypeRole,

    };
    Q_ENUM(TutorialRoles)

    explicit TutorialViewModel(QObject *parent = nullptr);
    virtual ~TutorialViewModel() = default;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index,
                  int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void addBrick();
    Q_INVOKABLE void removeBrick(size_t index);
    Q_INVOKABLE void clearBricks();
    Q_INVOKABLE void moveBrick(size_t fromIndex, size_t toIndex);

protected:
    QHash<int, QByteArray> roleNames() const override;

signals:
    void elementWidthChanged();

private:
    TutorialModel _tutorialModel;
    size_t _elementWidth = 300;
};