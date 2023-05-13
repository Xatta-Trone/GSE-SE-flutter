import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grese/GoogleSignInService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  User? _user;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future googleSignIn() async {
    try {
      final user = await GoogleSignInService.login();

      var userAuth = await user?.authentication;

      // Create a new credential
      // final credential = GoogleSignInAuthentication(
      //   accessToken: userAuth?.accessToken,
      //   idToken: userAuth?.idToken,
      // );

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: userAuth?.accessToken,
        idToken: userAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _user = FirebaseAuth.instance.currentUser;
      });

      if (kDebugMode) {
        print(user?.displayName);
        print(user?.email);
        print(user?.id);
        print(user?.photoUrl);
        print(userAuth?.accessToken);
        print(userAuth?.idToken);
        print(userAuth?.hashCode);
      }
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  Future logout() async {
    try {
      await GoogleSignInService.logout();
      FirebaseAuth.instance.signOut();
      setState(() {
        _user = null;
      });
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  void autoLogin() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        _user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wire-frame for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipRect(
                child: Image.network(
                  _user?.photoURL ??
                      'https://fastly.picsum.photos/id/404/200/200.jpg?hmac=7TesL9jR4uM2T_rW-vLbBjqvfeR37MJKTYA4TV-giwo',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              _user?.displayName ?? '',
            ),
            Text(
              _user?.email ?? '',
            ),
            Text(
              _user?.uid ?? '',
            ),
            ElevatedButton(
              onPressed: googleSignIn,
              child: const Text('google sign in'),
            ),
            ElevatedButton(
              onPressed: logout,
              child: const Text('google sign out'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
