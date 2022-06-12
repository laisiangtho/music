import 'package:flutter/material.dart';

// import 'package:lidea/intl.dart';

// import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import 'package:lidea/view/demo/button_style.dart';
import 'package:lidea/view/demo/do_confirm.dart';
import 'package:lidea/view/demo/sliver_grid.dart';
import 'package:lidea/view/demo/sliver_list.dart';
import 'package:lidea/view/demo/text_height.dart';
import 'package:lidea/view/demo/text_translate.dart';
import 'package:lidea/view/demo/text_size.dart';

// import '/core/main.dart';
import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;

  static const route = '/settings';
  static const icon = LideaIcon.cog;
  static const name = 'Settings';
  static const description = 'Settings';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends MainState with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      bar(),
      SliverPadding(
        padding: const EdgeInsets.all(10),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              WidgetButton(
                onPressed: () async {},
                child: const WidgetLabel(
                  icon: LideaIcon.google,
                  iconSize: 17,
                  label: 'OB with WidgetLabel',
                  // materialTapTargetSize: MaterialTapTargetSize.padded,
                  softWrap: true,
                ),
              ),
              WidgetButton(
                // elevation: 1,
                // color: Colors.red,
                // // borderRadius: BorderRadius.circular(10),
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                // padding: const EdgeInsets.all(10),
                onPressed: () async {},
                child: const Text(
                  'OB with Text',
                ),
              ),
              WidgetButton(
                elevation: 1,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).primaryColor,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10), color: Colors.amber,
                //   // border:BoxBorder()
                // ),
                onPressed: () async {},
                child: const Text(
                  'OB with Text',
                ),
              ),
              Column(
                // alignment: WrapAlignment.center,
                // spacing: 10,
                // runSpacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetButton(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).shadowColor,
                        width: 1,
                      ),
                    ),
                    onPressed: () async {},
                    child: const Text(
                      'OB with Text',
                    ),
                  ),
                  WidgetButton(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).shadowColor,
                        width: 1,
                      ),
                    ),
                    onPressed: () async {},
                    child: const WidgetLabel(
                      icon: LideaIcon.google,
                      iconSize: 17,
                      label: 'OB with WidgetLabel',
                      // materialTapTargetSize: MaterialTapTargetSize.padded,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      DemoTextTranslate(
        itemCount: preference.text.itemCount,
        itemCountNumber: preference.text.itemCountNumber,
        formatDate: preference.text.formatDate,
        confirmToDelete: preference.text.confirmToDelete,
        formatCurrency: preference.text.formatCurrency,
      ),
      const DemoButtonStyle(),
      const DemoDoConfirm(),
      const DemoSliverGrid(),
      const DemoSliverList(),
      const DemoTextHeight(),
      DemoTextSize(
        headline: preference.text.headline(true),
        subtitle: preference.text.subtitle(true),
        text: preference.text.text(true),
        caption: preference.text.caption(true),
        button: preference.text.button(true),
        overline: preference.text.overline(true),
      ),
    ];
  }
}
