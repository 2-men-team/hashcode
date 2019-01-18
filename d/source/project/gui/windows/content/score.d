module project.gui.windows.content.score;

/// Score window content description

import project.gui.windows.instantiator.instantiator;
import dlangui;

const BasicWindowInstantiator instantiator;
enum windowId = "score";
enum parentId = "main";

/// Window content described in DML language
private enum gui = q{
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
private enum guiHandlers = [
  "visualizeButton": ["project.gui.windows.handlers.score.VisualizeButtonPressed"]
];

/// Module constructor
static this() @system {
  const WindowInitParams params = {
    caption: UIString.fromRaw("Score"d),
    content: gui,
    handlers: guiHandlers
  };

  instantiator = new const BasicWindowInstantiator(params);
}
