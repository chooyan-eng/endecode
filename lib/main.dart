import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/view/encode.dart';
import 'package:ende_code/view/index.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

const appTitle = 'エンコードとデコード';

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
        home: _Home(),
      ),
    );
  }
}

class _Home extends StatelessWidget {

  final _inputData = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: TextStyle(color: Colors.white)),
      ),

      body: Index(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showCanvasDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void showCanvasDialog(BuildContext context) {
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
              SimpleDialogOption(child: Text("2", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(context, 2); }),
              Container(height: 1, color: EndecodeColors.blue.shade100),
              SimpleDialogOption(child: Text("4", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(context, 4); }),
              Container(height: 1, color: EndecodeColors.blue.shade100),
              SimpleDialogOption(child: Text("8", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(context, 8); }),
              Container(height: 1, color: EndecodeColors.blue.shade100),
              SimpleDialogOption(child: Text("16", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(context, 16); }),
              Container(height: 1, color: EndecodeColors.blue.shade100),
              SimpleDialogOption(child: Text("32", style: EndecodeTextStyle.dialogOption), onPressed: () { navigateToEncode(context, 32); }),
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
                  child: ValueListenableBuilder<String>(
                    valueListenable: _inputData,
                    builder:(_context, inputData, child) => TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit),
                        ),
                        onChanged: (value) {
                          _inputData.value = value;
                        }
                    ),
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
                    onPressed: ()=> _save(context),
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

  void navigateToEncode(BuildContext context, int cellNum) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Encode(imageData: ImageData.empty(cellNum))));
  }

  void _save(BuildContext context) {
    var imageData = ImageData(
      title: "もらった データ",
      creator: "",
      dataStr: _inputData.value,
    );
    ImageDataProvider(Provider.of<AppData>(context).db).insert(imageData).then((data) {
      Provider.of<AppData>(context).reload();
      Navigator.pop(context);
    });
  }
}
