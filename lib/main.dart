import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/view/encode.dart';
import 'package:ende_code/view/index.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => AppData(),
      child: MaterialApp(
        title: 'エンデコード',
        theme: ThemeData(
          primarySwatch: EndecodeColors.blue,
        ),
        home: Home(title: 'エンコードとデコードって？'),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Index(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Encode()));
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
