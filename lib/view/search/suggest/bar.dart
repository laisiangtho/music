part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final innerBoxIsScrolled = constraints.scrollOffset > 0;
        // constraints.viewportMainAxisExtent.abs
        return ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          // reservedPadding: MediaQuery.of(context).padding.top,
          padding: MediaQuery.of(context).viewPadding,
          heights: const [kBottomNavigationBarHeight],
          overlapsBackgroundColor: Theme.of(context).primaryColor,
          overlapsBorderColor: Theme.of(context).shadowColor,
          // overlapsForce:focusNode.hasFocus,
          // overlapsForce:core.nodeFocus,
          overlapsForce: innerBoxIsScrolled,
          // borderRadius: Radius.elliptical(20, 5),
          builder: (BuildContext context, ViewHeaderData org) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: _barForm(),
                  ),
                ),
                WidgetButton(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  duration: const Duration(milliseconds: 500),
                  onPressed: onCancel,
                  child: WidgetLabel(
                    label: preference.text.cancel,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _barForm() {
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      autofocus: false,
      // enabled: true,
      // enableInteractiveSelection: true,
      // enableSuggestions: true,
      maxLines: 1,
      // strutStyle: const StrutStyle(height: 1.3),
      decoration: InputDecoration(
        prefixIcon: const Icon(LideaIcon.find),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: clearAnimation,
              child: Semantics(
                enabled: true,
                label: preference.text.clear,
                child: WidgetButton(
                  onPressed: onClear,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                    semanticLabel: "input",
                  ),
                ),
              ),
            ),
          ],
        ),
        // hintText: translate.aWordOrTwo,
        fillColor: Theme.of(context)
            .inputDecorationTheme
            .fillColor!
            .withOpacity(focusNode.hasFocus ? 0.6 : 0.4),
      ),
    );
  }
}
