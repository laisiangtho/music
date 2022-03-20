part of 'main.dart';

abstract class _State extends WidgetState<Main> with TickerProviderStateMixin {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final param = args?.param<ViewNavigationArguments>();

  late final formKey = GlobalKey<FormState>();

  late final AnimationController clearController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  ); //..repeat();
  late final Animation<double> clearAnimation = CurvedAnimation(
    parent: clearController,
    curve: Curves.fastOutSlowIn,
  );
  // late final Animation<double> clearAnimation = Tween(
  //   begin: 0.0,
  //   end: 1.0,
  // ).animate(clearController);
  // late final Animation clearAnimations = ColorTween(
  //   begin: Colors.red, end: Colors.green
  // ).animate(clearController);

  @override
  void initState() {
    arguments ??= widget.arguments;
    super.initState();
    onQuery();

    // focusNode.addListener(() {
    //   core.nodeFocus = focusNode.hasFocus;
    // });

    scrollController.addListener(() {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
        Future.microtask(() {
          clearToggle(false);
        });
      }
    });

    // FocusScope.of(context).requestFocus(FocusNode());
    // FocusScope.of(context).unfocus();

    textController.addListener(() {
      clearToggle(textController.text.isNotEmpty);
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    clearController.dispose();
    super.dispose();
  }

  void onQuery() {
    Future.microtask(() {
      // textController.text = core.suggestQuery;
      textController.text = searchQuery;
    });
  }

  void onClear() {
    textController.clear();
    suggestQuery = '';
    core.suggestionGenerate();
  }

  void clearToggle(bool show) {
    if (show) {
      clearController.forward();
    } else {
      clearController.reverse();
    }
  }

  void onCancel() {
    focusNode.unfocus();

    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 300 : 0), () async {
      suggestQuery = searchQuery;
      onQuery();
    }).whenComplete(() {
      if (hasArguments && args!.hasParam) {
        if (args!.canPop) {
          param?.currentState!.maybePop();
        } else {
          args?.currentState!.maybePop();
        }
      } else {
        Navigator.of(context).maybePop(false);
      }
    });
  }

  void onSuggest(String ord) {
    // suggestQuery = str;
    // Future.microtask(() {
    //   core.suggestionGenerate();
    // });
    suggestQuery = ord;

    if (textController.text != ord) {
      textController.text = ord;
      if (focusNode.hasFocus == false) {
        Future.delayed(const Duration(milliseconds: 300), () {
          focusNode.requestFocus();
        });
      }
    }
    Future.microtask(() {
      core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String ord) {
    suggestQuery = ord;
    searchQuery = suggestQuery;

    if (focusNode.hasFocus) {
      Future.microtask(() {
        focusNode.unfocus();
      });
    }
    Future.microtask(() {
      core.conclusionGenerate();
    });
    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      args?.currentState!.pushReplacementNamed('/search-result');
    });
  }

  bool onDelete(String ord) => collection.recentSearchDelete(ord);
}
