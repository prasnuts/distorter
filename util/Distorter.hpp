#pragma once

#include <QObject>

#include <opencv2/core.hpp>

class Distorter : public QObject{
    Q_OBJECT

public:
    Distorter(QObject *parent = nullptr);

    ~Distorter() = default;

    Q_INVOKABLE void generateChessboard();

signals:
    void chessboardGenerated(const cv::Mat &chessboard);

    void newUndistortedImage(const cv::Mat &undistortedImage);

private:
    cv::Mat m_chessboard;
    cv::Mat m_calibM;
    cv::Mat m_distCoeffs;
};

