#include <QGuiApplication>
#include <QQmlApplicationEngine>

void setup(QGuiApplication* app, QQmlApplicationEngine* engine){
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
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    setup(&app, &engine);
    return app.exec();
}

#else

QGuiApplication *g_app = nullptr;
QQmlApplicationEngine *g_engine = nullptr;

int main(int argc, char **argv)
{
    g_app = new QGuiApplication(argc, argv);
    g_engine = new QQmlApplicationEngine();
    setup(g_app, g_engine);
    return 0;
}
#endif
