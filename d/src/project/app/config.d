module project.app.config;

version (WITH_RESOURCES) {
  enum string resources = "resources.list";
}

enum string GUI = q{
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
    /*VSpacer {}
    TextWidget {
      alignment: center
      fontSize: 20px
      textColor: "red"
      text: "score:"
      //visibility: Invisible
    }
    TextWidget {
      alignment: center
      fontSize: 30px
      textColor: "red"
      text: "123"
      //visibility: Invisible
    }*/
  }
};

enum string[][string] GUIHandlers = [
  "proceedButton": ["project.app.handlers.ProceedButtonPressed"],
  "openFileButton": ["project.app.handlers.OpenFileButtonPressed"]
];
