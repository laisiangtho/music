part of 'main.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// WidgetBlockFooter // WidgetBlockMore
class WidgetBlockMore extends StatelessWidget {
  final String more;
  final int total;
  final int count;
  final void Function()? onPressed;

  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;

  const WidgetBlockMore({
    Key? key,
    this.more = '* / ?',
    this.total = 0,
    this.count = 0,
    this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(25, 10, 25, 0),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetBlockTile(
      title: const Text(''),
      trailing: WidgetButton(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        // elevation: 1,
        color: Theme.of(context).shadowColor.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: WidgetLabel(
          label: more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
        ),
        onPressed: onPressed,
      ),
    );
    // return Padding(
    //   padding: padding,
    //   child: Row(
    //     // mainAxisAlignment: mainAxisAlignment,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     // crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       WidgetButton(
    //         // decoration: BoxDecoration(
    //         //   color: Theme.of(context).shadowColor,
    //         //   borderRadius: const BorderRadius.all(Radius.circular(100)),
    //         // ),
    //         color: Theme.of(context).shadowColor,
    //         borderRadius: const BorderRadius.all(Radius.circular(100)),
    //         elevation: 2,
    //         // clipBehavior: Clip.antiAlias,
    //         padding: const EdgeInsets.symmetric(horizontal: 15),
    //         child: WidgetLabel(
    //           // alignment: Alignment.center,
    //           label: more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
    //           labelStyle: Theme.of(context).textTheme.bodyText1,
    //         ),
    //         onPressed: onPressed,
    //       )
    //       // WidgetLabel(
    //       //   alignment: Alignment.centerLeft,
    //       //   label: label,
    //       // ),
    //       // if (more != null)
    //       //   WidgetButton(
    //       //     child: more!,
    //       //     onPressed: onPressed,
    //       //   )
    //     ],
    //   ),
    // );
  }
}

// class SliverSnapshotAwait extends StatelessWidget {
//   const SliverSnapshotAwait({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const SliverToBoxAdapter(
//       // child: const Text('...', textAlign: TextAlign.center,),
//       child: SizedBox(
//         height: 300,
//         width: double.infinity,
//         // child: const Center(
//         //   child: Icon(Icons.more_horiz_outlined),
//         // ),
//       ),
//     );
//   }
// }

// class SliverSnapshotEmpty extends StatelessWidget {
//   const SliverSnapshotEmpty({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return const SliverToBoxAdapter();
//   }
// }

Future<bool?> doConfirmWithWidget({
  required BuildContext context,
  required Widget child,
}) {
  if (Platform.isAndroid) {
    return showDialog<bool?>(
      context: context,
      useSafeArea: true,
      // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
      builder: (BuildContext context) => child,
    );
  }
  return showCupertinoDialog<bool?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => child,
  );
}
