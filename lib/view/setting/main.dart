import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:lidea/hive.dart';
// import 'package:flutter/rendering.dart';

// import 'package:lidea/intl.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import 'package:lidea/view/demo/button_style.dart';
import 'package:lidea/view/demo/do_confirm.dart';
import 'package:lidea/view/demo/sliver_grid.dart';
import 'package:lidea/view/demo/sliver_list.dart';
import 'package:lidea/view/demo/text_height.dart';
import 'package:lidea/view/demo/text_translate.dart';
import 'package:lidea/view/demo/text_size.dart';

import '/core/main.dart';
import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  // final GlobalKey<NavigatorState>? navigatorKey;

  static const route = '/settings';
  // static const icon = Icons.settings;
  static const icon = LideaIcon.cog;
  static const name = 'Settings';
  static const description = 'Settings';
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

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();

  Preference get preference => core.preference;

  List<String> get themeName => [
        preference.text.automatic,
        preference.text.light,
        preference.text.dark,
      ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final abc = Localizations.localeOf(context).languageCode;
      debugPrint('core.collection.locale: $abc');
    });
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

  void onClear() {
    Future.microtask(() {});
  }

  void onSearch(String word) {}

  void onDelete(String word) {
    Future.delayed(Duration.zero, () {});
  }
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
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
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
      ],
    );
  }
}
