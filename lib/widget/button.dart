import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WidgetButton extends StatelessWidget {

  WidgetButton({
    Key? key,
    this.label:'',
    required this.child,
    this.padding:EdgeInsets.zero,
    this.color,
    this.onPressed

  }): super(key: key);

  final String label;
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: key,
      message: label,
      child: CupertinoButton(
        minSize: 30,
        // pressedOpacity: 0.5,
        color: color,
        // color: color,
        padding: padding,
        // padding: EdgeInsets.symmetric(vertical: 10,horizontal:0),
        // color: isButtomSelected?Colors.red:null,
        // borderRadius: BorderRadius.all(Radius.circular(2)),
        // padding: EdgeInsets.all(20),
        // disabledColor: Colors.grey[100],
        child: child,
        onPressed: onPressed
      ),
    );
  }

}