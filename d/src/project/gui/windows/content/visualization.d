module project.gui.windows.content.visualization;

import project.gui.windows.instantiator.instantiator;
import dlangui;

BasicWindowInstantiator instantiator;
enum string windowId = "visualization";
enum string parentId = "score";

private enum string GUI = q{
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

static this() {
  WindowInitParams params = {
    caption: UIString.fromRaw("Visualization"d),
    content: GUI
  };

  instantiator = new BasicWindowInstantiator(params);
}