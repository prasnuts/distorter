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
        height: parent.height * heightRatio
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
        height: parent.height - mainView.height
        anchors.top: mainView.bottom

        Label {
            id: fxLabel
            anchors.left: parent.left
            anchors.leftMargin: marginWidth * 0.5
            anchors.verticalCenter: fxTextField.verticalCenter
            text: "Fx"
        }
        TextField {
            id: fxTextField
            anchors.left: fxLabel.right
            anchors.top: parent.top
            anchors.topMargin: marginWidth
            anchors.leftMargin: marginWidth * 0.5
            horizontalAlignment: Text.AlignRight
            text: "n/a"
            enabled: false
        }

        Label {
            id: fyLabel
            anchors.left: fxLabel.left
            anchors.verticalCenter: fyTextField.verticalCenter
            text: "Fy"
        }
        TextField {
            id: fyTextField
            anchors.left: fyLabel.right
            anchors.top: fxTextField.bottom
            anchors.topMargin: marginWidth * 0.5
            anchors.leftMargin: marginWidth * 0.5
            horizontalAlignment: Text.AlignRight
            text: "n/a"
            enabled: false
        }

        Label {
            id: fStepLabel
            anchors.left: parent.left
            anchors.leftMargin: marginWidth * 0.5
            anchors.verticalCenter: fStepSlider.verticalCenter
            text: "Step"
        }
        Slider {
            id: fStepSlider
            anchors.left: fStepLabel.right
            anchors.right: fStepValueLabel.left
            anchors.top: fyTextField.bottom
            anchors.topMargin: marginWidth * 0.5
            from: 1
            to: 100
            stepSize: 1
            value: 1
            onValueChanged: {
                fxTextField.text = fxInitVal + value * fTuneSlider.value;
                fyTextField.text = fyInitVal + value * fTuneSlider.value;
            }
        }
        Label {
            id: fStepValueLabel
            width: 25
            anchors.right: fyTextField.right
            anchors.verticalCenter: fStepSlider.verticalCenter
            text: fStepSlider.value
            horizontalAlignment: Text.AlignRight
        }

        Label {
            id: fTuneLabel
            anchors.left: parent.left
            anchors.leftMargin: marginWidth * 0.5
            anchors.verticalCenter: fTuneSlider.verticalCenter
            text: "Tune"
        }
        Slider {
            id: fTuneSlider
            anchors.left: fTuneLabel.right
            anchors.right: fStepValueLabel.right
            anchors.top: fStepSlider.bottom
            anchors.topMargin: marginWidth * 0.5
            from: -10
            to: 10
            stepSize: 1
            value: 0

            onValueChanged: {
                fxTextField.text = fxInitVal + fStepSlider.value * value;
                fyTextField.text = fyInitVal + fStepSlider.value * value;
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

        onChessboardGenerated: {
            originalImage.source = "image://imageProvider/original?rand=" + Math.random();
        }
    }

    Timer {
        id: timerStartUp
        interval: 500
        repeat: false
        onTriggered: {
            startUp();
        }
    }

    function startUp() {
        distorter.generateChessboard();
        distorter.generateChessboard();
        reset();
    }

    function reset() {
        fxTextField.text = fxInitVal;
        fyTextField.text = fyInitVal;
    }
}
