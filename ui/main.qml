import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

Window {
    id: root
    width: 1024
    height: 768
    visibility: Window.Maximized
    visible: true

    readonly property real heightRatio: 0.8
    readonly property int marginWidth: 20
    readonly property int borderWidth: 2

    property int fxInitVal: 1200
    property int fyInitVal: 1200

    Row {
        id: mainView
        width: parent.width - spacing
        height: parent.height - toolView.height
        spacing: marginWidth
        anchors.horizontalCenter: parent.horizontalCenter
        readonly property real rowWidth: parent.width * 0.5 - spacing
        readonly property real fontSize: 20

        Column {
            id: leftColumn
            width: mainView.rowWidth
            spacing: marginWidth

            Label {
                id: label
                text: "Original Image"
                font.pointSize: mainView.fontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: originalContainer
                width: mainView.rowWidth
                height: mainView.height - label.height - leftColumn.spacing
                border.width: borderWidth

                Image {
                    id: originalImage
                    anchors.fill: parent
                    anchors.margins: marginWidth / 2
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Column {
            id: rightColumn
            width: mainView.rowWidth
            spacing: marginWidth

            Label {
                text: "Distorted Image"
                font.pointSize: mainView.fontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: distortedContainer
                width: mainView.rowWidth
                height: mainView.height - label.height - leftColumn.spacing
                border.width: borderWidth

                Image {
                    id: distortedImage
                    anchors.fill: parent
                    anchors.margins: marginWidth / 2
                    fillMode: Image.PreserveAspectFit
                }
            }
        }


    }

    Item {
        id: toolView
        width: parent.width
        height: fxValueWidget.height
        anchors.top: mainView.bottom

        Row {
            spacing: 8

            ValueWidget {
                id: fxValueWidget
                name: "Fx"
                initVal: 1200
                stepSize: 10

                onValueChanged: {
                    updateCalibMatrix();
                }
            }

            ValueWidget {
                id: fyValueWidget
                name: "Fy"
                initVal: 1200
                stepSize: 10

                onValueChanged: {
                    updateCalibMatrix();
                }
            }

            ValueWidget {
                id: cxValueWidget
                name: "Cx"
                initVal: 800
                stepSize: 5

                onValueChanged: {
                    updateCalibMatrix();
                }
            }

            ValueWidget {
                id: cyValueWidget
                name: "Cy"
                initVal: 600
                stepSize: 5

                onValueChanged: {
                    updateCalibMatrix();
                }
            }

            ValueWidget {
                id: k1ValueWidget
                name: "k1"
                initVal: 0
                minStepVal: 0
                maxStepVal: 1
                stepSize: 0.01

                onValueChanged: {
                    updateCalibMatrix();
                }
            }

            ValueWidget {
                id: k2ValueWidget
                name: "k2"
                initVal: 0
                minStepVal: 0
                maxStepVal: 1
                stepSize: 0.01

                onValueChanged: {
                    updateCalibMatrix();
                }
            }

            ValueWidget {
                id: k3ValueWidget
                name: "k3"
                initVal: 0
                minStepVal: 0
                maxStepVal: 1
                stepSize: 0.01

                onValueChanged: {
                    updateCalibMatrix();
                }
            }
        }

        Button {
            id: loadButton
            anchors.right: resetButton.left
            anchors.top: resetButton.top
            anchors.rightMargin: marginWidth * 0.5
            text: "Load"

            onClicked: {
                distorter.loadCalibrationAndImage();
            }
        }

        Button {
            id: resetButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: marginWidth * 0.5
            text: "Reset"

            onClicked: {
                reset();
            }
        }
    }

    Component.onCompleted: {
        timerStartUp.start();
    }

    Connections {
        target: distorter
        enabled: true
        ignoreUnknownSignals: true

        onChessboardReady: {
            originalImage.source = "image://imageProvider/original?rand=" + Math.random();
        }

        onUndistortImageReady: {
            distortedImage.source = "image://imageProvider/distort?rand=" + Math.random();
        }

        onNewCalibLoaded: {
            fxValueWidget.initVal = fx;
            fyValueWidget.initVal = fy;
            cxValueWidget.initVal = cx;
            cyValueWidget.initVal = cy;
            k1ValueWidget.initVal = k1;
            k2ValueWidget.initVal = k2;
            k3ValueWidget.initVal = k3;
            reset();
        }
    }

    Timer {
        id: timerStartUp
        interval: 25
        repeat: false
        onTriggered: {
            startUp();
        }
    }

    function startUp() {
        distorter.generateChessboard();
        reset();
    }

    function reset() {
        fxValueWidget.reset();
        fyValueWidget.reset();
        cxValueWidget.reset();
        cyValueWidget.reset();
        k1ValueWidget.reset();
        k2ValueWidget.reset();
        k3ValueWidget.reset();
        distorter.updateIntrinsics(fxValueWidget.initVal, fyValueWidget.initVal, cxValueWidget.initVal,
            cyValueWidget.initVal, k1ValueWidget.initVal, k2ValueWidget.initVal, k3ValueWidget.initVal);
    }

    function updateCalibMatrix() {
        distorter.updateIntrinsics(fxValueWidget.value, fyValueWidget.value, cxValueWidget.value, cyValueWidget.value,
            k1ValueWidget.value, k2ValueWidget.value, k3ValueWidget.value);
    }

}
