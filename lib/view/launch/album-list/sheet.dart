part of 'main.dart';

class _SheetFilter extends StatefulWidget {
  const _SheetFilter({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetFilterState();
}

class _SheetFilterState extends State<_SheetFilter> {
  late final Core core = context.read<Core>();

  late final AudioBucketType cache = core.collection.cacheBucket;
  late final FilterCommonType filter = core.albumFilter;
  late final List<AudioAlbumType> albumAll = cache.album;

  late List<String> charList;
  late Iterable<AudioCategoryLang> langList;
  late List<AudioCategoryGenre> genreList;

  @override
  void initState() {
    super.initState();
    // Future.microtask((){});
    charList = charListInit();
    langList = cache.langAvailable();
    genreList = cache.category.genre;
  }

  int get total => core.albumList().length;

  List<String> charListInit() {
    return albumAll.map((e) => (e.name.isEmpty ? '#' : e.name)[0].toUpperCase()).toSet().toList()
      ..sort(
        (a, b) => a.compareTo(b),
      );
  }

  bool hasCharList(String value) => filter.character.contains(value);
  void charListSelector(String value) {
    setState(() {
      if (hasCharList(value)) {
        filter.character.remove(value);
      } else {
        filter.character.add(value);
      }
    });
    filter.save();
  }

  bool hasLang(int id) => filter.language.contains(id);
  void langSelector(int value) {
    setState(() {
      if (hasLang(value)) {
        filter.language.remove(value);
      } else {
        filter.language.add(value);
      }
    });
    filter.save();
  }

  // bool hasGender(int id) => filter.gender.contains(id);
  // void genderSelector(int value) {
  //   setState(() {
  //     if (hasGender(value)) {
  //       filter.gender.remove(value);
  //     } else {
  //       filter.gender.add(value);
  //     }
  //   });
  //   filter.save();
  // }

  bool hasGenre(int id) => filter.genre.contains(id);
  void genreSelector(int value) {
    setState(() {
      if (hasGenre(value)) {
        filter.genre.remove(value);
      } else {
        filter.genre.add(value);
      }
    });
    filter.save();
  }

  void resetFilter() {
    setState(() {
      filter.character.clear();
      filter.language.clear();
      // filter.gender.clear();
      filter.genre.clear();
    });
    filter.save();
  }

  bool get hasFilter {
    return filter.character.isNotEmpty || filter.language.isNotEmpty || filter.genre.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: MediaQuery.of(context).padding.top),
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          bar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            sliver: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 240), () => true),
              builder: (_, snap) {
                if (snap.hasData) {
                  return alphaContainer();
                }
                return const SliverToBoxAdapter();
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            sliver: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 270), () => true),
              builder: (_, snap) {
                if (snap.hasData) {
                  return langContainer();
                }
                return const SliverToBoxAdapter();
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            sliver: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 800), () => true),
              builder: (_, snap) {
                if (snap.hasData) {
                  return genreContainer();
                }
                return const SliverToBoxAdapter();
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverList alphaContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: Text.rich(
              TextSpan(
                text: 'Start with',
                children: [
                  const TextSpan(text: ' ('),
                  if (filter.character.isEmpty)
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor,
                      ),
                    )
                  else
                    TextSpan(
                      text: filter.character.take(6).join(', '),
                    ),
                  const TextSpan(text: ')'),
                  if (filter.character.length > 6) const TextSpan(text: '...')
                ],
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: charList.map((item) => alphaButton(item)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget alphaButton(String name) {
    return WidgetButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      margin: const EdgeInsets.all(2),
      child: Text(
        name,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: (filter.character.isNotEmpty)
                ? (hasCharList(name))
                    ? Theme.of(context).highlightColor
                    : null
                : null),
      ),
      onPressed: () => charListSelector(name),
    );
  }

  Widget langContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: Text.rich(
              TextSpan(
                text: 'Language',
                children: [
                  const TextSpan(text: ' ('),
                  if (filter.language.isEmpty)
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor,
                      ),
                    )
                  else
                    TextSpan(
                      text: filter.language
                          .take(7)
                          .map(
                            (e) => cache.langById(e).name.substring(0, 2).toUpperCase(),
                          )
                          .join(', '),
                    ),
                  const TextSpan(text: ')'),
                  if (filter.language.length > 7) const TextSpan(text: '...')
                ],
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(
            child: ListView.separated(
              itemCount: langList.length,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (_, index) {
                return langButton(langList.elementAt(index));
              },
              separatorBuilder: (_, index) {
                return Divider(
                  color: Theme.of(context).shadowColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget langButton(AudioCategoryLang lang) {
    return WidgetButton(
      child: WidgetLabel(
        alignment: Alignment.centerLeft,
        icon: Icons.check_rounded,
        iconColor: (filter.language.isNotEmpty)
            ? hasLang(lang.id)
                ? Theme.of(context).highlightColor
                : null
            : null,
        label: lang.name.toTitleCase(),
        labelPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        softWrap: true,
        maxLines: 3,
      ),
      onPressed: () => langSelector(lang.id),
    );
  }

  Widget genreContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: Text.rich(
              TextSpan(
                text: 'Genre',
                children: [
                  const TextSpan(text: ' ('),
                  if (filter.genre.isEmpty)
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor,
                      ),
                    )
                  else
                    TextSpan(
                      text: filter.genre.take(1).map((e) => cache.genreByIndex(e).name).join(', '),
                    ),
                  const TextSpan(text: ')'),
                  if (filter.genre.length > 1) const TextSpan(text: '...')
                ],
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(
            child: ListView.separated(
              itemCount: genreList.length,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (_, index) {
                return genreButton(index, genreList.elementAt(index));
              },
              separatorBuilder: (_, index) {
                return Divider(
                  color: Theme.of(context).shadowColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget genreButton(int index, AudioCategoryGenre genre) {
    return WidgetButton(
      child: WidgetLabel(
        alignment: Alignment.centerLeft,
        icon: Icons.check_rounded,
        iconColor: (filter.genre.isNotEmpty)
            ? (hasGenre(index))
                ? Theme.of(context).highlightColor
                : null
            : null,
        label: genre.name,
        labelPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        softWrap: true,
        maxLines: 3,
      ),
      onPressed: () => genreSelector(index),
    );
  }

  Widget headers(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      child: Text.rich(
        TextSpan(
          text: name,
          children: [
            const TextSpan(text: ' ('),
            if (filter.character.isEmpty)
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                  fontSize: 15,
                ),
              )
            else
              TextSpan(text: filter.character.take(6).join(', ')),
            const TextSpan(text: ')'),
            if (filter.character.length > 6) const TextSpan(text: '...')
          ],
        ),
        style: const TextStyle(
          fontFamilyFallback: ['Lato'],
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget bar() {
    // return new SliverPersistentHeader(
    //     pinned: true, floating: true, delegate: new ViewHeaderDelegate(_barDecoration));
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: true,
      // reservedPadding: MediaQuery.of(context).padding.top,
      padding: MediaQuery.of(context).viewPadding,
      heights: const [kBottomNavigationBarHeight],
      // heights: const [kToolbarHeight],
      // backgroundColor: Theme.of(context).primaryColor,
      overlapsBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      // overlapsBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      overlapsBorderColor: Theme.of(context).shadowColor.withOpacity(0.4),
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        // print('$kToolbarHeight $kBottomNavigationBarHeight');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Albums',
                  children: [
                    // const TextSpan(text: ' ('),
                    // TextSpan(
                    //   text: total.toString(),
                    //   style: const TextStyle(
                    //     inherit: false,
                    //     fontFamily: 'Lato',
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const TextSpan(text: ')'),
                    TextSpan(
                      text: ' ($total)',
                      style: const TextStyle(
                        // inherit: false,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              WidgetButton(
                child: const Text('Reset'),
                onPressed: hasFilter ? resetFilter : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
