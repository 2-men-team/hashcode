module project.gui.windows.content.main;

import project.gui.windows.instantiator.instantiator;
import dlangui;

BasicWindowInstantiator instantiator;
immutable string windowId = "main";
immutable string parentId = null;

private enum string GUI = q{
  VerticalLayout {
    backgroundColor: "#D3DAE3"
    margins: 10
    padding: 20
    HorizontalLayout {
      TextWidget {
        fontSize: 15px
        text: "Choose file to load:"
      }
      HSpacer {}
      ImageButton {
        drawableId: "fileopen"
        id: openFileButton
      }
      HSpacer {}
      TextWidget {
        id: fileNameWidget
        fontSize: 15px
        fontItalic: true
      }
    }
    VSpacer { minHeight: 5px}
    TextWidget {
      text: "Input data:"
      fontSize: 15px
      alignment: center
    }
    EditBox {
      id: inputEditBox
      fontSize: 15px
      minHeight: 500px
      minWidth: 700px
      showLineNumbers: true
    }
    VSpacer {}
    Button {
      id: proceedButton
      text: "Proceed"
      fontSize: 15px
    }
  }
};

private enum string[][string] GUIHandlers = [
  "proceedButton": ["project.gui.windows.handlers.main.ProceedButtonPressed"],
  "openFileButton": ["project.gui.windows.handlers.main.OpenFileButtonPressed"]
];

static this() {
  WindowInitParams params = {
    caption: UIString.fromRaw("Course work"d),
    content: GUI,
    handlers: GUIHandlers
  };

  instantiator = new BasicWindowInstantiator(params);
}
