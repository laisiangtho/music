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
  Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;
  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;

  late ScrollController scrollController;
  late TextEditingController textController;
  late FocusNode focusNode;
  // final scrollController = ScrollController();
  // final textController = new TextEditingController();
  // final focusNode = new FocusNode();

  String previousQuery ='';
  bool suggestActive=true;


  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    scrollController = ScrollController();
    textController = new TextEditingController();
    focusNode = new FocusNode();

    previousQuery = searchQuery;
    // Future.microtask(() {
    //   textController.text = previousQuery;
    // });
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';

    // scrollController = ScrollController()..addListener(() {});
    focusNode.addListener(() {
      // if(focusNode.hasFocus) {
      //   textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      // }
      // context.read<Core>().nodeFocus = focusNode.hasFocus;
      // core.nodeFocus = focusNode.hasFocus;
      // nodeFocus = true;
      // setState(() {});
      // Future.microtask(() => setState(() {}));
    });
    // FocusScope.of(context).requestFocus(FocusNode());
    // FocusScope.of(context).unfocus();

    textController.addListener(() {
      // suggestionQuery = textController.text.replaceAll(RegExp(' +'), ' ').trim();
      // core.collection.searchQuery = suggestionQuery;
      // core.suggestionQuery = suggestionQuery;
      // core.notify();
      // debugPrint('textupdate $suggestionQuery');
    });
    Future.delayed(const Duration(milliseconds: 400), (){
      this.focusNode.requestFocus();
      debugPrint('requestFocus');
    });
  }

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
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
    // Future.microtask(
    //   () => this.focusNode.unfocus()
    // ).whenComplete(
    //   () => Future.microtask(
    //     () => Navigator.of(context).maybePop()
    //   )
    // );

    focusNode.unfocus();
    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus?200:0), (){
      Navigator.of(context).pop();
    });
    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus?200:0), (){
    //   focusNode.unfocus();
    // }).whenComplete(
    //   () => Navigator.of(context).pop()
    // );
  }


  void onSuggest(String str) {
    // searchQuery = str;
    Future.microtask(() {
      searchQuery = str;
      // core.suggestionQuery = keyWords(str);
      // core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    setState(() {
      suggestActive = false;
    });
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
      // child: Selector<Core, bool>(
      //   selector: (_, e) => e.nodeFocus,
      //   builder: (BuildContext context, bool focus, Widget? child) => scroll()
      // )
      child: scroll(),
    );
  }

  Widget scroll() {
    print('search scroll');
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
      semanticChildCount: 2,
      slivers: <Widget>[
        bar(),
        // SliverToBoxAdapter(
        //   child: GestureDetector(
        //     onTap: (){
        //       Navigator.pop(context);
        //     },
        //     child: Hero(
        //       tag: 'tests',
        //       child: Text('A', style: TextStyle(fontSize: 20), textAlign: TextAlign.center, )
        //     ),
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 300,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.5),
        //       child: Hero(
        //         tag: 'search',
        //         child: TextFormField(

        //           readOnly: true,
        //           // showCursor: true,
        //           decoration: InputDecoration(
        //             hintText: " ... a word or two",
        //             contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        //           ),
        //           // onTap: ()=>core.navigate(to: '/search'),
        //           onTap: () {
        //             print('?pop');
        //             Navigator.pop(context);
        //           }
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        suggest()
        // testing()
        // Selector<Core, bool>(
        //   selector: (_, e) => e.nodeFocus,
        //   builder: (BuildContext context, bool focus, Widget? child) {
        //     print('focus $focus');
        //     return focus?suggest():result();
        //   }
        // )
        // if (focusNode.hasFocus || suggestActive)
        //   suggest()
        // else
        //   result()
        // DemoView()
      ]
    );
  }

  Widget testing(){
    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (_) {
          return SliverToBoxAdapter(
            child: Text('focusNode ${focusNode.hasFocus}'),
          );
        }
      ),
      onFocusChange: (hasFocus) {
        if(hasFocus) {
          // do stuff
        }
      },
    );
  }

}
