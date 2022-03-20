part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final Store store = core.store;

  @override
  void initState() {
    store.init();
    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void onRestore() {
    // await InAppPurchase.instance.restorePurchases().whenComplete(() =>setState);
    store.doRestore().whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restore purchase completed.'),
        ),
      );
    });
  }
}
