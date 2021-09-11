part of 'main.dart';

mixin _Result on _State {

  Widget result(){
    // return Selector<Core,DefinitionType>(
    //   selector: (_, e) => e.collection.cacheDefinition,
    //   builder: (BuildContext context, DefinitionType o, Widget? child) {
    //     if (o.query.isEmpty){
    //       return _resultNoQuery();
    //     } else if (o.raw.length > 0){
    //       return _resultBlock(o);
    //     } else {
    //       return _resultNoMatch();
    //     }
    //   }
    // );
    return _resultTmp();
  }

  // Widget _resultNoQuery(){
  //   return WidgetMessage(
  //     message: 'result: no query',
  //   );
  // }

  // Widget _resultNoMatch(){
  //   return WidgetMessage(
  //     message: 'result: not found',
  //   );
  // }

  // Widget _resultBlock(DefinitionType o){
  //   return new SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       (BuildContext context, int i) => _resultItem(o.raw.elementAt(i)),
  //       childCount: o.raw.length
  //     )
  //   );
  // }

  // Widget _resultItem(Map<String, dynamic> item) {
  //   return Container(
  //     child: Text('working'),
  //   );
  // }

  Widget _resultTmp(){
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => Card(
          child: Text('index $i'),
        ),
        childCount: 50
      )
    );
  }

}
