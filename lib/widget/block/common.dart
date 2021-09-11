import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockHeader extends StatelessWidget {
  const BlockHeader({Key? key, required this.label, this.more, this.onPressed}): super(key: key);

  final String label;
  final String? more;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
      alignment: const Alignment(0,0),
      // height: 25,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Text(label, style: Theme.of(context).textTheme.headline4,)
          ),

          if (more !=null)CupertinoButton(
            minSize: 50,
            padding: const EdgeInsets.all(0),
            child: Text(more!, style: const TextStyle(fontSize: 13),),
            onPressed: onPressed,
          )
        ]
      )
    );
  }
}

class BlockFooter extends StatelessWidget {
  const BlockFooter({Key? key, this.more:'* / ?', this.total:0, this.count:0, this.onPressed}): super(key: key);

  final String more;
  final int total;
  final int count;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(8.0),
      child: CupertinoButton(
        color: Theme.of(context).shadowColor,
        // disabledColor: Colors.red,
        borderRadius: const BorderRadius.all(const Radius.circular(100)),
        minSize: 30,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        child: Text(
          more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
          style: Theme.of(context).textTheme.headline3,
          strutStyle: const StrutStyle(
            height: 1.5
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SliverSnapshotAwait extends StatelessWidget {
  const SliverSnapshotAwait({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      // child: const Text('...', textAlign: TextAlign.center,),
      child: const SizedBox(
        height: 300,
        width: double.infinity,
        // child: const Center(
        //   child: Icon(Icons.more_horiz_outlined),
        // ),
      )
    );
  }
}

class SliverSnapshotEmpty extends StatelessWidget {
  const SliverSnapshotEmpty({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter();
  }
}
