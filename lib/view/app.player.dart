part of 'app.dart';

mixin _Player on _State {
  Widget showPlayer(){
    return _PlayerWidget();
  }
}

class _PlayerWidget extends StatefulWidget {
  _PlayerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<_PlayerWidget> with TickerProviderStateMixin {
  bool isDownloading = false;
  String message='';

  late ScrollController scrollController;
  late BuildContext contextDraggable;
  late NotifyViewScroll nav;
  late Core core;
  late Iterable<AudioMetaType> meta;

  final keyParallel = UniqueKey();
  final scaffoldParallel = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    // core = context.watch<Core>();
    // core = Provider.of<Core>(context, listen: true);
    nav = Provider.of<NotifyViewScroll>(context, listen: false);

    _init();
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    audio.player.dispose();
    super.dispose();
  }

  Audio get audio => core.audio;

  Future<void> _init() async {
    // audio.setTmpAudio();
    // await audio.player.setAudioSource(audio.queue);
    // await audio.player.seek(Duration(seconds: 10));
    // await audio.setQueueSailing();
  }

  void onToggle(){
    navigatorController(checkChildSize?1.0:0.0);
    setState(() {
      initialChildSize = checkChildSize?midChildSize:minChildSize;
    });
    DraggableScrollableActuator.reset(contextDraggable);
  }

  // final double shrinkSize = 10.0;
  final double shrinkSize = 15.0;
  // double get height => kBottomNavigationBarHeight-shrinkSize;
  // double get height => kBottomNavigationBarHeight;
  final double height = kBottomNavigationBarHeight;
  final double maxHeight = 140;

  double get heightDevice => MediaQuery.of(context).size.height-shrinkSize;

  double get minChildSize => (height/heightDevice);

  bool get isDefaultSize => initialChildSize <= minChildSize;
  bool get checkChildSize => initialChildSize < midChildSize;
  double get offset => ((initialChildSize-minChildSize)*shrinkSize).toDouble();
  bool get showNavigation => offset <= 0.0;

  // NOTE: update when scroll notify
  double initialChildSize = 0.0;
  final double maxChildSize = 0.91;
  final double midChildSize = 0.5;

  bool _scrollableNotification(DraggableScrollableNotification notification) {
    initialChildSize = notification.extent;
    navigatorController(initialChildSize);
    return true;
  }

