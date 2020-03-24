#include <QApplication>
#include <QDebug>

#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char **argv) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.addImportPath( "qrc://ui/." );
    engine.load(QUrl(QLatin1String("qrc:/ui/main.qml")));
    return QApplication::exec();
}
