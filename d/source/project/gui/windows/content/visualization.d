module project.gui.windows.content.visualization;

/// Visualization window content description

import project.gui.windows.instantiator.instantiator;
import dlangui;

const BasicWindowInstantiator instantiator;
enum windowId = "visualization";
enum parentId = "score";

/// Window content described in DML language
private enum gui = q{
  VerticalLayout {
    backgroundColor: "#D3DAE3"
    margins: 10px
    padding: 20px
    Visualizer {
      id: visualizer
      minHeight: 700px
      minWidth: 700px
    }
  }
};

/// Module constructor
static this() @system {
  const WindowInitParams params = {
    caption: UIString.fromRaw("Visualization"d),
    content: gui
  };

  instantiator = new const BasicWindowInstantiator(params);
}
