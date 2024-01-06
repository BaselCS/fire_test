import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//لا تضف اي من إضافات جوجل
//أضف الذي تحتجاه من فاير بيس
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String messagingSenderId = "983233010382";
  String projectId = "flash-chat-3ce83";
  void _pushToNewScreen() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        projectId: projectId, //Bucket
        apiKey: "", //رابط الموقع عتد الحاجة للاتصال به
        appId: "1:$messagingSenderId:android:d87b8e94bb7b1ec8058e9f",
        messagingSenderId: messagingSenderId,
        databaseURL: "https://$projectId-default-rtdb.firebaseio.com",
      ),
    );
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyTestPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'messagingSenderId'),
                onChanged: (value) => messagingSenderId = value),
            TextField(decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'projectId'), onChanged: (value) => projectId = value),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushToNewScreen,
        tooltip: 'connection',
        child: const Icon(Icons.connect_without_contact),
      ),
    );
  }
}

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  late DatabaseReference starCountRef;

  @override
  void initState() {
    //TODO: ضف الموقع الذي تريد قرأته
    starCountRef = FirebaseDatabase.instance.ref('Site');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: starCountRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.snapshot.value.toString());
            } else {
              return const Text("Loading...");
            }
          }),
    );
  }
}
