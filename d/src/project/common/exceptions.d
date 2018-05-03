module project.common.exceptions;

import std.utf : toUTF8;
import dlangui;

class ImplementationException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

class UserException : Exception {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg.value.toUTF8, file, line);
  }
}

class InvalidValueException : ImplementationException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}
