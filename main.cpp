#include <QApplication>
#include <QQmlApplicationEngine>

void setup(QApplication* app, QQmlApplicationEngine* engine){
    engine->addImportPath("qrc:/");
    QObject::connect(
        engine,
        &QQmlApplicationEngine::objectCreationFailed,
        app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine->loadFromModule("app", "App");
}

#ifndef __EMSCRIPTEN__

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    setup(&app, &engine);
    return app.exec();
}

#else

QApplication *g_app = nullptr;
QQmlApplicationEngine *g_engine = nullptr;

int main(int argc, char **argv)
{
    g_app = new QApplication(argc, argv);
    g_engine = new QQmlApplicationEngine();
    setup(g_app, g_engine);
    return 0;
}
#endif
