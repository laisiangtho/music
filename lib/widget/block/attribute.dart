import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:music/core.dart';
import 'package:music/icon.dart';
// import 'package:music/model.dart';

// each page
class ButtonWithLabelAttribute extends StatelessWidget {
  const ButtonWithLabelAttribute({ Key? key, this.icon:Icons.arrow_back_ios_new, this.onPressed, this.label:'Back' }) : super(key: key);

  final String? label;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      // color: Theme.of(context).chipTheme.selectedColor,
      // color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      // padding: EdgeInsets.zero,
      minSize: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          Divider(indent:2),
          // Text(label!,style: TextStyle(fontSize: 19, height: 1.1), ),
          Text(label!,style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.0, fontSize: 19), strutStyle: StrutStyle(height: 1.5), ),
        ]
      ),
      onPressed: onPressed
    );
  }
}

// each page default is search
class ButtonAttribute extends StatelessWidget {
  const ButtonAttribute({ Key? key, this.icon:ZaideihIcon.search, this.onPressed}) : super(key: key);

  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      // color: Theme.of(context).chipTheme.selectedColor,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      minSize: 40,
      child: Icon(icon,size: 22),
      onPressed: onPressed,
    );
  }
}

// each page title
class PageAttribute extends StatelessWidget {
  const PageAttribute({ Key? key, required this.label,this.fontSize:19}) : super(key: key);

  final double? fontSize;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Text(label,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.3, fontSize:fontSize),
      ),
    );
  }
}

// track title, album name, artist name
class TitleAttribute extends StatelessWidget {
  const TitleAttribute({ Key? key, required this.text, this.aka }) : super(key: key);

  final String text;
  final String? aka;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: RichText(
        textAlign: TextAlign.center,
        strutStyle: const StrutStyle(
          height: 2.0
        ),
        text: new TextSpan(
          text: text,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            height: 1.3,
            fontSize: 30,
            shadows: [
              Shadow(
                blurRadius: 1.0,
                color: Theme.of(context).shadowColor,
                offset: const Offset(1.0, 0.0)
              )
            ]
          ),
          children: <TextSpan>[
            if (aka != null && aka!.isNotEmpty)new TextSpan(
              text: ' ($aka)',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                height: 1.3,
                fontSize: 25,
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: Theme.of(context).shadowColor,
                    offset: const Offset(1.0, 0.0)
                  )
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}

// album year, track year
class YearWrap extends StatelessWidget {
  const YearWrap({ Key? key, required this.year }) : super(key: key);

  final List<String> year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(0),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        textDirection: TextDirection.ltr,
        children: year.map(
          (e) => Padding(
            padding: const EdgeInsets.all(3),
            child: YearAttribute(text: e.toString(),)
          )
        ).toList()
      ),
    );
  }
}

// album year, track year
class YearAttribute extends StatelessWidget {
  const YearAttribute({ Key? key, required this.text }) : super(key: key);

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
      child: Text(text,
        // style: Theme.of(context).textTheme.caption!.copyWith(
        //   height: 1.0
        // ),
        style: const TextStyle(
          fontSize: 14
        ),
        strutStyle: const StrutStyle(
          height: 1.0
        ),
      ),
    );
  }
}

// album genre, track genre
class GenreWrap extends StatelessWidget {
  const GenreWrap({ Key? key, required this.genre }) : super(key: key);

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
        children: genre.map(
          (e) => Padding(
            padding: const EdgeInsets.all(3),
            child: GenreAttribute(text: e.toString(),)
          )
        ).toList()
      ),
    );
  }
}

// album genre, track genre
class GenreAttribute extends StatelessWidget {
  const GenreAttribute({ Key? key, required this.text }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,key: key,style: Theme.of(context).textTheme.bodyText1);
  }
}

// album genre, track genre
class StaticBadgeAttribute extends StatelessWidget {
  const StaticBadgeAttribute({ Key? key, required this.icon, required this.label }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: Column(
        children: [
          // Icon(icon, size: 27, color: Theme.of(context).buttonColor,),
          Icon(icon, size: 27, color: Theme.of(context).textTheme.caption!.color,),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(label,
              style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

// album-info, artist-info
class PlayAllAttribute extends StatelessWidget {
  const PlayAllAttribute({ Key? key, this.onPressed, this.label:'Play all' }) : super(key: key);

  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CupertinoButton(
        child: Text(label, style: Theme.of(context).textTheme.bodyText1,),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        // color: Theme.of(context).buttonColor,
        onPressed: onPressed,
      ),
    );
  }
}
