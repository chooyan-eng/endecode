import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/canvas.dart' as view;
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/component/save_data_dialog_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Encode extends StatefulWidget {

  final ImageData imageData;

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
            SaveDataDialogBody(
              imageData: widget.imageData,
              onSave: (title, creator) {
                widget.imageData.title = title;
                widget.imageData.creator = creator ?? "";
                widget.imageData.dataStr = _encodedData.fold<String>(widget.imageData.cellNum.toString().padLeft(2, '0'), (prev, value) => prev + value.toString().padLeft(2, '0'));
                if (widget.imageData.id == null) {
                  ImageDataProvider(Provider.of<AppData>(context).db).insert(widget.imageData).then((data) {
                    Provider.of<AppData>(context).reload();
                    Navigator.pop(context);
                  });
                } else {
                  ImageDataProvider(Provider.of<AppData>(context).db).update(widget.imageData).then((data) {
                    Provider.of<AppData>(context).reload();
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        );
      }
    );
  }

  var _blockList = [];

  @override
  void initState() {
    _blockList= List<int>(widget.imageData.cellNum).map((num) =>
      List<int>(widget.imageData.cellNum).map((num) => false).toList()
    ).toList();
    super.initState();
  }
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
    final canvasSize = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ?
      MediaQuery.of(context).size.width - 32 :
      MediaQuery.of(context).size.height - 32 - 160;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              view.Canvas(
                width: canvasSize,
                cellNum: widget.imageData.cellNum,
                onChange: _onChange,
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