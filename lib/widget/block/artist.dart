import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/intl.dart' as intl;

import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/model.dart';

import 'common.dart';

part 'artistItem.dart';

// NOTE: view -> artist-list
class ArtistList extends StatefulWidget {
  const ArtistList({ Key? key, required this.artists, this.controller, this.limit:17}) : super(key: key);

  final Iterable<AudioArtistType> artists;
  final ScrollController? controller;
  final int limit;

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  late Core core;

  Iterable<AudioArtistType> get artist => widget.artists;

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
    if (artist.length == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      key: widget.key,
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: new SliverList(
        delegate: SliverChildBuilderDelegate(
          // (BuildContext context, int index) => ArtistListItem(core: core, artist: artist.elementAt(index), index: index,),
          (BuildContext context, int index) {
            return new FutureBuilder<bool>(
              // future: Future.microtask(() => true),
              future: new Future.delayed(const Duration(milliseconds: 320), ()=>true),
              builder: (_, snap){
                if (snap.hasData == false) return const ArtistListItemHolder();
                return ArtistListItem(core: core, artist: artist.elementAt(index));
                // return const ArtistListItemHolder();
              }
            );
          },
          childCount: artist.length
        )
      )
    );
  }
}

// NOTE: view -> home -> album-info -> aritst-info
class ArtistWrap extends StatefulWidget {
  const ArtistWrap({ Key? key, required this.artists, this.controller, this.limit:17, this.heading, this.routePush:true}) : super(key: key);

  final Iterable<int> artists;
  final ScrollController? controller;
  final int limit;
  final String? heading;
  final bool routePush;

  @override
  _ArtistWrapState createState() => _ArtistWrapState();
}

class _ArtistWrapState extends State<ArtistWrap> {

  AudioBucketType get cache => core.collection.cacheBucket;

  late Core core;

  int _page = 0;
  int _take = 0;
  int get _limit => widget.limit;

  ScrollController get controller => widget.controller!;
  bool get hasController => widget.controller != null;

  List<int> get artistAll => widget.artists.toList();
  final List<int> artist = [];

  int get total => artistAll.length;
  int get count => artist.length;
  bool get _hasMore => _take < total;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    _take = min(_limit, total);
    artist.addAll(artistAll.getRange(_page, _take));
    if (hasController){
      controller..addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (hasController){
      controller..removeListener(_scrollListener);
    }
  }

  void _scrollListener() {
    if (_hasMore && controller.position.extentAfter < 50) {
      loadMore();
    }
  }

  void loadMore() {
    if (_hasMore){
      _page = _page + _limit;
      _take = min(_take + _limit, total);
      setState(() {
        artist.addAll(artistAll.getRange(_page, _take));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: new FutureBuilder(
        future: Future.microtask(() => true),
        builder: (_, snap){
          if (snap.hasData == false) return const SliverSnapshotAwait();
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                // if (widget.heading != null)Text(widget.heading!,style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),
                if (widget.heading != null)Text(widget.heading!,style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    textDirection: TextDirection.ltr,
                    children:List.generate(count+1, (index) {
                      final inRange = index == count;
                      if (inRange) {
                        if (_hasMore){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                            child: ArtistWrapMore(
                              more: 'more * of ?',
                              total: total,
                              count: count,
                              onPressed: _hasMore?loadMore:null
                            ),
                          );
                        }
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                        child: ArtistWrapItem(
                          core: core,
                          routePush:widget.routePush,
                          // artist: artist.elementAt(index),
                          artist: cache.artistById(artist.elementAt(index)),
                        )
                      );
                    })
                  ),
                ),
              ]
            )
          );
        }
      ),
    );
  }
}
