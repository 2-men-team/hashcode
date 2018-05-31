module project.gui.windows.instantiator.exceptions;

/// Implements exceptions used by window instantiator

import project.common.exceptions : ImplementationException;

/// Throwed on instantiation error
class InstantiationException : ImplementationException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}
