#include "TutorialModel.h"
#include "BrickLoader.h"
#include <QFile>
#include <QDebug>


size_t TutorialModel::size() const
{
    return _tutorials.size() * 2 + 1;
}

std::optional<QJsonObject> TutorialModel::getTutorialAt(size_t index) const
{
    if (index == 0 || index % 2 == 0)
        return std::nullopt;
    size_t tutorialIndex = index / 2;
    if (tutorialIndex >= _tutorials.size())
        return std::nullopt;
    return _tutorials[tutorialIndex];
}

void TutorialModel::addTutorial(const QFile &file)
{
    QFile &mutableFile = const_cast<QFile&>(file);
    if (!mutableFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "Could not open tutorial file:" << file.fileName();
        return;
    }
    QJsonObject jsonData = BrickLoader::loadJSONObjectFromFile(mutableFile);
    mutableFile.close();

    if (jsonData.isEmpty())
    {
        qWarning() << "Failed to parse tutorial file:" << file.fileName();
        return;
    }
    _tutorials.push_back(jsonData);
}

void TutorialModel::clearTutorials()
{
    _tutorials.clear();
}

void TutorialModel::removeTutorialAt(size_t index)
{
    if (index == 0 || index % 2 == 0)
        return;
    size_t tutorialIndex = index / 2;
    if (tutorialIndex >= _tutorials.size())
        return;
    _tutorials.erase(_tutorials.begin() + tutorialIndex);
}

void TutorialModel::moveElement(size_t fromIndex, size_t toIndex)
{
    if (fromIndex == 0 || fromIndex % 2 == 0)
        return;
    if (toIndex == 0 || toIndex % 2 == 0)
        return;
    size_t fromTutorialIndex = fromIndex / 2;
    size_t toTutorialIndex = toIndex / 2;
    if (fromTutorialIndex >= _tutorials.size() || toTutorialIndex >= _tutorials.size())
        return;
    auto tutorial = _tutorials[fromTutorialIndex];
    _tutorials.erase(_tutorials.begin() + fromTutorialIndex);
    _tutorials.insert(_tutorials.begin() + toTutorialIndex, tutorial);
}
