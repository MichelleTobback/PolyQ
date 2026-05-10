#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#ifdef Q_OS_ANDROID
    #include <QJniObject>
#endif // Q_OS_ANDROID

#include "Controllers/FlashcardController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    qmlRegisterType<PolyQ::FlashcardController>(
        "PolyQ.Controllers", 1, 0, "FlashcardController");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

#ifdef Q_OS_ANDROID
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if (activity.isValid())
    {
        QJniObject window = activity.callObjectMethod(
            "getWindow",
            "()Landroid/view/Window;");

        if (window.isValid())
        {
            window.callMethod<void>(
                "setStatusBarColor",
                "(I)V",
                0x00000000);

            window.callMethod<void>(
                "setNavigationBarColor",
                "(I)V",
                0x00000000);
        }
    }
#endif

    engine.loadFromModule("PolyQ", "Main");

    return QCoreApplication::exec();
}
