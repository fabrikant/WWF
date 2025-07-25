using Toybox.System;
using Toybox.Application;

class MoonField extends SimpleField {
  function initialize(params) {
    SimpleField.initialize(params);
  }

  function draw(dc, value) {
    clear(dc);
    drawMoon(dc, value);
    drawBorder(dc);
  }

  function drawMoon(dc, phase) {
    var backgroundColor = getBackgroundColor();
    var color = getColor();
    var rPos;
    var xPos, xPos1, xPos2;
    var shift = w / 2;
    var r = 0.8 * shift;

    for (var yPos = 0; yPos <= r; yPos++) {
      xPos = Math.sqrt(r * r - yPos * yPos);

      dc.setColor(backgroundColor, backgroundColor);
      dc.drawLine(
        x + shift - xPos,
        y + yPos + shift,
        x + xPos + shift,
        y + yPos + shift
      );
      dc.drawLine(
        x + shift - xPos,
        y + shift - yPos,
        x + xPos + shift,
        y + shift - yPos
      );

      // Determine the edges of the lighted part of the moon
      rPos = 2 * xPos;
      if (phase < 0.5) {
        xPos1 = -xPos;
        xPos2 = rPos - 2 * phase * rPos - xPos;
      } else {
        xPos1 = xPos;
        xPos2 = xPos - 2 * phase * rPos + rPos;
      }
      dc.setColor(color, color);
      dc.drawLine(
        x + shift - xPos1,
        y + yPos + shift,
        x + xPos2 + shift,
        y + yPos + shift
      );
      dc.drawLine(
        x + shift - xPos1,
        y + shift - yPos,
        x + xPos2 + shift,
        y + shift - yPos
      );
    }

    dc.setColor(color, color);
    dc.drawCircle(x + shift, y + shift, r);
  }
}
