part of 'main.dart';

mixin _Bar on _State {

  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating:true,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: [kBottomNavigationBarHeight,40],
      overlapsBackgroundColor:Theme.of(context).primaryColor,
      overlapsBorderColor:Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap){
        return Column(
          children: [
            SizedBox(
              height: kBottomNavigationBarHeight,
              child: _barTitle(context)
            ),
            Opacity(
              opacity: snap.shrink,
              child: SizedBox(
                height: snap.offset,
                width: double.infinity,
                child: _barOptional(context,snap.shrink)
              )
            )
          ]
        );
      }
    );
  }

  Widget _barTitle(BuildContext context) {
    return Stack(
      children: [
        // Align(
        //   alignment: Alignment(-1,0),
        //   child: ButtonWithLabelAttribute(
        //     onPressed: () => Navigator.of(context).pop()
        //   )
        // ),
        TweenAnimationBuilder<Alignment>(
          tween: Tween<Alignment>(begin: const Alignment(-.3,0), end: const Alignment(-1,0)),
          duration: const Duration(milliseconds: 150),
          builder: (BuildContext context, Alignment align, Widget? child) {
            return Align(
              alignment: align,
              child: child
            );
          },
          child: ButtonWithLabelAttribute(
            onPressed: () => Navigator.of(context).pop()
          )
        ),
        Align(
          alignment: const Alignment(0,0),
          child: const PageAttribute(label: 'Album',)
        ),
        Align(
          alignment: const Alignment(1,0),
          child: ButtonWithLabelAttribute(icon: ZaideihIcon.sliders,label: 'Filter', onPressed: showFilter,)
        )
      ]
    );
  }

  // Start with "M, C" in "Myanmar, Mizo" at "*" has (79)
  // Start with (*) in (*) at (*) matched (2074)
  // Artists (2074) begin with (*) in (*)
  // Artists (2074) begin with (*)
  Widget _barOptional(BuildContext context,double stretch) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7*stretch, horizontal: 0),
      child: new ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        children: [
          RichText(
            strutStyle: StrutStyle(
              height: 1*stretch
            ),
            text: TextSpan(
              text: 'Albums ',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                height: 1.2,
                fontWeight: FontWeight.w400,
                fontSize: 18*stretch
              ),
              children: [
                const TextSpan(text: '('),
                TextSpan(
                  text: album.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                const TextSpan(text: ')'),

                if (charFilter.length > 0)
                  const TextSpan(text: ' start with '),
                  TextSpan(
                    text: charFilter.take(6).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),

                if (langFilter.length > 0)
                  const TextSpan(text: ' in '),
                  TextSpan(
                    text: langFilter.map((e) => cache.langById(e).name.substring(0, 2).toUpperCase()).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),

                if (genreFilter.length > 0)
                  const TextSpan(text: ' at '),
                  TextSpan(
                    text: genreFilter.take(1).map((e) => core.collection.cacheBucket.genreByIndex(e).name).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),

                const TextSpan(text: '...'),
              ]
            )
          )
        ]
      )
    );
  }

  void showFilter(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => _ModalSheet(filter: albumFilter),
      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.6),
      isScrollControlled: true,
      elevation: 10,
      useRootNavigator: true,
    )..whenComplete(
      () => Future.delayed(const Duration(milliseconds: 300), () => setState(albumInit))
    );
  }
}