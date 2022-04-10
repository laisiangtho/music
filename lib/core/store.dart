part of data.core;

class Store extends UnitStore {
  late Collection collection;

  Store({required void Function() notify, required this.collection}) : super(notify: notify);

  @override
  Future<void> init() async {
    kProducts = collection.env.products;
    super.init();
  }

  Iterable<PurchasesType> get data => collection.boxOfPurchases.values;

  @override
  MapEntry<dynamic, PurchasesType> purchaseDataExist(String? purchaseId) {
    return collection.boxOfPurchases.entries.firstWhere(
      (e) => e.value.purchaseId == purchaseId,
      orElse: () => MapEntry(null, PurchasesType()),
    );
  }

  @override
  bool purchaseDataDelete(String purchaseId) {
    final notEmpty = super.purchaseDataDelete(purchaseId);
    if (notEmpty) {
      final purchase = purchaseDataExist(purchaseId);
      if (purchase.key != null) {
        collection.boxOfPurchases.box.delete(purchase.key);
        return true;
      }
    }
    return false;
  }

  @override
  Future<int> purchaseDataClear() {
    return collection.boxOfPurchases.box.clear();
  }

  @override
  void purchaseDataInsert(PurchasesType value) {
    collection.boxOfPurchases.box.add(value);
  }

  @override
  bool purchasedCheck(String productId) {
    return !isConsumable(productId) && data.where((o) => o.productId == productId).isNotEmpty;
  }

  /// is item upgradeable?
  // bool isUpgradeable(String productId) {
  //   if (super.purchasedCheck(productId)) {
  //     return data.where((o) => o.productId == productId).isNotEmpty;
  //     // return data.where((o) => o.productId == productId).isEmpty;
  //   }
  //   return false;
  // }

}
