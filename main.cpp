#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mqtt.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    qmlRegisterType<mqtt>("Mqtt", 1, 0, "Mqtt");
    engine.loadFromModule("vehicleDashboardQML", "Main");

    return app.exec();
}
