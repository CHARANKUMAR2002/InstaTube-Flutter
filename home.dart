import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'instagram.dart';
import 'youtube.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NavigationView(
        appBar: NavigationAppBar(title:
            Center(child: Text("InstaTube", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),)),
         ),
        pane: NavigationPane(
          displayMode: PaneDisplayMode.top,
          onChanged: (i) => setState(() {
            page = i;
          }),
          selected: page,
          items: <NavigationPaneItem>[
            PaneItem(icon: Icon(FontAwesomeIcons.instagram), title: Text("Instagram")),
            PaneItem(icon: Icon(FontAwesomeIcons.youtube), title: Text("Youtube")),

          ]
        ),
        content: NavigationBody(
          index: page,
          children: [
            Instagram(),
            Youtube(),
          ],
        ),
      ),
    );
  }
}
