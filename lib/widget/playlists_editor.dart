part of ui.widget;

class PlayListsEditor extends StatefulWidget {
  const PlayListsEditor({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  PlayListsEditorState createState() => PlayListsEditorState();
}

class PlayListsEditorState extends State<PlayListsEditor> {
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  late final Box<LibraryType> box = core.collection.boxOfLibrary.box;

  late LibraryType item;

  bool get isUpdate => widget.index != null;

  @override
  void initState() {
    super.initState();

    item = LibraryType(
      date: DateTime.now(),
      name: '',
      description: '',
      type: 3,
      list: [],
    );
    if (isUpdate) {
      item = box.get(widget.index, defaultValue: item)!;
    }
  }

  void submit() {
    // Navigator.of(context, rootNavigator: true).pop(false)
    // onPressed: () => Navigator.of(context).pop(true),

    if (item.name.isEmpty) {
      return Navigator.of(context).pop(false);
    }
    // LibraryType tpl = LibraryType(
    //   date: DateTime.now(),
    //   name: name,
    //   description: description,
    //   type: 3,
    //   list: [],
    // );

    if (isUpdate) {
      box.get(widget.index, defaultValue: item)!
        ..date = item.date
        ..name = item.name
        ..description = item.description
        ..save();
    } else {
      box.add(item);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid) {}
    // preference.text.addTo(preference.text.playlist(true))
    return AlertDialog(
      // title: Text(preference.language(isUpdate ? 'Update Playlists' : 'Add Playlists')),
      title: Text(
        preference.language(isUpdate
            ? preference.text.updateTo(preference.text.playlist(false))
            : preference.text.addTo(preference.text.playlist(false))),
      ),
      // content: Container(
      //   color: Theme.of(context).scaffoldBackgroundColor,
      //   child: form(),
      // ),
      content: form(),
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      // actionsPadding: EdgeInsets.zero,
      // buttonPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      // actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        WidgetButton(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 7),
          child: Text(
            preference.text.cancel,
            // style: DefaultTextStyle.of(context).style,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        WidgetButton(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 7),
          // Navigator.of(context, rootNavigator: true).pop(false)
          // onPressed: () => Navigator.of(context).pop(true),
          onPressed: submit,
          child: Text(
            preference.text.confirm,
            // style: DefaultTextStyle.of(context).style.copyWith(
            //       color: Theme.of(context).errorColor,
            //     ),
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 13, 12, 0),
                child: TextFormField(
                  initialValue: item.name,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  validator: (text) {
                    if (text!.isNotEmpty) {
                      return "Enter valid name of more then 5 characters!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: preference.text.title(false),
                    floatingLabelStyle: Theme.of(context).textTheme.titleSmall,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.gesture),
                    prefixIconConstraints: BoxConstraints.tight(const Size(25, 25)),
                    filled: false,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (String name) {
                    item.name = name;
                  },
                  // onEditingComplete: () {
                  //     FocusScope.of(context).requestFocus(_nodeEmail);
                  // },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    initialValue: item.description,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: preference.text.description(false),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(LideaIcon.info),
                      prefixIconConstraints: BoxConstraints.tight(const Size(25, 25)),
                      filled: false,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (String description) {
                      item.description = description;
                    },
                    // onEditingComplete: () {
                    //   FocusScope.of(context).requestFocus(_nodeEmail);
                    // },
                    onEditingComplete: submit,
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 15),
          //   child: SizedBox(
          //     height: 40,
          //     child: TextField(
          //       autofocus: true,
          //       // focusNode: _nodePhone,
          //       // maxLength: 10,
          //       keyboardType: TextInputType.text,
          //       decoration: InputDecoration(
          //         // labelText: 'Name',
          //         hintText: 'Name',
          //         contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //         prefixIcon: const Icon(Icons.gesture),
          //         prefixIconConstraints: BoxConstraints.tight(const Size(30, 30)),
          //         fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
          //       ),
          //       textInputAction: TextInputAction.next,
          //       onChanged: (String a) {
          //         name = a;
          //       },
          //       // onEditingComplete: () {
          //       //     FocusScope.of(context).requestFocus(_nodeEmail);
          //       // },
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 15),
          //   child: SizedBox(
          //     height: 60,
          //     child: TextField(
          //       // focusNode: _nodeEmail,
          //       keyboardType: TextInputType.text,
          //       expands: true,
          //       minLines: null,
          //       maxLines: null,
          //       decoration: InputDecoration(
          //         label: const Text('Description'),
          //         // labelText: 'Description',
          //         // labelStyle: const TextStyle(backgroundColor: Colors.red),
          //         // floatingLabelBehavior: FloatingLabelBehavior.always,
          //         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          //         prefixIcon: const Icon(Icons.lightbulb),
          //         prefixIconConstraints: BoxConstraints.tight(const Size(30, 30)),

          //         fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
          //       ),
          //       textInputAction: TextInputAction.done,
          //       onChanged: (String b) {
          //         description = b;
          //       },
          //       onEditingComplete: () {
          //         debugPrint('onEditingComplete');
          //       },
          //       // onEditingComplete: () {
          //       //     FocusScope.of(context).requestFocus(_nodeFullname);
          //       // },
          //       onTap: () {
          //         // Future.delayed(Duration(milliseconds: 500), () {
          //         //     _scrollController.animateTo(
          //         //         _scrollController.position.maxScrollExtent,
          //         //         duration: Duration(milliseconds: 200),
          //         //         curve: Curves.ease);
          //         // });
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
