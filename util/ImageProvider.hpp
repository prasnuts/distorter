#pragma once

#include <opencv2/core.hpp>

#include <QImage>
#include <QObject>
#include <QQuickImageProvider>

class ImageProvider : public QObject, public QQuickImageProvider {
    Q_OBJECT
public:
    ImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap) {}

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;

signals:
    void chessboardReady();

    void undistortedImageReady();

public slots:
    void onChessboardGenerated(const cv::Mat &chessboard);

    void onNewUndistortedImage(const cv::Mat &undistortedImage);

private:
    QPixmap m_pixmap{};
};


