#include "Distorter.hpp"

#include <opencv2/imgproc.hpp>

Distorter::Distorter(QObject *parent) : QObject(parent)
{  }

void Distorter::generateChessboard()
{
    cv::Mat chessboard;
    const int step{100};
    const int width{13};
    const int height{9};
    const cv::Scalar white = cv::Scalar(255, 255, 255);

    chessboard = cv::Mat::zeros(height * step, width * step, CV_8UC3);

    for(int row = 0; row < height; row += 2){
        for(int col = 1; col < width; col += 2){
            const int x = col * step;
            const int y = row * step;
            cv::rectangle(chessboard, cv::Point(x, y), cv::Point(x + step, y +step), white, -1, cv::LINE_AA);
        }
    }
    for(int row = 1; row < height; row += 2){
        for(int col = 0; col < width; col += 2){
            const int x = col * step;
            const int y = row * step;
            cv::rectangle(chessboard, cv::Point(x, y), cv::Point(x + step, y +step), white, -1, cv::LINE_AA);
        }
    }
    emit chessboardGenerated(chessboard);
}