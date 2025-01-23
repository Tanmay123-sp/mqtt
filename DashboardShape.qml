import QtQuick 2.15
import QtQuick.Controls 2.15

Canvas {
    id: dashboardCanvas
    width: 800
    height: 600

    onPaint: {
        var ctx = getContext("2d")
        var width = dashboardCanvas.width
        var height = dashboardCanvas.height
        var centerX = width / 2
        var centerY = height / 2 + 50

        ctx.clearRect(0, 0, width, height)

        // Outer shape for the dashboard
        ctx.strokeStyle = "rgb(36, 47, 61)"
        ctx.fillStyle = "#08162B"
        ctx.beginPath()

        // Move to the top left of the dashboard
        ctx.moveTo(centerX - 300, centerY - 150)

        // Create a more curvy top from left to right
        ctx.quadraticCurveTo(centerX, centerY - 300, centerX + 300, centerY - 150)

        // Create smoother bottom corners and maintain the curves
        ctx.quadraticCurveTo(centerX + 380, centerY + 80, centerX + 250, centerY + 130) // Right curve
        ctx.lineTo(centerX - 250, centerY + 130) // Straight line across the bottom
        ctx.quadraticCurveTo(centerX - 380, centerY + 80, centerX - 300, centerY - 150) // Left curve

        ctx.closePath()
        ctx.fill()
        ctx.stroke()
    }
}
