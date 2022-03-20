part of 'main.dart';

mixin _Bar<T> on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      padding: MediaQuery.of(context).viewPadding,
      heights: const [kToolbarHeight, 100],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: WidgetButton(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: WidgetLabel(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: preference.text.back,
                ),
                duration: const Duration(milliseconds: 300),
                show: hasArguments,
                onPressed: args?.currentState!.maybePop,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: userPhoto(org),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: WidgetButton(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: WidgetLabel(
                  icon: Icons.logout_rounded,
                  message: preference.text.signOut,
                ),
                duration: const Duration(milliseconds: 300),
                enable: authenticate.hasUser,
                onPressed: authenticate.signOut,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget userPhoto(ViewHeaderData org) {
    final user = authenticate.user;
    if (user != null) {
      if (user.photoURL != null) {
        return CircleAvatar(
          // radius: 50,
          radius: (35 * org.snapShrink + 15).toDouble(),
          // backgroundColor: Theme.of(context).backgroundColor,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   user.photoURL!,
              //   fit: BoxFit.cover,
              //   // height: (70 * org.snapShrink + 30).toDouble(),
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return Padding(
                    padding: EdgeInsets.all((7 * org.snapShrink + 3).toDouble()),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: (70 * org.snapShrink).clamp(25, 70).toDouble(),
                    ),
                  );
                },
                imageUrl: user.photoURL!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
      return ClipOval(
        child: Material(
          elevation: 10,
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: .5,
            ),
          ),
          shadowColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.all((7 * org.snapShrink + 3).toDouble()),
            child: Icon(
              Icons.face_retouching_natural_rounded,
              size: (70 * org.snapShrink).clamp(25, 70).toDouble(),
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Material(
        elevation: 30,
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).backgroundColor,
            width: .7,
          ),
        ),
        shadowColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all((7 * org.snapShrink + 3).toDouble()),
          child: Icon(
            Icons.face,
            color: Theme.of(context).hintColor,
            size: (70 * org.snapShrink).clamp(25, 70).toDouble(),
          ),
        ),
      ),
    );
  }
}
