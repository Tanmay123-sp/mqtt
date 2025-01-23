import QtQuick 2.15

Item {
    id: turnIndicators
    width: 300
    height: 100

    property bool leftIndicatorOn: false
    property bool rightIndicatorOn: false

    // Timer for Left Indicator Blink
    Timer {
        id: leftIndicatorTimer
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            leftIndicatorOn = !leftIndicatorOn; // Toggle left indicator state
            leftIndicator.requestPaint(); // Request a repaint of the left indicator
        }
    }

    // Timer for Right Indicator Blink
    Timer {
        id: rightIndicatorTimer
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            rightIndicatorOn = !rightIndicatorOn; // Toggle right indicator state
            rightIndicator.requestPaint(); // Request a repaint of the right indicator
        }
    }

    // Left Indicator
    Canvas {
        id: leftIndicator
        width: 50
        height: 50
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = leftIndicatorOn ? "#7EEF2F" : "#1C2D3C"
            ctx.beginPath()
            ctx.moveTo(width, 0)
            ctx.lineTo(0, height / 2)
            ctx.lineTo(width, height)
            ctx.closePath()
            ctx.fill()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (leftIndicatorTimer.running) {
                    leftIndicatorTimer.stop()
                    leftIndicatorOn = false;
                    leftIndicator.requestPaint(); // Request a repaint to reflect the change
                } else {
                    leftIndicatorTimer.start();
                    rightIndicatorTimer.stop(); // Stop the right indicator timer if it was running
                    rightIndicatorOn = false; // Turn off the right indicator
                    rightIndicator.requestPaint(); // Request a repaint to reflect the change
                }
            }
        }
    }

    // Right Indicator
    Canvas {
        id: rightIndicator
        width: 50
        height: 50
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = rightIndicatorOn ? "#7EEF2F" : "#1C2D3C"
            ctx.beginPath()
            ctx.moveTo(0, 0)
            ctx.lineTo(width, height / 2)
            ctx.lineTo(0, height)
            ctx.closePath()
            ctx.fill()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (rightIndicatorTimer.running) {
                    rightIndicatorTimer.stop();
                    rightIndicatorOn = false;
                    rightIndicator.requestPaint(); // Request a repaint to reflect the change
                } else {
                    rightIndicatorTimer.start();
                    leftIndicatorTimer.stop(); // Stop the left indicator timer if it was running
                    leftIndicatorOn = false; // Turn off the left indicator
                    leftIndicator.requestPaint(); // Request a repaint to reflect the change
                }
            }
        }
    }
}
