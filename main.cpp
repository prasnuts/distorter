#include <QApplication>
#include <QDebug>

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "util/Distorter.hpp"
#include "util/ImageProvider.hpp"

int main(int argc, char **argv) {
    qRegisterMetaType< cv::Mat >("cv::Mat");

    QApplication app(argc, argv);

    Distorter distorter{};
    ImageProvider * imageProvider = new ImageProvider{};

    QObject::connect(&distorter, &Distorter::chessboardGenerated, imageProvider, &ImageProvider::onChessboardGenerated);
    QObject::connect(imageProvider, &ImageProvider::chessboardReady, &distorter, &Distorter::onChessboardReady);

    QObject::connect(&distorter, &Distorter::newUndistortedImage, imageProvider, &ImageProvider::onNewUndistortedImage);
    QObject::connect(imageProvider, &ImageProvider::undistortedImageReady, &distorter, &Distorter::onUndistortedImageReady);

    QQmlApplicationEngine engine;
    engine.addImageProvider("imageProvider", imageProvider);
    engine.rootContext()->setContextProperty("distorter", &distorter);

    engine.addImportPath( "qrc://ui/." );
    engine.load(QUrl(QLatin1String("qrc:/ui/main.qml")));
    return QApplication::exec();
}
