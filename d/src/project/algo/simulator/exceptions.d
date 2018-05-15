module project.algo.simulator.exceptions;

import project.common.exceptions;
import dlangui;

class SimulatorException : UserException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

class InvalidInputException : SimulatorException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

class InvalidAlgorithmException : ImplementationException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

class UninitializedException : SimulatorException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}
