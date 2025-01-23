import QtQuick 2.15
import QtQuick.Controls 2.15
import Mqtt 1.0
Item {

    function startWithMqtt(state){
        if(state===true){
            startTimer.start()
        }
        else if(state ===false){
            stopTimer.start()
            startTimer.stop()
        }
    }

    width: 800
    height: 400

    property real speed: 0          // Current speed of the vehicle
    property real maxSpeed: 120     // Maximum speed
    property real acceleration: 0    // Acceleration value for speed changes
    property real rpm: 0            // RPM value based on speed and acceleration

    signal speedValueChanged(real speed)   // Custom signal to notify about speed changes
    signal rpmValueChanged(real rpm)       // Custom signal to notify about RPM changes

    // Update the RPM based on speed and acceleration
    function updateRPM() {
        rpm = speed * 100 + acceleration * 50;  // Example formula for RPM
        rpmValueChanged(rpm);  // Emit the custom signal when RPM changes
    }

    Canvas {
        id: speedometerCanvas
        width: 310
        height: 310

        onPaint: {
            var ctx = getContext("2d");

            // Clear the canvas before repainting to avoid overlapping drawings
            ctx.clearRect(0, 0, width, height);

            var centerX = width / 2;
            var centerY = height / 2;
            var gaugeRadius = 150;

            // Draw Speedometer Background with Gradient
            var grd = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, gaugeRadius);
            grd.addColorStop(0, "#2A3B4D"); // Center color
            grd.addColorStop(1, "#1C2D3C"); // Edge color
            ctx.beginPath();
            ctx.arc(centerX, centerY, gaugeRadius, Math.PI, 2 * Math.PI, false);
            ctx.fillStyle = grd;
            ctx.fill();
            ctx.lineWidth = 5;
            ctx.strokeStyle = "#3A6075";
            ctx.stroke();
            ctx.closePath();

            // Limit speed to maxSpeed
            var limitedSpeed = Math.min(speed, maxSpeed); // Prevent speed from exceeding maxSpeed

            // Draw Speedometer Needle as Arrow
            var needleAngle = (limitedSpeed / maxSpeed) * Math.PI + Math.PI; // Use limited speed
            var needleLength = gaugeRadius - 60;
            var needleEndX = centerX + needleLength * Math.cos(needleAngle);
            var needleEndY = centerY + needleLength * Math.sin(needleAngle);

            ctx.lineWidth = 6;
            ctx.strokeStyle = "#FF4500"; // Needle color
            ctx.beginPath();
            ctx.moveTo(centerX, centerY);
            ctx.lineTo(needleEndX, needleEndY);
            ctx.stroke();
            ctx.closePath();

            // Draw Arrowhead for Needle
            var arrowLength = 10; // Length of the arrowhead
            var arrowAngle1 = needleAngle - 0.15; // Angle for left side of the arrow
            var arrowAngle2 = needleAngle + 0.15; // Angle for right side of the arrow
            ctx.beginPath();
            ctx.moveTo(needleEndX, needleEndY);
            ctx.lineTo(needleEndX - arrowLength * Math.cos(arrowAngle1),
                       needleEndY - arrowLength * Math.sin(arrowAngle1));
            ctx.lineTo(needleEndX - arrowLength * Math.cos(arrowAngle2),
                       needleEndY - arrowLength * Math.sin(arrowAngle2));
            ctx.closePath();
            ctx.fillStyle = "#FF4500"; // Arrowhead color
            ctx.fill();
            ctx.stroke();

            // Draw Speedometer Center Dot
            ctx.beginPath();
            ctx.arc(centerX, centerY, 8, 0, 2 * Math.PI, false); // Increased size for visibility
            ctx.fillStyle = "#FF4500"; // Center dot color
            ctx.fill();
            ctx.closePath();

            // Draw Speed Labels
            ctx.fillStyle = "#FFFFFF"; // Label color
            ctx.font = "16px Arial";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";

            for (var i = 0; i <= maxSpeed; i += 10) {
                var angle = (i / maxSpeed) * Math.PI + Math.PI; // Calculate angle for each label
                var labelX = centerX + (gaugeRadius - 25) * Math.cos(angle); // Adjust position to avoid overlap
                var labelY = centerY + (gaugeRadius - 25) * Math.sin(angle);
                ctx.fillText(i.toString(), labelX, labelY); // Draw the label
            }

            // Draw additional decorative elements
            for (var i = 0; i <= maxSpeed; i += 5) { // Minor ticks
                var angle = (i / maxSpeed) * Math.PI + Math.PI;
                var tickLength = (i % 10 === 0) ? 15 : 10; // Longer ticks for major intervals
                var tickStartX = centerX + (gaugeRadius - tickLength) * Math.cos(angle);
                var tickStartY = centerY + (gaugeRadius - tickLength) * Math.sin(angle);
                var tickEndX = centerX + gaugeRadius * Math.cos(angle);
                var tickEndY = centerY + gaugeRadius * Math.sin(angle);
                ctx.lineWidth = 2;
                ctx.strokeStyle = "#FFFFFF"; // Tick color
                ctx.beginPath();
                ctx.moveTo(tickStartX, tickStartY);
                ctx.lineTo(tickEndX, tickEndY);
                ctx.stroke();
                ctx.closePath();
            }
        }
    }

    // Slider for Speed Control
    // Slider {
    //     id: speedSlider
    //     from: 0
    //     to: maxSpeed
    //     stepSize: 1
    //     anchors.top: speedometerCanvas.bottom
    //     anchors.horizontalCenter: speedometerCanvas.horizontalCenter
    //     anchors.topMargin: -100
    //     width: 100
    //     onValueChanged: {
    //         speed = value; // Update speed based on slider value
    //         updateRPM(); // Update the RPM
    //         speedValueChanged(speed);  // Emit the custom signal when speed changes
    //         speedometerCanvas.requestPaint(); // Request a repaint to update the needle
    //     }
    // }

    Button{
        id:startButton
        text: "Start"
        anchors.top: speedometerCanvas.bottom
        anchors.horizontalCenter: speedometerCanvas.horizontalCenter
        anchors.topMargin: -100
        width: 100
        onClicked:  {


            startTimer.start()
             // Emit the custom signal when speed changes
             // Request a repaint to update the needle
        }
    }

    Button{
        id:stopButton
        text: "Stop"
        anchors.top: speedometerCanvas.bottom
        anchors.horizontalCenter: speedometerCanvas.horizontalCenter + 250
        anchors.topMargin: -100
        width: 100
        onClicked:  {
            startTimer.stop()
            stopTimer.start()
        }
    }

    // Text {
    //     text: "Accelerator "   // Display acceleration value
    //     padding: 228
    //     leftPadding: 110
    // }

    Text {
        padding: 100
        id: rpmDisplay
        text: "RPM: " + rpm.toFixed(0)
        font.pixelSize: 30
        color: "#FF4500"
    }
    Timer {
        id: startTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            speed+=10;
            updateRPM(); // Update the RPM
            speedValueChanged(speed);
            speedometerCanvas.requestPaint();
        }
    }

    Timer {
        id: stopTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            if(speed >0){
                speed-=1;
                updateRPM(); // Update the RPM
                speedValueChanged(speed);
                speedometerCanvas.requestPaint();
            }
            else{
                stopTimer.stop()
            }
        }
    }
    Mqtt{
        id:mqttId
        onMessageReceived: {
            if(message === "start"){
                startWithMqtt(true)
            }
            else if(message === "stop"){
                startWithMqtt(false)
            }
        }
    }
    Component.onCompleted: {
        mqttId.connectToHost(
               "c4d197a73c4b4280ab318c9a8638e293.s1.eu.hivemq.cloud",
                8883,"tanmay1","Password1","control")
    }
}

