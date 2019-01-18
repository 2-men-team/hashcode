module project.gui.windows.visualizer.path;

/// Implements ride path abstraction

import dlangui;

/// Style configurations
private enum Style {
  LineWidth = 2, // width of ride's path line
  PointSize = 5, // size of ride's start point
  Offset = (Style.PointSize - Style.LineWidth) / 2 + 1 // offset for paths
}

/// Struct to contain Ride's path
package struct RidePath {
  Point from; // start point
  Point to; // end point
  uint pathColor; // color of path lines
  uint pointColor; // color of path start point

  /// Method to draw path on a buffer
  void draw(DrawBuf buf) @system {
    Point middle = Point(this.to.x, this.from.y); // path inflection point

    // draws path lines on a buffer
    // draws several lines to fit Style.LineWidth condition
    foreach (int i; 0 .. Style.LineWidth) {
      Point verticalOffset = Point(0, i + Style.Offset); // get vertical offset
      Point horizontalOffset = Point(-i, Style.Offset); // get horizontal offset
      buf.drawLine(this.from + verticalOffset, middle + verticalOffset, this.pathColor); // draw horizontal line
      buf.drawLine(middle + horizontalOffset, this.to + horizontalOffset, this.pathColor); // draw vertical line
    }

    // draw path point rectangle
    buf.fillRect(Rect(this.from, this.from + Point(Style.PointSize + 1, Style.PointSize + 1)), this.pointColor);
  }
}
