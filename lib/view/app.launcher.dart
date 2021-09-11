part of 'app.dart';

class ScreenLauncher extends StatelessWidget {
  // a comprehensive myanmar online dictionary
  // more at Zaideih Music Station
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   child: Text('Message'),
            //   onPressed: (){
            //     context.read<Core>().message = 'Hello';
            //   }
            // ),
            // Consumer<Core>(
            //   builder: (context, core, child)  => ElevatedButton(
            //     child: Text('Consumer: ${core.message}'),
            //     onPressed: (){
            //       core.message = 'from Consumer';
            //     }
            //   ),
            // ),
            // Selector<Core,String?>(
            //   selector: (_, core) => core.message,
            //   builder: (BuildContext context, String? message, Widget? child) => ElevatedButton(
            //     child: Text('Selector: $message'),
            //     onPressed: (){
            //       // message = 'from Selector';
            //       context.read<Core>().message = 'from Selector';
            //     }
            //   )
            // ),

            // Provider<TestCoreNotifier>(
            //   create: (_) => TestCoreNotifier(),
            //   // Will throw a ProviderNotFoundError, because `context` is associated
            //   // to the widget that is the parent of `Provider<Example>`
            //   // child: Text(context.watch<TestCoreNotifier>().message),
            //   builder: (e,s) {
            //     return ElevatedButton(
            //       child: Text('Message: ${e.read<TestCoreNotifier>().message}'),
            //       onPressed: (){
            //         e.read<TestCoreNotifier>().message = 'Hello';
            //       }
            //     );
            //   }
            // ),
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                // strutStyle: StrutStyle(),
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.button!.color,
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:'Listen',
                      semanticsLabel: "listen",
                      style: TextStyle(
                        fontSize: 45
                      )
                    ),
                    TextSpan(
                      text: ' to\n',
                      semanticsLabel: "to",
                      style: TextStyle(
                        fontSize: 50,
                        
                      )
                    ),
                    TextSpan(
                      text: 'Zaideih\n'.toUpperCase(),
                      semanticsLabel: "Zaideih",
                      style: TextStyle(
                        fontSize: 60,
                      )
                    ),
                    TextSpan(
                      text: 'music ',
                      semanticsLabel: "music",
                      style: TextStyle(
                        fontSize: 32
                      )
                    ),
                    TextSpan(
                      text: 'station',
                      semanticsLabel: "station",
                      style: TextStyle(
                        fontSize: 30
                      )
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark",
                      style: TextStyle(
                        fontSize: 25
                      )
                    )
                  ]
                )
              ),
            ),
            Semantics(
              label: "Progress",
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:50),
                child: Selector<Core, double?>(
                  selector: (_, core) => core.progressPercentage,
                  builder: (BuildContext context, double? percentage, Widget? child) => CircularProgressIndicator(
                    semanticsLabel: 'percentage',
                    semanticsValue: percentage.toString(),
                    strokeWidth: 2.0,
                    value: percentage,
                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                  )
                )
                // child: CircularProgressIndicator(
                //   semanticsLabel: 'percentage',
                //   semanticsValue: state.progressPercentage.toString(),
                //   strokeWidth: 2.0,
                //   value: state.progressPercentage,
                //   valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                // )
                // child: Consumer<Core>(
                //   builder: (context, core, _)  => CircularProgressIndicator(
                //     semanticsLabel: 'percentage',
                //     // semanticsValue: core.progressPercentage.toString(),
                //     strokeWidth: 2.0,
                //     value: core.progressPercentage,
                //     valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                //   )
                // )
                // child: ValueListenableBuilder<double?>(
                //   valueListenable: Core.instance.collection.notify.progress,
                //   builder: (context, value, _)  => CircularProgressIndicator(
                //     semanticsLabel: 'percentage',
                //     semanticsValue: value.toString(),
                //     strokeWidth: 2.0,
                //     value: value,
                //     valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                //   )
                // )
              )
            ),
            Semantics(
              label: "Message",
              child: Selector<Core, String>(
                selector: (_, core) => core.message,
                builder: (BuildContext _, String message, Widget? child) => Text(message,
                  semanticsLabel: message,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 30
                  )
                )
              )
            )
            // Semantics(
            //   label: "Message",
            //   child: Text(
            //     'state.message',
            //     semanticsLabel: 'state.message',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w300,
            //       fontSize: 30,
            //     ),
            //   ),
            // )

            // Semantics(
            //   label: "App name",
            //   child: Text(
            //     "MyOrdbok",
            //     semanticsLabel: "MyOrdbok",
            //     style: TextStyle(
            //       fontSize: 22
            //     )
            //   )
            // )
          ]
        )
      )
    );
  }

  // Widget name(){
  //   return Container(
  //     height: 70,
  //     child: Center(
  //       child: Text(
  //         // store.appVersion,
  //         // Store.apple
  //         'Core.instance.version',
  //         // '...',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w200,
  //           // foreground: Paint()
  //           //   ..style = PaintingStyle.stroke
  //           //   ..strokeWidth = 2
  //           shadows: <Shadow>[
  //             // Shadow(
  //             //   offset: Offset(0.3, 0.5),
  //             //   blurRadius: 0.2,
  //             // ),
  //             // Shadow(
  //             //   offset: Offset(2.0, 1.0),
  //             //   blurRadius: 20.0,
  //             // ),
  //           ],
  //         ),
  //       )
  //     ),
  //   );
  // }
}