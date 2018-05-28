module project.common.utils;

/// Implements some commonly used utilities

/// Singleton pattern implementation
mixin template Singleton() {
  private static typeof(this) _instance;
  private this() { }

  static @property typeof(this) instance() {
    if (typeof(this)._instance is null) typeof(this)._instance = new typeof(this);
    return typeof(this)._instance;
  }
}

/// Position holder struct
struct Pos {
  int x;
  int y;
}
