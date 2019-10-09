import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/canvas.dart' as view;
import 'package:flutter/material.dart';

class Decode extends StatefulWidget {

  final ImageData imageData;

  const Decode(this.imageData, {Key key}) : super(key: key);

  @override
  _DecodeState createState() => _DecodeState();
}

class _DecodeState extends State<Decode> {

  var _blockList = <List<bool>>[];
  var _encodedData = "";

  bool get _isCorrect {
    return _encodedData == widget.imageData.dataStr;
  }

  @override
  void initState() {
    _blockList= List<int>(widget.imageData.cellNum).map((num) =>
      List<int>(widget.imageData.cellNum).map((num) => false).toList()
    ).toList();

    super.initState();
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
      _encodedData = result.fold<String>(widget.imageData.cellNum.toString().padLeft(2, '0'), (prev, value) => prev + value.toString().padLeft(2, '0'));
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
              _isCorrect ? Text("せいかい！", style: TextStyle(fontSize: 30)) : SizedBox(),
              Wrap(
                children: widget.imageData.data.map((num) => Padding(padding: const EdgeInsets.all(8.0), child:Text("$num", style: const TextStyle(fontSize: 24.0),))).toList(),
              ),
              SizedBox(height: 32),
              view.Canvas(
                width: canvasSize,
                cellNum: widget.imageData.cellNum,
                onChange: _onChange,
                dataSource: _blockList,
              )
            ],
          ),
        ),
      ),
    );
  }
}