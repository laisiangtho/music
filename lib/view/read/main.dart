import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';

import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';
part 'optionlist.dart';
part 'booklist.dart';
part 'chapterlist.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  // final GlobalKey<NavigatorState>? navigatorKey;

  static const route = '/read';
  static const icon = LideaIcon.bookOpen;
  static const name = 'Read';
  static const description = 'Read';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final Core core = context.read<Core>();
  // late final SettingsController settings = context.read<SettingsController>();
  // late final AppLocalizations translate = AppLocalizations.of(context)!;
  late final Authentication authenticate = context.read<Authentication>();
  late final scrollController = ScrollController();

  // final keySheet = GlobalKey();
  final keyBookButton = GlobalKey();
  final keyChapterButton = GlobalKey();
  final keyOptionButton = GlobalKey();

  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();
  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void setFontSize(bool increase) {
    double size = core.collection.fontSize;
    if (increase) {
      size++;
    } else {
      size--;
    }
    setState(() {
      core.collection.fontSize = size.clamp(10.0, 40.0);
    });
  }

  void setBookMark() {
    scrollToIndex(5);
  }

  void scrollToPosition(double? pos) {
    pos ??= scrollController.position.minScrollExtent;
    scrollController.animateTo(pos,
        duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

  Future scrollToIndex(int id, {bool isId = false}) async {
    double scrollTo = 0.0;
    if (id > 0) {
      final offsetList = tmpverse.where(
          // (e) => tmpverse.indexOf(e) < index
          (e) => tmpverse.indexOf(e) < id).map<double>((e) {
        final key = e.keys.first;
        if (key.currentContext != null) {
          final render = key.currentContext!.findRenderObject() as RenderBox;
          return render.size.height;
        }
        return 0.0;
      });
      if (offsetList.isNotEmpty) {
        scrollTo = offsetList.reduce((a, b) => a + b) + scrollTo;
      }
    }

    scrollToPosition(scrollTo);
  }

  late final List<Map<GlobalKey, String>> tmpverse = List.generate(10, (index) {
    return {GlobalKey(): '??? $index'};
  });
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        key: widget.key,
        controller: scrollController,
        child: body(),
      ),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        // signInList(),
        // signInWrap(),
        // const SliverToBoxAdapter(
        //   child: Text('?'),
        // ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _inheritedChapter(tmpverse.elementAt(index));
            },
            childCount: tmpverse.length,
          ),
        )
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.all(10),
        //     // color: Colors.white,

        //     child: DecoratedBox(
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).primaryColor,
        //         borderRadius: const BorderRadius.all(
        //           Radius.elliptical(4, 3),
        //         ),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: _inheritedChapter(),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget _inheritedChapter(Map<GlobalKey, String> verse) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: SelectableText.rich(
          TextSpan(
            // text: 'header\n',
            children: [
              TextSpan(
                text:
                    'လူတိုင်းတွင် ${verse.values.first} လွတ်လပ်စွာ တွေးခေါ် ကြံဆနိုင်ခွင့်၊ လွတ်လပ်စွာ ခံယူရပ်တည်နိုင်ခွင့် နှင့် လွတ်လပ်စွာ Child Builder Delegate 3434',
              ),
            ],
          ),
          // key: Key('${verse.keys.first}'),
          key: verse.keys.first,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          style: TextStyle(
            fontSize: core.collection.fontSize,
          ),
        ),
      ),
    );
  }

  // List<TextSpan> _inheritedVerse() {

  //   return List.generate(10, (index) {
  //     return TextSpan(
  //       text: '\n\n$index\t',
  //       children: [
  //         TextSpan(
  //           text:
  //               '434',
  //         ),
  //       ],
  //     );
  //   });

  //   // return VerseInheritedWidget(
  //   //   key: verse.key,
  //   //   size: core.collection.fontSize,
  //   //   lang: core.scripturePrimary.info.langCode,
  //   //   selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
  //   //   child: WidgetVerse(
  //   //     verse: verse,
  //   //     onPressed: verseSelection,
  //   //   )
  //   // );
  // }
}
