#include "TutorialViewModel.h"
#include <QFileDialog>
#include <QTemporaryFile>
#include "BrickLoader.h"

TutorialViewModel::TutorialViewModel(QObject *parent)
    : QAbstractListModel(parent) {}

int TutorialViewModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return static_cast<int>(_tutorialModel.size());
}

QVariant TutorialViewModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    size_t row = static_cast<size_t>(index.row());
    auto tutorialOpt = _tutorialModel.getTutorialAt(row);
    if (!tutorialOpt.has_value())
        return QVariant();

    const auto &tutorial = tutorialOpt.value();
    switch (role)
    {
    case ElementRole:
        return QVariant::fromValue(tutorial);
    case TypeRole:
        return tutorial.value("Type").toString();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TutorialViewModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ElementRole] = "element";
    roles[TypeRole] = "type";
    return roles;
}

void TutorialViewModel::addBrick()
{
    auto fileContentReady = [this](const QString &fileName, const QByteArray &fileContent)
    {
        if (fileName.isEmpty())
        {
            qInfo() << "No file selected.";
            return;
        }
        else
        {
            qInfo() << "Loading file:" << fileName;
            QJsonObject jsonData;
            if(fileName.contains(".svg", Qt::CaseInsensitive)){
                jsonData = BrickLoader::loadFromSVG(fileContent);
            }
            else if(fileName.contains(".json", Qt::CaseInsensitive)){
                jsonData = BrickLoader::loadFromJSON(fileContent);
            }
            else if(fileName.contains(".png", Qt::CaseInsensitive)){
                jsonData = BrickLoader::loadFromPNG(fileContent);
            }
            else{
                qWarning() << "Unsupported file type:" << fileName;
                return;
            }
            
        }
        _tutorialModel.addBrick(jsonData);
    };
    QFileDialog::getOpenFileContent("Bricks (*.svg *.json *.png)", fileContentReady);
}

void TutorialViewModel::removeBrick(size_t index)
{
    beginRemoveRows(QModelIndex(), static_cast<int>(index),
                    static_cast<int>(index));
    _tutorialModel.removeTutorialAt(index);
    endRemoveRows();
}
void TutorialViewModel::clearBricks()
{
    beginResetModel();
    _tutorialModel.clearTutorials();
    endResetModel();
}
void TutorialViewModel::moveBrick(size_t fromIndex, size_t toIndex)
{
    beginMoveRows(QModelIndex(), static_cast<int>(fromIndex),
                  static_cast<int>(fromIndex), QModelIndex(),
                  static_cast<int>(toIndex) + (fromIndex < toIndex ? 1 : 0));
    _tutorialModel.moveElement(fromIndex, toIndex);
    endMoveRows();
}