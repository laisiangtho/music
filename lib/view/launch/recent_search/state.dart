part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSearch(String ord) async {
    /*
    // core.navigate(to: '/search/result', routePush: true);
    // core.navigate(to: '/search/result', routePush: true);
    core.searchQuery = word;
    // core.conclusionGenerate().whenComplete(() => core.navigate(to: '/search/result'));
    // core.navigate(to: '/search/result');
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   core.navigate(to: '/search-result');
    // });
    Future.microtask(() {
      core.navigate(to: '/search-result');
    });
    */
    core.searchQuery = ord;
    core.suggestQuery = ord;
    await core.conclusionGenerate();
    Future.microtask(() {
      core.navigate(to: '/search-result');
    }).whenComplete(() async {
      // await core.conclusionGenerate();
    });
  }

  void onDelete(String ord) {
    Future.delayed(Duration.zero, () {
      collection.boxOfRecentSearch.delete(ord);
    }).whenComplete(core.notify);
  }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      // message: 'Do you really want to delete all?',
      message: preference.text.confirmToDelete('all'),
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          collection.boxOfRecentSearch.box.clear().whenComplete(core.notify);
        });
      }
    });
  }
}
