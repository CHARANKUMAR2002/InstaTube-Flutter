import 'package:fluent_ui/fluent_ui.dart';
import 'home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(brightness: Brightness.dark,focusTheme: FocusThemeData(
        glowFactor: 3.0,),),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
