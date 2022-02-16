part of 'main.dart';

class ScreenLauncher extends StatelessWidget {
  const ScreenLauncher({Key? key}) : super(key: key);

  // Listen to Zaideih Music Station
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                // strutStyle: StrutStyle(),
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Listen',
                      semanticsLabel: "Listen",
                      style: TextStyle(fontSize: 42),
                    ),
                    TextSpan(
                      text: ' to\n',
                      semanticsLabel: "to",
                      style: TextStyle(fontSize: 42),
                    ),
                    TextSpan(
                      text: 'Zaideih\n',
                      semanticsLabel: "Zaideih",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    TextSpan(
                      text: 'Music ',
                      semanticsLabel: "Music",
                      style: TextStyle(fontSize: 25),
                    ),
                    TextSpan(
                      text: 'Station',
                      semanticsLabel: "Station",
                      style: TextStyle(fontSize: 25),
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark",
                      style: TextStyle(fontSize: 23),
                    ),
                  ],
                ),
              ),
            ),
            Semantics(
              label: "Progress",
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text('...'),
              ),
            ),
            Semantics(
              label: "Message",
              child: Selector<Core, String>(
                selector: (_, core) => core.message,
                builder: (BuildContext _, String message, Widget? child) => Text(
                  message,
                  semanticsLabel: message,
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
