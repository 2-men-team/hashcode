module project.common.exceptions;

/// Implements exceptions used in a project

import std.utf : toUTF8;
import dlangui;

/// Base class for all project exceptions
class ProjectException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

/// Implementation depended exception
class ImplementationException : ProjectException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

/// User depended exception
class UserException : ProjectException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg.value.toUTF8, file, line);
  }
}

/// Throwed when invalid value passed
class InvalidValueException : ImplementationException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}
