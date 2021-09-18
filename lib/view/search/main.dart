import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/widget.dart';
import 'package:music/model.dart';

// import 'demo.dart';

part 'bar.dart';
part 'suggest.dart';
part 'result.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;

  final scrollController = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  String previousQuery ='';


  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    previousQuery = searchQuery;
    Future.microtask(() {
      textController.text = previousQuery;
    });
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';

    // scrollController = ScrollController()..addListener(() {});
    focusNode.addListener(() {
      // if(focusNode.hasFocus) {
      //   textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      // }
      // context.read<Core>().nodeFocus = focusNode.hasFocus;
      core.nodeFocus = focusNode.hasFocus;
    });

    // textController.addListener(() {
    //   // suggestionQuery = textController.text.replaceAll(RegExp(' +'), ' ').trim();
    //   // core.collection.searchQuery = suggestionQuery;
    //   // core.suggestionQuery = suggestionQuery;
    //   core.notify();
    //   // debugPrint('textupdate $suggestionQuery');
    // });
  }

  @override
  dispose() {
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String get searchQuery => core.collection.searchQuery;
  set searchQuery(String str) {
    core.collection.searchQuery = str.replaceAll(RegExp(' +'), ' ').trim();
    core.notify();
  }

  void onClear() {
    textController.clear();
    searchQuery = '';
  }

  void onCancel() {
    // searchQuery = previousQuery;
    // textController.text = searchQuery;
    focusNode.unfocus();
  }


  void onSuggest(String str) {
    // searchQuery = str;
    // Future.microtask(() {
    //   searchQuery = str;
    //   core.suggestionQuery = keyWords(str);
    //   core.suggestionGenerate();
    // });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    // searchQuery = str;
    // previousQuery = str;
    // this.focusNode.unfocus();
    // if (textController.text != str) {
    //   textController.text = str;
    // }

    // Future.microtask(() {
    //   core.definitionGenerate();
    // }).whenComplete(() {
    //   scrollController.animateTo(scrollController.position.minScrollExtent,
    //       curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 800));
    // });

    // Future.delayed(Duration.zero, () {
    //   core.collection.historyUpdate(searchQuery);
    // });
  }
}

class _View extends _State with _Bar, _Suggest, _Result {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      // controller: scrollController,
      child: Selector<Core, bool>(
        selector: (_, e) => e.nodeFocus,
        builder: (BuildContext context, bool focus, Widget? child) => scroll()
      )
    );
  }

  Widget scroll() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
      semanticChildCount: 2,
      slivers: <Widget>[
        bar(),

        if (focusNode.hasFocus)
          suggest()
        else
          result()
        // DemoView()
      ]
    );
  }

}
