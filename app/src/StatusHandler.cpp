#include "StatusHandler.h"

StatusHandler::StatusHandler(QObject *parent) : QObject(parent) {
  StatusHandlerProvider::setHandler(this);
}

void StatusHandler::setStatusMessage(const QString &message) {
  _statusMessage = message;
  emit statusMessageChanged();
}