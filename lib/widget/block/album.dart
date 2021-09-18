import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lidea/provider.dart';
import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/model.dart';

import 'common.dart';

part 'albumItem.dart';
// AlbumBoard AlbumFlat AlbumListItem AlbumPickItem

// NOTE: view -> album-list
class AlbumList extends StatefulWidget {
  const AlbumList({ Key? key, required this.albums, this.controller, this.limit:51}) : super(key: key);

  final Iterable<AudioAlbumType> albums;
  final ScrollController? controller;
  final int limit;

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  late Core core;

  Iterable<AudioAlbumType> get album => widget.albums;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (album.length == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      key: widget.key,
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          mainAxisExtent: 240
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return new FutureBuilder(
              // future: Future.microtask(() => true),
              future: Future.delayed(const Duration(milliseconds:320), ()=>true),
              builder: (_, snap){
                if (snap.hasData == false) return const AlbumListItemHolder();
                return AlbumListItem(core: core, album: album.elementAt(index),);
              }
            );
          },
          childCount: album.length,
          semanticIndexOffset: 300
        ),
      )
    );
  }
}

// NOTE: view -> artist-info
class AlbumBoard extends StatefulWidget {
  const AlbumBoard({ Key? key, required this.albums, this.controller, this.limit:10}) : super(key: key);

  final Iterable<AudioAlbumType> albums;
  final ScrollController? controller;
  final int limit;

  @override
  _AlbumBoardState createState() => _AlbumBoardState();
}

class _AlbumBoardState extends State<AlbumBoard> {
  late Core core;

  Iterable<AudioAlbumType> get album => widget.albums;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (album.length == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      key: widget.key,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300.0,
          mainAxisExtent:170,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return new FutureBuilder(
              // future: Future.microtask(() => true),
              future: Future.delayed(const Duration(milliseconds:320), ()=>true),
              builder: (_, snap){
                if (snap.hasData == false) return const AlbumPickItemHolder();
                return AlbumPickItem(core: core, album: album.elementAt(index),);
                // return const AlbumPickItemHolder();
              }
            );
          },
          childCount: album.length,
          // semanticIndexOffset: 300
        ),
      )
    );
  }
}

// NOTE: view -> home
class AlbumFlat extends StatelessWidget {
  const AlbumFlat({Key? key, required this.core, required this.album, this.label, this.showAll:'More'}): super(key: key);

  final Core core;
  final Iterable<AudioAlbumType> album;
  final String? label;
  final String showAll;

  int get total => album.length;
  // AudioBucketType get cache => core.collection.cacheBucket;

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      sliver: new FutureBuilder(
        // future: Future.delayed(Duration(milliseconds: widget.milliseconds), ()=>true),
        future: Future.microtask(() => true),
        builder: (_, snap){
          if (snap.hasData == false) return const SliverSnapshotAwait();
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                if (label != null)BlockHeader(
                  label: label!.replaceFirst('?', total.toString()),
                  more: showAll,
                  onPressed: ()=>core.navigate(to: '/album')
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.all(0),
                      // padding: EdgeInsets.symmetric(vertical: 7),
                      itemCount: total,
                      // shrinkWrap: true,
                      // itemBuilder: (context, index) => AlbumPickItem(core: core, album: album.elementAt(index))
                      itemBuilder: (context, index) {
                        return new FutureBuilder(
                          // future: Future.microtask(() => true),
                          future: Future.delayed(const Duration(milliseconds:320), ()=>true),
                          builder: (_, snap){
                            if (snap.hasData == false) return const AlbumPickItemHolder();
                            return AlbumPickItem(core: core, album: album.elementAt(index),);
                            // return const AlbumPickItemHolder();
                          }
                        );
                      }
                    ),
                  ),
                )
              ]
            )
          );
        }
      ),
    );
    /*
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        key: key,
        children: [
          if (label != null)BlockHeader(
            label: label!.replaceFirst('?', total.toString()),
            more: showAll,
            onPressed: ()=>core.navigate(to: '/album')
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(0),
                // padding: EdgeInsets.symmetric(vertical: 7),
                itemCount: total,
                // shrinkWrap: true,
                itemBuilder: (context, index) => AlbumPickItem(core: core, album: album.elementAt(index))
              ),
            ),
          )
        ],
      ),
    );
    */
  }
}
