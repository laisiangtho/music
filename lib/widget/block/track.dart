import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lidea/provider.dart';

import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/model.dart';

import 'common.dart';

part 'trackItem.dart';

class TrackList extends StatefulWidget {
  const TrackList({ Key? key, required this.tracks, this.controller, this.limit:17}) : super(key: key);

  final Iterable<AudioMetaType> tracks;
  final ScrollController? controller;
  final int limit;

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late Core core;

  int _page = 0;
  int _take = 0;
  int get _limit => widget.limit;

  ScrollController get controller => widget.controller!;
  bool get hasController => widget.controller != null;

  List<AudioMetaType> get trackAll => widget.tracks.toList();
  final List<AudioMetaType> track = [];

  int get total => trackAll.length;
  int get count => track.length;
  bool get _hasMore => _take < total;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    _take = min(_limit, total);
    track.addAll(trackAll.getRange(_page, _take));
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
        track.addAll(trackAll.getRange(_page, _take));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      key: widget.key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => TrackListItem(core: core, track: track.elementAt(index)),
        childCount: count
      )
    );
    // if (total == 0) return const SliverSnapshotEmpty();
    // return SliverPadding(
    //   key: widget.key,
    //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   sliver: new FutureBuilder(
    //     future: Future.microtask(() => true),
    //     builder: (_, snap){
    //       if (snap.hasData == false) return const SliverSnapshotAwait();
    //       return new SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //           (BuildContext context, int index) => TrackListItem(core: core, track: track.elementAt(index)),
    //           childCount: count
    //         )
    //       );
    //     }
    //   ),
    // );
  }
}


class TrackFlat extends StatefulWidget {
  const TrackFlat({ Key? key, required this.tracks, this.controller, this.limit:17, this.label, this.showMore, this.milliseconds:0}) : super(key: key);

  // final Iterable<AudioMetaType> tracks;
  final Iterable<int> tracks;
  final ScrollController? controller;
  final int limit;
  final String? label;
  final String? showMore;
  final int milliseconds;

  @override
  _TrackFlatState createState() => _TrackFlatState();
}

class _TrackFlatState extends State<TrackFlat> {

  AudioBucketType get cache => core.collection.cacheBucket;

  late Core core;

  int _page = 0;
  int _take = 0;
  int get _limit => widget.limit;

  ScrollController get controller => widget.controller!;
  bool get hasController => widget.controller != null;

  late List<int> trackAll;
  final List<int> track = [];

  int get total => trackAll.length;
  int get count => track.length;
  bool get _hasMore => _take < total;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    trackAll = widget.tracks.toList();

    _take = min(_limit, total);
    track.addAll(trackAll.getRange(_page, _take));
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
        track.addAll(trackAll.getRange(_page, _take));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    if (total == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: new FutureBuilder(
        // future: Future.delayed(Duration(milliseconds: widget.milliseconds), ()=>true),
        future: Future.microtask(() => true),
        builder: (_, snap){
          if (snap.hasData == false) return const SliverSnapshotAwait();
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                if (widget.label != null)BlockHeader(
                  label: widget.label!.replaceFirst('?', total.toString()),
                  // more: widget.more,
                  // onPressed: null
                ),
                ListView.builder(
                  key: const Key('track-list'),
                  padding: const EdgeInsets.all(0),
                  itemCount: count,
                  // semanticChildCount:5,
                  cacheExtent: count*72,
                  itemExtent: 72,
                  shrinkWrap: true,
                  primary: false,
                  // itemBuilder: (context, index) => TrackListItem(core: core, track: track.elementAt(index)),
                  itemBuilder: (context, index) => TrackListItem(core: core, track: cache.meta(track.elementAt(index))),
                ),
                if (widget.showMore != null)BlockFooter(
                  more: widget.showMore!,
                  total: total,
                  count: count,
                  onPressed: _hasMore?loadMore:null
                )
              ]
            )
          );
        }
      ),
    );
    */
    if (total == 0) return const SliverSnapshotEmpty();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            if (widget.label != null)BlockHeader(
              label: widget.label!.replaceFirst('?', total.toString()),
              // more: widget.more,
              // onPressed: null
            ),
            ListView.builder(
              key: const Key('track-list'),
              padding: const EdgeInsets.all(0),
              itemCount: count,
              // semanticChildCount:5,
              cacheExtent: count*72,
              itemExtent: 72,
              shrinkWrap: true,
              primary: false,
              // itemBuilder: (context, index) => TrackListItem(core: core, track: track.elementAt(index)),
              // itemBuilder: (context, index) => TrackListItem(core: core, track: cache.meta(track.elementAt(index))),
              itemBuilder: (context, index) {
                return new FutureBuilder<bool>(
                  // future: Future.microtask(() => true),
                  future: Future.delayed(const Duration(milliseconds: 320), ()=>true),
                  builder: (_, snap){
                    if (snap.hasData == false) return const TrackListItemHolder();
                    return TrackListItem(core: core, track: cache.meta(track.elementAt(index)));
                  }
                );
              },
            ),
            if (widget.showMore != null)BlockFooter(
              more: widget.showMore!,
              total: total,
              count: count,
              onPressed: _hasMore?loadMore:null
            )
          ]
        )
      )
    );
    /*
    if (total == 0) return const SliverSnapshotEmpty();
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
    */
  }
}
