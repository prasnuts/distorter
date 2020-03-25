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
}