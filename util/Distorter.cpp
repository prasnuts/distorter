#include "Distorter.hpp"

#include <opencv2/imgproc.hpp>

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

void Distorter::updateIntrinsics(float fx, float fy, float cx, float cy, float k1, float k2, float k3)
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

void Distorter::onChessboardReady()
{
    emit chessboardReady();
}

void Distorter::onUndistortedImageReady()
{
    emit undistortImageReady();
}
