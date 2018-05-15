module project.gui.windows.visualizer.path;

import dlangui;

private enum Style {
  LineWidth = 2,
  PointSize = 6,
  Offset = (Style.PointSize - Style.LineWidth) / 2
}

package struct RidePath {
  Point from;
  Point to;
  uint pathColor;
  uint pointColor;

  void draw(DrawBuf buf) {
    Point middle = Point(this.to.x, this.from.y);

    foreach (int i; 0 .. Style.LineWidth) {
      Point horizontalOffset = Point(0, i + Style.Offset);
      Point verticalOffset = Point(-i, Style.Offset);
      buf.drawLine(this.from + horizontalOffset, middle + horizontalOffset, this.pathColor);
      buf.drawLine(middle + verticalOffset, this.to + verticalOffset, this.pathColor);
    }

    buf.fillRect(Rect(this.from, this.from + Point(Style.PointSize + 1, Style.PointSize + 1)), this.pointColor);
  }
}
