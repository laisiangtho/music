import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/cached_network_image.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/extension.dart';

import '/core/main.dart';
import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;

  static const route = '/user';
  static const icon = Icons.person;
  static const name = 'User';
  static const description = 'user';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        controller: scrollController,
        child: Consumer<Authentication>(
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext context, Authentication o, Widget? child) {
    return CustomScrollView(
      controller: scrollController,
      slivers: sliverWidgets(),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 100],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),

      if (authenticate.hasUser)
        WidgetBlockSection(
          headerTitle: WidgetLabel(
            alignment: Alignment.center,
            label: authenticate.user?.displayName,
          ),
          child: profileContainer(),
        )
      else
        WidgetBlockSection(
          headerTitle: WidgetLabel(
            alignment: Alignment.center,
            label: preference.text.wouldYouLiketoSignIn,
          ),
          child: signInContainer(),
        ),

      WidgetBlockSection(
        headerTitle: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.themeMode,
        ),
        child: Card(
          child: themeContainer(),
        ),
      ),

      WidgetBlockSection(
        headerTitle: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.locale,
        ),
        child: Card(
          child: localeContainer(),
        ),
      ),

      // Selector<ViewScrollNotify, double>(
      //   selector: (_, e) => e.bottomPadding,
      //   builder: (context, bottomPadding, child) {
      //     return SliverPadding(
      //       padding: EdgeInsets.only(bottom: bottomPadding),
      //       sliver: child,
      //     );
      //   },
      // ),
    ];
  }

  Widget profile() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          const Text('signed in'),
        ],
      ),
    );
  }

  List<Widget> signInList() {
    return [
      signInDecoration(
        icon: LideaIcon.google,
        label: 'Google',
        onPressed: authenticate.signInWithGoogle,
      ),
      // signInDecoration(
      //   icon: LideaIcon.facebook,
      //   label: 'Facebook',
      //   onPressed: authenticate.signInWithFacebook,
      // ),
      signInDecoration(
        icon: LideaIcon.apple,
        label: 'Apple',
        onPressed: authenticate.signInWithApple,
      ),
      // signInDecoration(
      //   icon: LideaIcon.microsoft,
      //   label: 'Microsoft',
      //   onPressed: null,
      // ),
      // signInDecoration(
      //   icon: LideaIcon.github,
      //   label: 'GitHub',
      //   onPressed: null,
      // ),
      // const OutlinedButton(
      //   child: WidgetLabel(
      //     icon: LideaIcon.github,
      //     iconSize: 17,
      //     label: 'GitHub',
      //   ),
      //   onPressed: null,
      // ),
    ];
  }

  Widget signInDecoration({IconData? icon, String? label, void Function()? onPressed}) {
    return WidgetButton(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Theme.of(context).shadowColor,
          width: 1,
        ),
      ),
      child: WidgetLabel(
        icon: icon,
        iconColor: Theme.of(context).highlightColor,
        iconSize: 20,
        label: label,
        labelStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: onPressed,
    );
  }

  Widget signInContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: signInList(),
      ),
    );
  }

  Widget profileContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        children: [
          WidgetLabel(
            label: authenticate.user!.email!,
            // label: 'khensolomon@gmail.com',
            labelStyle: Theme.of(context).textTheme.labelSmall,
          ),
          // Text(
          //   authenticate.id,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }

  Widget themeContainer() {
    return Selector<Preference, ThemeMode>(
      selector: (_, e) => e.themeMode,
      builder: (BuildContext context, ThemeMode theme, Widget? child) {
        return ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ThemeMode.values.length,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemBuilder: (_, index) {
            ThemeMode mode = ThemeMode.values[index];
            bool active = theme == mode;
            return WidgetButton(
              child: WidgetLabel(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                alignment: Alignment.centerLeft,
                icon: Icons.check_rounded,
                iconColor: active ? null : Theme.of(context).focusColor,
                label: themeName[index],
                labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                maxLines: 3,
              ),
              onPressed: () {
                if (!active) {
                  preference.updateThemeMode(mode);
                }
              },
            );
          },
          separatorBuilder: (_, index) {
            return const Divider();
          },
        );
      },
    );
  }

  Widget localeContainer() {
    return Selector<Preference, ThemeMode>(
      selector: (_, e) => e.themeMode,
      builder: (BuildContext context, ThemeMode theme, Widget? child) {
        return ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: preference.supportedLocales.length,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemBuilder: (_, index) {
            final locale = preference.supportedLocales[index];

            Locale localeCurrent = Localizations.localeOf(context);
            // final String localeName = Intl.canonicalizedLocale(lang.languageCode);
            final String localeName = Locale(locale.languageCode).nativeName;
            final bool active = localeCurrent.languageCode == locale.languageCode;

            return WidgetButton(
              child: WidgetLabel(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                alignment: Alignment.centerLeft,
                icon: Icons.check_rounded,
                iconColor: active ? null : Theme.of(context).focusColor,
                label: localeName,
                labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                maxLines: 3,
              ),
              onPressed: () {
                preference.updateLocale(locale);
              },
            );
          },
          separatorBuilder: (_, index) {
            return const Divider();
          },
        );
      },
    );
  }
}
