import "package:hive/hive.dart";
import "package:lidea/extension.dart";
import "package:lidea/notify.dart";

part 'adapter/setting.dart';
part 'adapter/purchase.dart';
part 'adapter/history.dart';

part 'purchase.dart';
part 'history.dart';
part 'setting.dart';
part "collection.dart";
part "audio.dart";
// part 'notify.md';

// NOTE: only type
class EnvironmentType {
  String name;
  String description;
  String package;
  String version;
  String buildNumber;
  String url;

  String settingName;
  String settingKey;
  SettingType setting;

  TokenType token;

  List<APIType> apis;
  List<ProductsType> products;

  EnvironmentType({
    required this.name,
    required this.description,
    required this.package,
    required this.version,
    required this.buildNumber,
    required this.url,
    required this.settingName,
    required this.settingKey,
    required this.setting,
    required this.apis,
    required this.token,
    required this.products,
  });

  factory EnvironmentType.fromJSON(Map<String, dynamic> o) {
    return EnvironmentType(
      name: o["name"]??"MyOrdbok",
      description: o["description"]??"A comprehensive Myanmar online dictionary",
      package: o["package"]??"",
      version: o["version"]??"1.0.0",
      buildNumber: o["buildNumber"]??"0",
      url: o["url"]??"",
      settingName: o["settingName"]??"0",
      settingKey: o["settingKey"]??"0",
      setting: SettingType.fromJSON(o["setting"]),
      apis: o['api'].map<APIType>((e) => APIType.fromJSON(e,o["url"])).toList(),
      token: TokenType.fromJSON(o["token"]),
      products: o['products'].map<ProductsType>((e) => ProductsType.fromJSON(e)).toList()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "name":name,
      "description":description,
      "package":package,
      "version":version,
      "buildNumber":buildNumber,
      "url":url,
      "settingName":settingName,
      "settingKey":settingKey,
      "setting":setting.toString(),
      "token":token.toString(),
      "apis":apis.map((e)=>e.toJSON()).toList(),
      "products":products.map((e)=>e.toJSON()).toList()
    };
  }

  APIType get bucketAPI => apis.firstWhere((e) => e.uid == 'album');
}

// NOTE: only type, EnvironmentType child
class APIType {
  String uid;
  List<String> src;

  APIType({
    required this.uid,
    required this.src
  });

  factory APIType.fromJSON(Map<String, dynamic> o, String url) {
    return APIType(
      uid: o["uid"] as String,
      src: List.from(
        (o['src']??[]).map<String>(
          (e) => e.toString().gitHack(url: url)
        )
      )
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "uid":uid,
      "src":src.toList()
    };
  }

  // String get url => src.where((e) => Uri.parse(e).isAbsolute).first;
  // String get file => src.where((e) => Uri.parse(e).isAbsolute == false && e.endsWith('json')).first;
  String get archive => src.where((e) => Uri.parse(e).isAbsolute == false && e.endsWith('json')).first.replaceFirst('?', uid);

  String trackCache(int id) => src.where((e) => Uri.parse(e).isAbsolute == false && e.endsWith('mp3')).first.replaceFirst('?', id.toString());
  String trackLive(int id) => src.where((e) => Uri.parse(e).isAbsolute && e.contains('audio')).first.replaceFirst('?', id.toString());
}

// NOTE: only type, EnvironmentType child
class TokenType {
  String key;
  String id;

  TokenType({
    required this.key,
    required this.id
  });

  factory TokenType.fromJSON(Map<String, dynamic> o) {
    return TokenType(
      key: o["key"].toString().bracketsHack(),
      id: o["id"].toString().bracketsHack()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "key":key,
      "id":id
    };
  }

}

// NOTE: only type, EnvironmentType child
class ProductsType {
  String cart;
  String name;
  String type;
  String title;
  String description;

  ProductsType({
    required this.cart,
    required this.name,
    required this.type,
    required this.title,
    required this.description,
  });

  factory ProductsType.fromJSON(Map<String, dynamic> o) {
    return ProductsType(
      cart: o["cart"] as String,
      name: o["name"] as String,
      type: o["type"] as String,
      title: o["title"] as String,
      description: o["description"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "cart":cart,
      "name":name,
      "type":type,
      "title":type,
      "description":type,
    };
  }
}

// NOTE: readonly
class SuggestionType {
  final String query;
  final List<Map<String, Object?>> raw;
  SuggestionType({
    this.query:'',
    this.raw: const []
  });
}

// NOTE: readonly
class DefinitionType {
  final String query;
  final List<Map<String, dynamic>> raw;
  DefinitionType({
    this.query:'',
    this.raw: const []
  });
}

// NOTE: readonly Navigator
class NavigatorArguments {
  final bool canPop;
  final Object? meta;

  const NavigatorArguments({this.canPop:false, this.meta});
}