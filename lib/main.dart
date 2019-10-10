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
        home: Home(title: 'エンコードとデコード'),
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

  var _inputData = "";

  void showCanvasDialog() {
    showDialog(
      context: context,
      builder: (buildContext) {
        return SimpleDialog(
          title: const Text("あたらしく エンコードする"),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("あたらしく えを かくばあいは おおきさを えらんでください", style: EndecodeTextStyle.label)
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
            Container(height: 2, color: EndecodeColors.blue),
            Container(
              color: EndecodeColors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("もらった データが あるばあいは ここに いれてください", style: EndecodeTextStyle.label)
              ),
            ),
            Container(
              color: EndecodeColors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit),
                  ),
                  onChanged: (value) {
                    setState(() { _inputData = value; });
                  },
                ),
              ),
            ),
            Container(
              color: EndecodeColors.blue.shade50,
              height: 16,
            ),
            Container(
              color: EndecodeColors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  onPressed: _save,
                  disabledTextColor: Colors.white,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    decoration: BoxDecoration(
                      color: EndecodeColors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: const Center(child: const Text("ほぞん", style: const TextStyle(fontSize: 20.0), textAlign: TextAlign.center))
                  ),
                ),
              ),
            ),
            Container(height: 2, color: EndecodeColors.blue),
          ],
        );
      }
    );
  }

  void navigateToEncode(int cellNum) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Encode(imageData: ImageData.empty(cellNum))));
  }

  void _save() {
    var imageData = ImageData(
      title: "もらった データ",
      creator: "",
      dataStr: _inputData,
    );
    ImageDataProvider(Provider.of<AppData>(context).db).insert(imageData).then((data) {
      Provider.of<AppData>(context).reload();
      Navigator.pop(context);
    });
  }
}
