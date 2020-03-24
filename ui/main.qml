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

        Button {
            id: button
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: marginWidth
            text: "Click"

            onClicked: {
                distorter.generateChessboard();
            }
        }
    }

    Component.onCompleted: {
        distorter.generateChessboard();
    }

    Connections {
        target: distorter
        enabled: true
        ignoreUnknownSignals: true

        onChessboardGenerated: {
            originalImage.source = "image://imageProvider/original?rand=" + Math.random();
        }
    }
}
