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

public slots:
    void onChessboardGenerated(const cv::Mat &chessboard);

private:
    QPixmap m_pixmap{};
};


