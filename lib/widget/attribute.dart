part of 'main.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:music/core.dart';
// import 'package:music/icon.dart';
// import 'package:music/model.dart';

// each page
class ButtonWithLabelAttribute extends StatelessWidget {
  const ButtonWithLabelAttribute({
    Key? key,
    this.icon = Icons.arrow_back_ios_new,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.onPressed,
    this.label = 'Back',
  }) : super(key: key);

  final String? label;
  final IconData icon;
  final Alignment alignment;
  final EdgeInsets padding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      // color: Theme.of(context).chipTheme.selectedColor,
      // color: Theme.of(context).primaryColor,
      // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      minSize: 40,
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.fade,
        // strutStyle: const StrutStyle(height: 1.3),
        text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.0, fontSize: 19),
          // style: TextStyle(height: 1.0, fontSize: 19),
          children: <InlineSpan>[
            WidgetSpan(
              child: Icon(icon, size: 22),
            ),
            TextSpan(
              text: label,
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class LabelAttribute extends StatelessWidget {
  const LabelAttribute({
    Key? key,
    this.icon,
    this.label,
    this.overflow = TextOverflow.fade,
    this.iconLeft = true,
    this.softWrap = false,
  }) : super(key: key);

  final String? label;
  final IconData? icon;
  final bool iconLeft;
  final bool softWrap;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return RichText(
      key: key,
      // maxLines: 1,
      softWrap: softWrap,
      overflow: overflow,
      textAlign: TextAlign.center,
      strutStyle: const StrutStyle(height: 1.5),
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.25, fontSize: 19),
        // style: TextStyle(height: 1.0, fontSize: 19),
        children: <InlineSpan>[
          if (icon != null && iconLeft == true)
            WidgetSpan(
              child: Icon(icon, size: 25),
              alignment: PlaceholderAlignment.middle,
            ),
          if (label != null) TextSpan(text: label),
          if (icon != null && iconLeft == false)
            WidgetSpan(
              child: Icon(icon, size: 22),
            ),
        ],
      ),
    );
  }
}

// each page default is search
class ButtonAttribute extends StatelessWidget {
  const ButtonAttribute({
    Key? key,
    this.icon = LideaIcon.search,
    this.alignment = Alignment.center,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Alignment alignment;

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      // color: Theme.of(context).chipTheme.selectedColor,
      // color: Theme.of(context).primaryColor,
      // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.zero,
      alignment: alignment,
      minSize: 40,
      child: Icon(icon, size: 22),
      onPressed: onPressed,
    );
  }
}

// each page title
class PageAttribute extends StatelessWidget {
  const PageAttribute({Key? key, required this.label, this.fontSize = 19}) : super(key: key);

  final double? fontSize;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.3, fontSize: fontSize),
      ),
    );
  }
}

// track title, album name, artist name
class TitleAttribute extends StatelessWidget {
  const TitleAttribute({
    Key? key,
    required this.text,
    this.aka,
  }) : super(key: key);

  final String text;
  final String? aka;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          if (aka != null && aka!.isNotEmpty)
            Text.rich(
              TextSpan(
                text: 'aka ',
                children: [
                  TextSpan(
                    text: '($aka)',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            )
        ],
      ),
      /*
      child: RichText(
        textAlign: TextAlign.center,
        // strutStyle: const StrutStyle(height: 1.9),
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.headline1,
          children: <TextSpan>[
            if (aka != null && aka!.isNotEmpty)
              TextSpan(
                text: '\n($aka)',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  // height: 1.3,
                  // fontSize: 25,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Theme.of(context).shadowColor,
                      offset: const Offset(1.0, 0.0),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      */
    );
  }
}

// album year, track year
class YearWrap extends StatelessWidget {
  const YearWrap({Key? key, required this.year}) : super(key: key);

  final List<String> year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        textDirection: TextDirection.ltr,
        children: year
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Text(
                  e,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontFamily: 'Lato',
                        fontSize: 15,
                      ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// album year, track year
class YearAttribute extends StatelessWidget {
  const YearAttribute({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    // return Text(text,key: key,style: Theme.of(context).textTheme.bodyText1);
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        // style: Theme.of(context).textTheme.caption!.copyWith(
        //   height: 1.0
        // ),
        style: const TextStyle(fontSize: 14),
        strutStyle: const StrutStyle(height: 1.0),
      ),
    );
  }
}

// album genre, track genre
class GenreWrap extends StatelessWidget {
  const GenreWrap({Key? key, required this.genre}) : super(key: key);

  final List<String> genre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(0),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        textDirection: TextDirection.ltr,
        children: genre
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(3),
                child: GenreAttribute(
                  text: e.toString(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// album genre, track genre
class GenreAttribute extends StatelessWidget {
  const GenreAttribute({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, key: key, style: Theme.of(context).textTheme.bodyText1);
  }
}

// album genre, track genre
class StaticBadgeAttribute extends StatelessWidget {
  const StaticBadgeAttribute({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).disabledColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              label,
              // style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w600),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontFamily: 'Lato',
                    fontSize: 15,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// album-info, artist-info
class PlayAllAttribute extends StatelessWidget {
  const PlayAllAttribute({Key? key, this.onPressed, this.label = 'Play all'}) : super(key: key);

  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   key: key,
    //   padding: const EdgeInsets.symmetric(vertical: 20),
    //   child: CupertinoButton(
    //     child: Text(
    //       label,
    //       style: Theme.of(context).textTheme.bodyText1,
    //     ),
    //     borderRadius: const BorderRadius.all(Radius.circular(100)),
    //     // color: Theme.of(context).buttonColor,
    //     onPressed: onPressed,
    //   ),
    // );
    return WidgetButton(
      // elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 20),
      borderRadius: BorderRadius.circular(100),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
      color: Theme.of(context).highlightColor,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10), color: Colors.amber,
      //   // border:BoxBorder()
      // ),
      // textStyle: TextStyle(
      //   color: Theme.of(context).primaryColor,
      // ),
      textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
      child: Text(
        label,
        // style: TextStyle(
        //   color: Theme.of(context).primaryColor,
        // ),
      ),
      onPressed: onPressed,
    );
  }
}
