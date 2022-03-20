import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view/main.dart';
// import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/favorite';
  // static const icon = Icons.assistant;
  static const icon = Icons.loyalty;
  static const name = 'Favorite';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: widget.key,
      body: ViewPage(
        // controller: scrollController,
        // child: body(),
        child: Selector<Core, List<MapEntry<dynamic, FavoriteWordType>>>(
          selector: (_, e) => e.collection.favorites.toList(),
          builder: (BuildContext _, List<MapEntry<dynamic, FavoriteWordType>> items, Widget? __) {
            return body(items);
          },
        ),
      ),
    );
  }

  CustomScrollView body(List<MapEntry<dynamic, FavoriteWordType>> items) {
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        /*
        bar(),
        SliverReorderableList(
          key: reorderableKey,
          itemBuilder: (BuildContext _, int i) => listContainer(i, itemList.elementAt(i)),
          itemCount: itemList.length,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            if (oldIndex == newIndex) return;

            final String item = itemList.removeAt(oldIndex);
            itemList.insert(newIndex, item);

            // NOTE: hiveDB
            // final itemList = box.toMap().values.toList();
            // itemList.insert(newIndex, itemList.removeAt(oldIndex));
            // box.putAll(itemList.asMap());
          },
        ),
        */
        bar(items.isNotEmpty),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('...'),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return listContainer(index, items.elementAt(index));
              },
              childCount: items.length,
            ),
          ),
      ],
    );
  }

  Widget listContainer(int index, MapEntry<dynamic, FavoriteWordType> item) {
    final word = item.value.word;
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) async {
      //   onDelete(index);
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
      // },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            // message: 'Do you want to delete "$word"?',
            message: preference.text.confirmToDelete('this'),
          );
          if (confirmation != null && confirmation) {
            onDelete(word);
            return true;
          }
        }
        return false;
      },
      // Show a red background as the item is swiped away.
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(CupertinoIcons.delete_simple),
      ),
      child: Container(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(0),
        // ),
        // margin: const EdgeInsets.only(bottom: 1, top: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: .3,
              color: Theme.of(context).shadowColor,
            ),
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.call_made),
          // minLeadingWidth: 10,
          title: Text(word),
          // trailing: (item.value.hit > 1)
          //     ? Chip(
          //         avatar: const CircleAvatar(
          //           backgroundColor: Colors.transparent,
          //           child: Icon(Icons.timeline),
          //         ),
          //         label: Text(item.value.hit.toString()),
          //       )
          //     : const SizedBox(),
          // trailing: (item.value.hit > 1)
          //     ? Chip(
          //         backgroundColor: Theme.of(context).backgroundColor,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(7),
          //         ),
          //         avatar: const CircleAvatar(
          //           // backgroundColor: Colors.transparent,
          //           radius: 7,
          //           // child: Icon(
          //           //   Icons.hdr_strong,
          //           //   // color: Theme.of(context).primaryColor,
          //           // ),
          //         ),
          //         label: Text(
          //           item.value.hit.toString(),
          //         ),
          //       )
          //     : const SizedBox(),
          onTap: () => onSearch(word),
        ),
      ),
    );
  }
}
