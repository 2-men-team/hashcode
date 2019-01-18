module project.gui.windows.content;

public static import project.gui.windows.content.main;
public static import project.gui.windows.content.score;
public static import project.gui.windows.content.visualization;

/// Order of window creation
immutable string[3] order = [
  "project.gui.windows.content.main",
  "project.gui.windows.content.score",
  "project.gui.windows.content.visualization"
];
