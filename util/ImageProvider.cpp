#include "ImageProvider.hpp"

#include <opencv2/imgproc.hpp>

QPixmap ImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    *size = QSize(m_pixmap.width(), m_pixmap.height());
    return m_pixmap;
}

void ImageProvider::onChessboardGenerated(const cv::Mat &chessboard)
{
    cv::Mat copy;
    chessboard.copyTo(copy);
    cv::Mat temp;
    cv::cvtColor(copy, temp, CV_BGR2RGB);
    QImage qImage((const uchar *) temp.data, temp.cols, temp.rows, temp.step, QImage::Format_RGB888);
    m_pixmap = QPixmap::fromImage(qImage);
}

void ImageProvider::onNewUndistortedImage(const cv::Mat &undistortedImage)
{
    cv::Mat copy;
    undistortedImage.copyTo(copy);
    cv::Mat temp;
    cv::cvtColor(copy, temp, CV_BGR2RGB);
    QImage qImage((const uchar *) temp.data, temp.cols, temp.rows, temp.step, QImage::Format_RGB888);
    m_pixmap = QPixmap::fromImage(qImage);
}
