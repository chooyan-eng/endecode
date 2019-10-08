import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/block.dart';
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/component/save_data_dialog_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Encode extends StatefulWidget {

  ImageData imageData;

  Encode({Key key, this.imageData}) : super(key: key);

  @override
  _EncodeState createState() => _EncodeState();
}

class _EncodeState extends State<Encode> {

  var _encodedData = List<int>();

  bool get _canSave {
    return _encodedData.isNotEmpty;
  }

  void _save() {
    showDialog(
      context: context,
      builder: (buildContext) {
        return SimpleDialog(
          title: const Text("データの ほぞん"),
          children: <Widget>[
            SaveDataDialogBody(onSave: (title, creator) {
              ImageDataProvider(Provider.of<AppData>(context).db).insert(
                ImageData(
                  title: title,
                  creator: creator ?? "",
                  dataStr: _encodedData.fold<String>("16", (prev, value) => prev + value.toString().padLeft(2, '0')),
                ),
              ).then((data) {
                Provider.of<AppData>(context).reload();
                Navigator.pop(context);
              });
            }),
          ],
        );
      }
    );
  }

  var _blockList = List<int>(16).map((num) =>
    List<int>(16).map((num) => false).toList()
  ).toList();

  void _onChange(int row, int column, bool isSelected) {
    _blockList[column][row] = isSelected;
    _buildEncodedData();
  }

  void _buildEncodedData() {
    var result = <int>[];
    var isWhite = true;
    var count = 0;

    _blockList.forEach((row) {
      row.forEach((isSelected) {
        if (isWhite) {
          if (isSelected) {
            result.add(count);
            count = 1;
            isWhite = false;
          } else {
            count += 1;
          }
        } else {
          if (isSelected) {
            count += 1;
          } else {
            result.add(count);
            count = 1;
            isWhite = true;
          }
        }
      });
      result.add(count);
      count = 0;
      isWhite = true;
    });

    setState(() {
      _encodedData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final blockSize = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ?
      (MediaQuery.of(context).size.width - 32) / 16 :
      (MediaQuery.of(context).size.height - 32 - 160) / 16;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Column(
                children: List<int>.generate(16, (int index) => index).map((column) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<int>.generate(16, (int index) => index).map((row) => Block(size: blockSize, column: column, row: row, onChange: _onChange,)).toList(),
                  )
                ).toList()
              ),
              SizedBox(height: 32),
              Wrap(
                children: _encodedData.map((num) => Padding(padding: const EdgeInsets.all(8.0), child:Text("$num", style: const TextStyle(fontSize: 24.0),))).toList(),
              ),
              SizedBox(height: 32),
              RaisedButton(
                onPressed: _canSave ? _save : null,
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
                    color: _canSave ? EndecodeColors.blue : Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const Center(child: const Text("ほぞん", style: const TextStyle(fontSize: 20.0), textAlign: TextAlign.center))
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );

  }
}