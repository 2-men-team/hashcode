module project.gui.windows.content.score;

/// Score window content description

import project.gui.windows.instantiator.instantiator;
import dlangui;

BasicWindowInstantiator instantiator;
enum string windowId = "score";
enum string parentId = "main";

/// Window content described in DML language
private enum string GUI = q{
  VerticalLayout {
    backgroundColor: "#D3DAE3"
    margins: 10
    padding: 20
    TextWidget {
      alignment: center
      fontSize: 20px
      textColor: "red"
      text: "Your score is:"
    }
    TextWidget {
      id: scoreText
      alignment: center
      fontSize: 30px
      textColor: "red"
      minWidth: 200px
    }
    VSpacer {}
    Button {
      id: visualizeButton
      text: "Visualize"
      fontSize: 15px
    }
  }
};

/// Handlers assigned to specific widgets
private enum string[][string] GUIHandlers = [
  "visualizeButton": ["project.gui.windows.handlers.score.VisualizeButtonPressed"]
];

/// Module constructor
static this() {
  WindowInitParams params = {
    caption: UIString.fromRaw("Score"d),
    content: GUI,
    handlers: GUIHandlers
  };

  instantiator = new BasicWindowInstantiator(params);
}
