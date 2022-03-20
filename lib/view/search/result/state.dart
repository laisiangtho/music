part of 'main.dart';

abstract class _State extends WidgetState<Main> {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final param = args?.param<ViewNavigationArguments>();

  late final Future<void> initiator = core.conclusionGenerate(init: true);

  @override
  void initState() {
    arguments ??= widget.arguments;
    super.initState();
    onQuery();
  }

  void onUpdate(bool status) {
    if (status) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 200),
          );
        }
      });
      onQuery();
    }
  }

  void onQuery() async {
    Future.microtask(() {
      textController.text = searchQuery;
    });
  }

  // void onSearch(String ord) async {
  //   await core.conclusionGenerate();
  //   onQuery();
  //   onUpdate(core.searchQuery.isNotEmpty);
  // }

  // void onSwitchFavorite() {
  //   core.collection.favoriteSwitch(core.searchQuery);
  //   core.notify();
  // }
}
