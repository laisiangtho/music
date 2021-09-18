part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating:false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: [kBottomNavigationBarHeight],
      overlapsBackgroundColor:Theme.of(context).primaryColor,
      overlapsBorderColor:Theme.of(context).shadowColor,
      overlapsForce:focusNode.hasFocus,
      // overlapsForce:true,
      // borderRadius: Radius.elliptical(20, 5),
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 9.5),
          child: _barSearch(focusNode.hasFocus),
        );
        // return Stack(
        //   alignment: const Alignment(0,0),
        //   children: [
        //     if (Navigator.canPop(context)) Positioned(
        //       left: 0,
        //       top: 8,
        //       child: ButtonWithLabelAttribute(
        //         onPressed: ()=>Navigator.of(context).pop(),
        //       ),
        //     ),
        //     // if (Navigator.canPop(context)) Align(
        //     //   alignment: const Alignment(-1,-1),
        //     //   child: ButtonWithLabelAttribute(
        //     //     onPressed: ()=>Navigator.of(context).pop(),
        //     //   )
        //     // ),
        //     Align(
        //       alignment: Alignment.lerp(const Alignment(0,0), const Alignment(0,1), snap.shrink)!,
        //       child: PageAttribute(label: 'Zaideih',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
        //     ),
        //     Positioned(
        //       right: 0,
        //       top: 8,
        //       child: ButtonAttribute()
        //     ),
        //   ]
        // );
      },
    );
  }

  Widget _barSearch(bool innerBoxIsScrolled){
    // BuildContext context,double offset,bool overlaps, double shrink, double stretch
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Builder(builder: (BuildContext context) => _barForm(innerBoxIsScrolled))
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: focusNode.hasFocus?70:0,
          child: focusNode.hasFocus?Semantics(
            enabled: true,
            label: "Cancel",
            child: new CupertinoButton(
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              // minSize: 35.0,
              child:const Text(
                'Cancel',
                semanticsLabel: "search",
                maxLines: 1
              )
            )
          ):null,
        )
      ]
    );
  }

  Widget _barForm(bool innerBoxIsScrolled){
    // BuildContext context, double shrink, double stretch
    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      // autofocus: true,
      enableInteractiveSelection: true,
      enabled: true,
      enableSuggestions: true,
      maxLines: 1,
      style: const TextStyle(
        fontFamily: 'sans-serif',
        // fontSize: (10+(15-10)*stretch),
        fontWeight: FontWeight.w300,
        // height: 1.1,
        // fontSize: 17,
        height: 1.1,
        fontSize: 19,
        // fontSize: 15 + (2*stretch),
        // fontSize: 17 + (2*shrink),
        // fontSize: 20 + (2*shrink),

        // color: Colors.black
        // color: Theme.of(context).colorScheme.primaryVariant
      ),

      decoration: InputDecoration(
        suffixIcon: Selector<Core, bool>(
          selector: (BuildContext _, Core e) => e.nodeFocus && e.collection.searchQuery.isNotEmpty,
          builder: (BuildContext _, bool word, Widget? child) {
            return word?SizedBox.shrink(
              child: Semantics(
                label: "Clear",
                child: CupertinoButton (
                  onPressed: onClear,
                  minSize: 20,
                  padding: const EdgeInsets.all(0),
                  child:const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color:Colors.grey,
                    size: 20,
                    semanticLabel: "input"
                  ),
                )
              )
            ):child!;
          },
          child: const SizedBox(),
        ),
        prefixIcon: const Icon(
          ZaideihIcon.find,
          // color:Theme.of(context).hintColor,
          size: 17
        ),
        hintText: " ... a word or two",
        hintStyle: const TextStyle(color: Colors.grey),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
        // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (7*shrink)),
        // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (10*shrink)),
        // fillColor: Color(0xFFe8e8e8)
        // fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
        // fillColor: focusNode.hasFocus?Theme.of(context).scaffoldBackgroundColor:Theme.of(context).backgroundColor,
        // fillColor: Theme.of(context).backgroundColor.withOpacity(0.1),
      )
    );
  }
}