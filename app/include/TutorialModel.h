#pragma once
#include <optional>
#include <vector>
#include <QJsonObject>

class QFile;

class TutorialModel
{
public:
    TutorialModel() = default;
    ~TutorialModel() = default;

    size_t size() const;
    std::optional<QJsonObject> getTutorialAt(size_t index) const;
    void addBrick(const QJsonObject &brick);
    void clearBricks();
    void removeBrickAt(size_t index);
    void moveBrick(size_t fromIndex, size_t toIndex);

private:
    std::vector<QJsonObject> _bricks;
};