module project.gui.windows.instantiator.exceptions;

import project.common.exceptions : ImplementationException;

class InstantiationException : ImplementationException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}
