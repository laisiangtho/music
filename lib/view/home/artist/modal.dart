part of 'main.dart';

class _ModalSheet extends StatefulWidget {
  _ModalSheet({
    Key? key,
    required this.filter
  }) : super(key: key);

  final Iterable<AudioArtistType> Function() filter;

  @override
  State<StatefulWidget> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<_ModalSheet> {
  late Core core;
  late List<AudioArtistType> artistAll;

  late List<String> charList;
  late Iterable<AudioLangType> langList;
  late List<AudioGenreType> genreList;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    artistAll = core.collection.cacheBucket.artist;
    // Future.microtask((){});
    charList = charListInit();
    langList = core.collection.cacheBucket.langAvailable();
    genreList = core.collection.cacheBucket.genre;
  }

  List<String> get charFilter => core.artistFilterCharList;
  List<int> get langFilter => core.artistFilterLangList;

  int get total => widget.filter().length;

  List<String> charListInit(){
    return artistAll.map((e) => (e.name.isEmpty?'#':e.name)[0].toUpperCase()).toSet().toList()..sort((a,b)=>a.compareTo(b));
  }

  bool hasCharList(String value) => charFilter.contains(value);

  void charListSelector(String value) {
    setState(() {
      if (hasCharList(value)){
        charFilter.remove(value);
      } else {
        charFilter.add(value);
      }
    });
  }

  bool hasLang(int id) => langFilter.contains(id);
  void langSelector(int value) {
    setState(() {
      if (hasLang(value)){
        langFilter.remove(value);
      } else {
        langFilter.add(value);
      }
    });
  }

  List<int> genreSelected = [];
  bool hasGenre(int id) => genreSelected.contains(id);
  void genreSelector(int value) {
    setState(() {
      if (hasGenre(value)){
        genreSelected.remove(value);
      } else {
        genreSelected.add(value);
      }
    });
  }

  void resetFilter(){
    setState(() {
      charFilter.clear();
      langFilter.clear();
    });
  }

  bool get hasFilter => charFilter.length > 0 || langFilter.length > 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.all(0),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize:0.9,
        builder: (context, scrollController) => CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            bar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 5),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 250), ()=>true),
                builder: (_, snap){
                  if (snap.hasData){
                    return alphaContainer();
                  }
                  return Container();
                }
              )
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 5),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 300), ()=>true),
                builder: (_, snap){
                  if (snap.hasData){
                    return langContainer();
                  }
                  return Container();
                }
              )
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight)
            ),
          ]
        )
      ),
    );
  }

  Widget alphaContainer() {
    return ListBody(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: RichText(
            strutStyle: const StrutStyle(
              height: 1
            ),
            text: TextSpan(
              text: 'Start with',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                height: 0.5
              ),
              children: [
                const TextSpan(
                  text: ' (',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                  )
                ),
                if (charFilter.length == 0)
                  TextSpan(
                    text: ' * ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                      fontSize: 15
                    )
                  )
                else
                  TextSpan(
                    text: charFilter.take(6).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 17
                    ),
                  ),
                const TextSpan(
                  text: ')',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                  )
                ),
                if (charFilter.length > 6)const TextSpan(text: '...')
              ]
            ),
          )
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: charList.map((item) => alphaButton(item)).toList()
        )
      ],
    );
  }

  Widget alphaButton(String name){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: CupertinoButton(
        minSize: 40,
        padding: const EdgeInsets.all(0),
        child: Text(
          name,style: Theme.of(context).textTheme.headline4!.copyWith(
            color: (charFilter.length > 0)?(hasCharList(name))?Theme.of(context).focusColor:null:null
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        onPressed: ()=>charListSelector(name)
      ),
    );
  }

  Widget langContainer() {
    return ListBody(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: RichText(
            strutStyle: const StrutStyle(
              height: 1
            ),
            text: TextSpan(
              text: 'Language',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                height: 0.5
              ),
              children: [
                const TextSpan(
                  text: ' (',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                  )
                ),
                if (langFilter.length == 0)
                  TextSpan(
                    text: ' * ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                      fontSize: 15
                    )
                  )
                else
                  TextSpan(
                    text: langFilter.take(7).map((e) => core.collection.cacheBucket.langById(e).name.substring(0, 2).toUpperCase()).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 17
                    ),
                  ),
                const TextSpan(
                  text: ')',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                  )
                ),
                if (langFilter.length > 7)const TextSpan(text: '...')
              ]
            ),
          )
        ),
        ListView.separated(
          itemCount: langList.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (_, index){
            return langButton(langList.elementAt(index));
          },
          separatorBuilder: (_, index){
            return Divider(
              color: Theme.of(context).shadowColor,
            );
          },
        )
      ],
    );
  }

  Widget langButton(AudioLangType lang) {
    return WidgetButton(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: new BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).hintColor,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 0)
                )
              ]
            ),
            child: Icon(
              Icons.check,
              size: 17,
              // color: (langFilter.length > 0)?(hasLang(lang.id))?null:Theme.of(context).focusColor: null
              color: (langFilter.length > 0)?(hasLang(lang.id))?Theme.of(context).focusColor:null:null
            ),
          ),
          Divider(indent: 15,),
          Text(
            lang.name.toUpperCase(),
            style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).primaryTextTheme.bodyText1!.color
            )
          )
        ],
      ),
      onPressed: ()=>langSelector(lang.id),
    );
  }

  Widget bar() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:true,
      delegate: new ViewHeaderDelegate(_barDecoration)
    );
  }

  Widget _barDecoration(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Theme.of(context).shadowColor.withOpacity(0.7)),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.5),
            blurRadius: 0,
            spreadRadius: 0,
            offset: const Offset(0, 0.5)
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              strutStyle: const StrutStyle(
                height: 1
              ),
              text: TextSpan(
                text: 'Artists',
                style: Theme.of(context).textTheme.headline3!.copyWith(
                  height: 1.4
                ),
                children: [
                  const TextSpan(
                    text: ' ('
                  ),
                  TextSpan(
                    text: total.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const TextSpan(
                    text: ')'
                  ),
                ]
              )
            ),
            WidgetButton(
              child: Text('Reset'),
              onPressed: hasFilter?resetFilter:null,
            )
          ],
        ),
      ),
    );
  }

}
