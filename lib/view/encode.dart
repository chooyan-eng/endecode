import 'package:ende_code/model/app_data.dart';
import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/canvas.dart' as view;
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/component/data_field.dart';
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

  var _imageData;
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
              imageData: _imageData,
              onSave: (title, creator) {
                _imageData.title = title;
                _imageData.creator = creator ?? "";
                _imageData.dataStr = _encodedData.fold<String>(_imageData.cellNum.toString().padLeft(2, '0'), (prev, value) => prev + value.toString().padLeft(2, '0'));
                if (_imageData.id == null) {
                  ImageDataProvider(Provider.of<AppData>(context).db).insert(_imageData).then((data) {
                    _imageData.id = data.id;
                    Provider.of<AppData>(context).reload();
                    Navigator.pop(context);
                  });
                } else {
                  ImageDataProvider(Provider.of<AppData>(context).db).update(_imageData).then((data) {
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

  var _blockList = <List<bool>>[];

  @override
  void initState() {

    _imageData = widget.imageData;

    _blockList= List<int>(_imageData.cellNum).map((num) =>
      List<int>(_imageData.cellNum).map((num) => false).toList()
    ).toList();

    setState(() {
      drawDots(0, _imageData.data);
      _buildEncodedData();
    });

    super.initState();
  }

  void drawDots(int row, List<int> data) {
    var total = 0;
    var isWhite = true;
    var count = 0;

    for (; total < _imageData.cellNum; count++) {
      int targetCellCount = data[count];
      for (var i = 0; i < targetCellCount; i++) {
        _blockList[row][total + i] = !isWhite;
      }
      total += targetCellCount;
      isWhite = !isWhite;
    }

    if (count != data.length) {
      drawDots(row + 1, data.sublist(count));
    }
  }

  void _onChange(int row, int column) {
    setState(() {
      _blockList[row][column] = !_blockList[row][column];
    });
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
      appBar: AppBar(
        title: Text("エンコード"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              view.Canvas(
                width: canvasSize,
                cellNum: _imageData.cellNum,
                onChange: _onChange,
                dataSource: _blockList,
              ),
              SizedBox(height: 32),
              DataField(dataList: _encodedData),
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