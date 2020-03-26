#include "Distorter.hpp"

#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>

#include <QDomDocument>
#include <QFile>

Distorter::Distorter(QObject *parent) : QObject(parent)
{
    m_calibM = cv::Mat::eye(3, 3, CV_64F);
    m_distCoeffs = cv::Mat::zeros(1, 5, CV_64F);
}

void Distorter::generateChessboard()
{
    const int step{100};
    const int width{16};
    const int height{12};
    const cv::Scalar white = cv::Scalar(255, 255, 255);

    m_chessboard = cv::Mat::zeros(height * step, width * step, CV_8UC3);

    for(int row = 0; row < height; row += 2){
        for(int col = 1; col < width; col += 2){
            const int x = col * step;
            const int y = row * step;
            cv::rectangle(m_chessboard, cv::Point(x, y), cv::Point(x + step, y +step), white, -1, cv::LINE_AA);
        }
    }
    for(int row = 1; row < height; row += 2){
        for(int col = 0; col < width; col += 2){
            const int x = col * step;
            const int y = row * step;
            cv::rectangle(m_chessboard, cv::Point(x, y), cv::Point(x + step, y +step), white, -1, cv::LINE_AA);
        }
    }
    emit chessboardGenerated(m_chessboard);
}

void Distorter::updateIntrinsics(double fx, double fy, double cx, double cy, double k1, double k2, double k3)
{
    m_calibM.at<double>(0,0) = fx;
    m_calibM.at<double>(1,1) = fy;
    m_calibM.at<double>(0,2) = cx;
    m_calibM.at<double>(1,2) = cy;

    m_distCoeffs.at<double>(0,0) = k1;
    m_distCoeffs.at<double>(0,1) = k2;
    m_distCoeffs.at<double>(0,4) = k3;

    if(m_chessboard.cols == 0){
        return;
    }
    cv::Mat undistortedImage;
    cv::undistort(m_chessboard, undistortedImage, m_calibM, m_distCoeffs);
    emit newUndistortedImage(undistortedImage);
}

bool Distorter::loadCalibrationAndImage()
{
    return loadCalibrationAndImage(DATA_DIR"/calib.xml", DATA_DIR"/image.jpg");
}

void Distorter::onChessboardReady()
{
    emit chessboardReady();
}

void Distorter::onUndistortedImageReady()
{
    emit undistortImageReady();
}

bool Distorter::loadCalibrationAndImage(const QString &calibFilename, const QString &imageFilename)
{
    QDomDocument doc{};
    QFile file(calibFilename);
    if (!file.open(QIODevice::ReadOnly)) {
        return false;
    }
    if (!doc.setContent(&file)){
        file.close();
        return false;
    }
    file.close();

    bool widthOk, heightOk, fxOk, fyOk, cxOk, cyOk, k1Ok, k2Ok, k3Ok;
    const auto width = doc.elementsByTagName("width").at(0).toElement().text().toInt(&widthOk);
    const auto height = doc.elementsByTagName("height").at(0).toElement().text().toInt(&heightOk);
    const auto fx = doc.elementsByTagName("fx").at(0).toElement().text().toDouble(&fxOk);
    const auto fy = doc.elementsByTagName("fy").at(0).toElement().text().toDouble(&fyOk);
    const auto cx = doc.elementsByTagName("cx").at(0).toElement().text().toDouble(&cxOk);
    const auto cy = doc.elementsByTagName("cy").at(0).toElement().text().toDouble(&cyOk);
    const auto k1 = doc.elementsByTagName("k1").at(0).toElement().text().toDouble(&k1Ok);
    const auto k2 = doc.elementsByTagName("k2").at(0).toElement().text().toDouble(&k2Ok);
    const auto k3 = doc.elementsByTagName("k3").at(0).toElement().text().toDouble(&k3Ok);

    if(!widthOk || !heightOk || !fxOk || !fyOk || !cxOk || !cyOk || !k1Ok || !k2Ok || !k3Ok){
        return false;
    }

    cv::Mat tempImage = cv::imread(imageFilename.toStdString());
    if(tempImage.cols != width || tempImage.rows != height){
        return false;
    }

    m_chessboard = tempImage;
    emit chessboardGenerated(m_chessboard);
    emit newCalibLoaded(fx, fy, cx, cy, k1, k2, k3);
    return true;
}
