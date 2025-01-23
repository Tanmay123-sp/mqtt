import QtQuick 2.15
import QtQuick.Controls 2.15
import Mqtt 1.0


ApplicationWindow {

    id:mainWin
    visible: true
    width: 800
    height: 600
    title: "Car Dashboard"
    color: "grey"

    DashboardShape {
        id:dashboardShape
        anchors.fill: parent
    }

    Speedometer {
        id:speedometer
        anchors.bottom: dashboardShape.bottom
        anchors.right: dashboardShape.right
        anchors.rightMargin: -250
        anchors.bottomMargin: -100
        onSpeedValueChanged: {
            totalkm.updateSpeed(speed);
        }
    }
    // StartAndStop{
    //     id:startAndStop
    //     anchors.bottom: dashboardShape.bottom
    //         anchors.right: dashboardShape.right
    //         anchors.rightMargin: -250
    //         anchors.bottomMargin: -100
    //         onSpeedValueChanged: {
    //             totalkm.updateSpeed(speed);
    //         }
    // }

    TotalKm {
        id: totalkm
        anchors.left: speedometer.left
        anchors.bottom: dashboardShape.bottom
        anchors.leftMargin: -100
        anchors.bottomMargin: 30
    }

    FuelGauge {
        anchors.right: dashboardShape.right
        anchors.top: dashboardShape.top
        anchors.topMargin: 280
        anchors.rightMargin: 120
        totalKmItem: totalkm
    }

    DigitalClock {
        anchors.bottom: dashboardShape.bottom
        anchors.horizontalCenter: dashboardShape.horizontalCenter
        anchors.bottomMargin: 420
    }

    TurnIndicators {
        anchors.horizontalCenter: dashboardShape.horizontalCenter
        anchors.top: dashboardShape.top
        anchors.topMargin: 40
    }
}
