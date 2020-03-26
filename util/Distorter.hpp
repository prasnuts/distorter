#pragma once

#include <QObject>
#include <QString>

#include <opencv2/core.hpp>

class Distorter : public QObject{
    Q_OBJECT

public:
    Distorter(QObject *parent = nullptr);

    ~Distorter() = default;

    Q_INVOKABLE void generateChessboard();

    Q_INVOKABLE void updateIntrinsics(double fx, double fy, double cx, double cy, double k1, double k2, double k3);

    Q_INVOKABLE bool loadCalibrationAndImage();

signals:
    void chessboardGenerated(const cv::Mat &chessboard);

    void newUndistortedImage(const cv::Mat &undistortedImage);

    void chessboardReady();

    void undistortImageReady();

    void newCalibLoaded(double fx, double fy, double cx, double cy, double k1, double k2, double k3);

public slots:
    void onChessboardReady();

    void onUndistortedImageReady();

private:
    bool loadCalibrationAndImage(const QString &calibFilename, const QString &imageFilename);

    cv::Mat m_chessboard;
    cv::Mat m_calibM;
    cv::Mat m_distCoeffs;
};

