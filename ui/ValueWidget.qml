import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: root
    width: 200
    height: 250

    property alias name: nameLabel.text
    property alias stepSize: stepSlider.stepSize
    property alias minStepVal: stepSlider.from
    property alias maxStepVal: stepSlider.to

    readonly property int marginWidth: 5
    readonly property real textFieldWidth: width - tuneLabel.width - marginWidth * 2

    property real initVal: 0
    property int precision: 2

    Label {
        id: nameLabel
        anchors.left: parent.left
        anchors.leftMargin: marginWidth
        anchors.verticalCenter: valueTextField.verticalCenter
        text: "Name"
    }
    TextField {
        id: valueTextField
        width: textFieldWidth
        anchors.top: parent.top
        anchors.topMargin: marginWidth
        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        text: "n/a"
        enabled: false
    }

    Label {
        id: fStepLabel
        anchors.left: parent.left
        anchors.leftMargin: marginWidth
        anchors.verticalCenter: stepTextField.verticalCenter
        text: "Step"
    }
    TextField {
        id: stepTextField
        width: textFieldWidth
        anchors.top: valueTextField.bottom
        anchors.topMargin: marginWidth
        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        text: "n/a"
        enabled: false
    }
    Slider {
        id: stepSlider
        width: parent.width
        anchors.top: stepTextField.bottom
        from: 0
        to: 100
        stepSize: 1
        value: to
        onValueChanged: {
            stepTextField.text = value.toFixed(precision);
            valueTextField.text = (initVal + value * tuneSlider.value).toFixed(precision);
            valueTextField.text = (initVal + value * tuneSlider.value).toFixed(precision);
        }
    }

    Label {
        id: tuneLabel
        anchors.left: parent.left
        anchors.leftMargin: marginWidth
        anchors.verticalCenter: tuneTextField.verticalCenter
        text: "Tune "
    }
    TextField {
        id: tuneTextField
        width: textFieldWidth
        anchors.top: stepSlider.bottom
        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        text: "n/a"
        enabled: false
    }
    Slider {
        id: tuneSlider
        width: parent.width
        anchors.top: tuneTextField.bottom
        from: -10
        to: 10
        stepSize: 1
        value: to
        onValueChanged: {
            tuneTextField.text = value.toFixed(precision);
            valueTextField.text = (initVal + stepSlider.value * value).toFixed(precision);
            valueTextField.text = (initVal + stepSlider.value * value).toFixed(precision);
        }
    }

    onInitValChanged: {
        reset();
    }

    Component.onCompleted: {
        timerStartUp.start();
    }

    Timer {
        id: timerStartUp
        interval: 10
        repeat: false
        onTriggered: {
            startUp();
        }
    }

    function startUp() {
        reset();
    }

    function reset() {
        valueTextField.text = initVal.toFixed(precision);
        stepSlider.value = stepSlider.from.toFixed(precision);
        tuneSlider.value = 0;
    }

}