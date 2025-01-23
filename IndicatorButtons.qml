import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: indicatorButtons

    Button {
        text: "Left"
        onClicked: {
            indicatorControl.startLeftIndicator()
        }
    }

    Button {
        text: "Right"
        anchors.left: parent.right
        onClicked: {
            indicatorControl.startRightIndicator()
        }
    }
}
