import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  String dataFromNetwork = '';
  void setDataFromNetwork(String data) {
    setState(() {
      dataFromNetwork = data;
    });
  }

  int _counter = 0;

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
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 300.0,
              child: displayPosts(),
            ),
            Text(dataFromNetwork),
            TextButton(
                onPressed: getPost, child: const Text('call post from API')),
            TextButton(
                onPressed: deletePost,
                child: const Text('delete post from API')),
            TextButton(
                onPressed: createPost, child: const Text('create post to API')),
            TextButton(
                onPressed: updatePost, child: const Text('update post to API')),
            TextButton(
                onPressed: patchPost, child: const Text('patch post to API')),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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

  Future<void> getPost() async {
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts/1');
    http.Response response = await http.get(url);
    print(response.statusCode);
    Map<String, dynamic> post = json.decode(response.body);
    setDataFromNetwork(post['title']);
  }

  Future<void> deletePost() async {
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts/1');
    http.Response response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setDataFromNetwork(
          'Delete post successs with code :  ${response.statusCode.toString()}');
    } else {
      setDataFromNetwork('Delete post unsuccesss');
    }
  }

  Future<void> createPost() async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'userId': 1,
      'id': 101,
      'title': 'the title',
      'body': 'the body'
    };
    var jsonData = jsonEncode(body);
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    http.Response response =
        await http.post(url, headers: header, body: jsonData);
    print(response.statusCode);
    setDataFromNetwork(response.statusCode.toString());
  }

  Future<void> updatePost() async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'userId': 1,
      'id': 100,
      'title': 'the title',
      'body': 'the body'
    };
    var jsonData = jsonEncode(body);
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts/100');
    http.Response response =
        await http.put(url, headers: header, body: jsonData);
    print(response.statusCode);
    setDataFromNetwork(response.statusCode.toString());
  }

  Future<void> patchPost() async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'userId': 1,
      'id': 100,
      'title': 'the title',
      'body': 'the body'
    };
    var jsonData = jsonEncode(body);
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts/100');
    http.Response response =
        await http.patch(url, headers: header, body: jsonData);
    print(response.statusCode);
    setDataFromNetwork(response.statusCode.toString());
  }

  Future<List<Post>> getPosts() async {
    List<Post> posts = [];

    var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    http.Response response = await http.get(url);

    print(response.statusCode);

    var jsonData = json.decode(response.body);
    for (var postIn in jsonData) {
      Post postOut =
          Post(postIn['userId'], postIn['id'], postIn['title'], postIn['body']);
      posts.add(postOut);
    }

    print(posts.length);
    return posts;
  }

  FutureBuilder displayPosts() {
    return FutureBuilder(
        future: getPosts(),
        builder: ((context, snapshot) {
          // if snapshot empty
          if (snapshot.data == null) {
            return Container(
              child: Center(child: const Text("Loading ...")),
            );
          } else {
            // if snapshot consist of data
            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].title),
                    );
                  }),
            );
          }
        }));
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(this.userId, this.id, this.title, this.body);
}
