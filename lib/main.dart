import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/view/encode.dart';
import 'package:ende_code/view/index.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/style/styles.dart';
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
          showCanvasDialog();
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void showCanvasDialog() {
    showDialog(
      context: context,
      builder: (buildContext) {
        return SimpleDialog(
          title: const Text("えの おおきさ"),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("えの おおきさを えらんでください", style: EndecodeTextStyle.label)
            ),
            SizedBox(height: 16),
            SimpleDialogOption(child: Text("2", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(2); }),
            Container(height: 1, color: EndecodeColors.blue.shade100),
            SimpleDialogOption(child: Text("4", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(4); }),
            Container(height: 1, color: EndecodeColors.blue.shade100),
            SimpleDialogOption(child: Text("8", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(8); }),
            Container(height: 1, color: EndecodeColors.blue.shade100),
            SimpleDialogOption(child: Text("16", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(16); }),
            Container(height: 1, color: EndecodeColors.blue.shade100),
            SimpleDialogOption(child: Text("32", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(32); }),
          ],
        );
      }
    );
  }

  void navigateToEncode(int cellNum) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Encode(imageData: ImageData.empty(cellNum))));
  }
}