  void navigatorController(double childSize){
    double _heightFactor = nav.heightFactor;
    double _delta = offset.clamp(0.0, 1.0);
    double shrink = (1.0 - _delta).toDouble();
    if (childSize > initialChildSize) {
      // debugPrint('up');
      shrink = min(shrink,_heightFactor);
    } else {
      // debugPrint('down');
      shrink = max(shrink,_heightFactor);
    }
    if (_heightFactor > 0.0 || _heightFactor < 1.0) {
      nav.heightFactor = shrink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      key: ValueKey(88698),
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification:_scrollableNotification,
        child: DraggableScrollableSheet(
          // key: ValueKey<double>(initialChildSize),
          key:UniqueKey(),
          expand: false,
          initialChildSize: initialChildSize < minChildSize?minChildSize:initialChildSize,
          // initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (BuildContext _, ScrollController controller) {
            contextDraggable = _;
            scrollController = controller;
            return _scroll(controller);
            // return sheetDecoration(
            //   child: _scroll(controller)
            // );
          }
        ),
      ),
    );
  }

  Widget sheetDecoration({Widget? child}) {
    return Container(
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        // color: Colors.transparent,
        // borderRadius: new BorderRadius.vertical(
        //   top: Radius.circular(100)
        //   // top: Radius.circular(2)
        //   // top: Radius.elliptical(15, 15),
        // ),
        // border: Border.all(color: Colors.blueAccent),
        border: Border(
          top: BorderSide(width: 0.5, color: Theme.of(context).shadowColor),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     // blurRadius: 0.0,
        //     // color: Theme.of(context).shadowColor,
        //     color: Theme.of(context).shadowColor.withOpacity(0.9),
        //     // color: Theme.of(context).backgroundColor.withOpacity(0.6),
        //     blurRadius: 0,
        //     spreadRadius: 0,
        //     offset: Offset(0, -1)
        //   )
        // ]
      ),

      clipBehavior: Clip.hardEdge,
      // margin: EdgeInsets.only(top: 0.5),
      height: height,
      // padding: EdgeInsets.only(top: 0.5),
      child: child
    );

  }

  Widget _scroll(ScrollController controller) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: Colors.transparent,
      backgroundColor: Theme.of(context).primaryColor,
      primary: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: controller,
        // primary: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          new SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: new ViewHeaderDelegate(_bar,maxHeight: maxHeight)
          ),

          PlayInfo(),

          SliverList(
            delegate: SliverChildListDelegate(
              [

                WidgetButton(
                  child: Text('Navigation artist'),
                  onPressed: () => core.navigate(to:'/artist')
                ),
                WidgetButton(
                  child: Text('Navigation album'),
                  onPressed: () => core.navigate(to:'/album')
                ),
                WidgetButton(
                  child: Text('just add: Dam Dal'),
                  onPressed: () => audio.queuefromTrack([3384])
                ),
                WidgetButton(
                  child: Text('just add: AungPan'),
                  onPressed: () => audio.queuefromTrack([3876])

                ),
                // Text()
                WidgetButton(
                  child: Text('Queue an Album'),
                  onPressed: () async{
                    await audio.queuefromAlbum(["406c19550987baa8c368"]);
                  }
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Multi -> '),
                      WidgetButton(
                        child: Text('Download'),
                        onPressed: () async => await audio.trackDownload([89,3384,7]).then(
                          (value) => print('Downloaded')
                        ).catchError((e){
                          print(e);
                        })
                      ),
                      WidgetButton(
                        child: Text('Delete'),
                        onPressed: () async => await audio.trackDelete([89,3384,7]).then(
                          (value) => print('Deleted')
                        ).catchError((e){
                          print(e);
                        })
                      ),
                    ]
                  )
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WidgetButton(
                        child: Text('Check'),
                        onPressed: () async => await audio.trackUrlById(3384).then(
                          (value) => print(value)
                        )
                      ),
                      WidgetButton(
                        child: Text('Download'),
                        onPressed: () async => await audio.trackDownload([3384]).then(
                          (value) => print('Downloaded')
                        ).catchError((e){
                          print(e);
                        })
                      ),
                      WidgetButton(
                        child: Text('Delete'),
                        onPressed: () async => await audio.trackDelete([3384]).then(
                          (value) => print('Deleted')
                        ).catchError((e){
                          print(e);
                        })
                      ),
                      WidgetButton(
                        child: Text('Seed'),
                        onPressed: () async => await audio.queuefromTrack([3384]).then(
                          (value) => print('Seeded')
                        ).catchError((e){
                          print(e);
                        })
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          PlayQueue(core: core)
        ]
      ),
    );
  }

  Widget _bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink) {

    final fHeight = (150*(stretch-0.45)).clamp(0, 40).toDouble();
    final sHeight = (150*(stretch-0.75)).clamp(0, 40).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(
        //   height: height-borderTop,
        //   child: _barPrimary()
        // ),

        sheetDecoration(
          child: _barPrimary(),
        ),

        // buttonTmp(),
        Opacity(
          // opacity: shrink < .3 ? 1.0 : 0.0,
          // opacity: (shrink > .7)?0.0:1.0,
          // opacity: (stretch < .5)?0.0:stretch,
          opacity: 1.0,
          child: SizedBox(
            // height: 40*stretch,
            height: fHeight,
            child: StreamBuilder<AudioPositionType>(
              stream: audio.streamPositionData,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return PlaySeekBar(
                  opacity:(stretch < .7)?0.0:stretch,
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: audio.player.seek,
                );
              },
            )
          )
        ),
        Opacity(
          opacity: (stretch < .8)?0.0:stretch,
          child: SizedBox(
            height: sHeight,
            width: double.infinity,
            child: _barOptional(stretch)
          )
        )
      ],
    );
  }

  Widget _barPrimary() {
    return Row(
      key: ValueKey<String>('btn-action'),
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Expanded(
          flex:1,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: SizedBox(
              key: Key(showNavigation.toString()),
              child: showNavigation?buttonNavigation(
                label:"Home",
                index:0,
                child:Icon(
                  ZaideihIcon.home,
                  size: 22
                )
              ):WidgetButton(
                label: "Minimize panel",
                child: Icon(
                  // ZaideihIcon.info,
                  // Icons.expand_more,
                  checkChildSize?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                  size: 30
                ),
                onPressed: onToggle
              )
            ),
          ),
        ),

        Expanded(
          flex: showNavigation?2:1,
          child: PlayControl(core: core, showNavigation:showNavigation)
        ),

        Expanded(
          flex: 1,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: SizedBox(
              key: Key(showNavigation.toString()),
              child: showNavigation?buttonNavigation(
                label:"Setting",
                index:3,
                child:Icon(
                  ZaideihIcon.cog,
                  size: 22
                )
              ):buttonEditQueueMode()
            ),
          ),
        ),
      ],
    );
  }

  Widget _barOptional(double stretch) {
    double optSize = (70*(stretch-0.7)).clamp(0.0, 25).toDouble();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<LoopMode>(
          stream: audio.player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            List<Widget> icons = [
              Icon(Icons.repeat, color: Colors.grey, size: optSize),
              Icon(Icons.repeat, color: Colors.orange, size: optSize),
              Icon(Icons.repeat_one, color: Colors.orange, size: optSize)
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one
            ];

            final index = cycleModes.indexOf(loopMode);
            return WidgetButton(
              label: "Repeat",
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: icons[index],
              onPressed: () {
                audio.player.setLoopMode(
                  cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length
                  ]
                );
              }
            );
          },
        ),
        WidgetButton(
          label: "Queue",
          child: Text('Queue', style: TextStyle(fontSize: optSize),),
          onPressed: ()=>null,
        ),
        StreamBuilder<bool>(
          stream: audio.player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return WidgetButton(
              label: "Shuffle",
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.shuffle,
                color: shuffleModeEnabled?Colors.orange:Colors.grey,
                size: optSize
              ),
              onPressed: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await audio.player.shuffle();
                }
                await audio.player.setShuffleModeEnabled(enable);
              },
            );
          },
        )
      ],
    );
  }

  Widget buttonNavigation({required String label, required Widget child,required int index}){
    return ValueListenableBuilder<int>(
      valueListenable: NotifyNavigationButton.navigation,
      builder: (_,currentIndex,abc){
        return WidgetButton(
          label: label,
          child: abc!,
          onPressed: currentIndex==index?null:() => NotifyNavigationButton.navigation.value = index
        );
      },
      child: child,
    );
  }

  Widget buttonEditQueueMode(){
    return Consumer<Core>(
      // selector: (_, e) => e.audio.queueCount,
      builder: (BuildContext context, Core e, Widget? child) {
        return WidgetButton(
          label: "Edit Queue",
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            children: <Widget>[
              Icon(
                Icons.playlist_add_check_sharp,
                color: (e.audio.queueCount > 0 && e.audio.queueEditMode)?Colors.orange:(e.audio.queueCount > 0)?Colors.grey:null,
                size: 30
              ),
              if(e.audio.queueCount > 0)new Positioned(
                top: -7.0,
                right: -3.0,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:1,horizontal: 5),
                    decoration: BoxDecoration(
                      color: e.audio.queueEditMode?Colors.orange:Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text(
                      e.audio.queueCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
          onPressed: (e.audio.queueCount>0)?(){
            e.audio.queueEditMode = !e.audio.queueEditMode;
          }:null
        );
      },
      child: Icon(
        Icons.playlist_add_check_sharp,
        size: 30
      )
    );
  }

}
