#pragma once

#include <QJSEngine>
#include <QJSValue>
#include <QObject>
#include <QQmlEngine>
#include <memory>

class StatusHandler;

class StatusHandlerProvider {
public:
  StatusHandlerProvider() = delete;
  ~StatusHandlerProvider() = delete;

  static StatusHandler *getInstance() { return _statusHandler; }

  static void setHandler(StatusHandler *handler) { _statusHandler = handler; }

private:
  static inline StatusHandler *_statusHandler = nullptr;
};

class StatusHandler : public QObject {
  Q_OBJECT
  QML_SINGLETON
  QML_ELEMENT
  Q_PROPERTY(
      QString statusMessage MEMBER _statusMessage NOTIFY statusMessageChanged)
public:
  StatusHandler(QObject *parent = nullptr);
  void setStatusMessage(const QString &message);

signals:
  void statusMessageChanged();

private:
  QString _statusMessage;
};
