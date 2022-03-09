import 'package:cdh/views/background.dart';
import 'package:cdh/views/home.dart';
import 'package:cdh/views/homefragment.dart';
import 'package:cdh/views/security.dart';
import 'package:cdh/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context,widget)=> ResponsiveWrapper.builder(ClampingScrollWrapper.builder(context, widget),
        breakpoints: [
          ResponsiveBreakpoint.resize(350, name:MOBILE),
          ResponsiveBreakpoint.autoScale(600,name: TABLET),
          ResponsiveBreakpoint.autoScale(800,name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700,name:'xl')
        ],
      ),

      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.indigo,
        primaryColor: Colors.indigoAccent[700],
        //primaryColor: Colors.indigo,
        //accentColor: Colors.blue,
        accentColor: Colors.indigoAccent[700],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: LoginScreen(),
      home: WelcomeScreen(),

      //home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState((){
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
