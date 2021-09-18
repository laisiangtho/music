part of 'main.dart';

mixin _Suggest on _State {

  Widget suggest(){
    return Selector<Core,SuggestionType>(
      selector: (_, e) => e.collection.cacheSuggestion,
      builder: (BuildContext context,SuggestionType o, Widget? child) {
        if (o.query.isEmpty){
          return _suggestNoQuery();
        } else if (o.raw.length > 0){
          return _suggestBlock(o);
        } else {
          return _suggestNoMatch();
        }
      }
    );
  }

  Widget _suggestNoQuery(){
    return WidgetMessage(
      message: 'suggest: no query',
    );
  }

  Widget _suggestNoMatch(){
    return WidgetMessage(
      message: 'suggest: not found',
    );
  }

  Widget _suggestBlock(SuggestionType o){
    return new SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final suggestion = o.raw.elementAt(index);
            String word = suggestion.values.first.toString();
            int hightlight = searchQuery.length < word.length
                ? searchQuery.length
                : word.length;
            return _suggestItem(word, hightlight);
          },
          childCount: o.raw.length
        )
    );
  }

  Widget _suggestItem(String word, int hightlight) {
    return Container(
      child: const Text('working'),
    );
  }
}
