import 'package:ende_code/model/image_data.dart';
import 'package:ende_code/widget/component/canvas.dart' as view;
import 'package:ende_code/widget/component/colors.dart';
import 'package:ende_code/widget/component/data_field.dart';
import 'package:ende_code/widget/style/styles.dart';
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
      appBar: AppBar(
        title: Text("デコード"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _isCorrect ? Padding(padding: EdgeInsets.only(bottom: 32.0), child: Center(child: Text("せいかい！", style: TextStyle(fontSize: 40, color: EndecodeColors.orange)))) : SizedBox(),
              Text("データ", style: EndecodeTextStyle.label),
              DataField(dataList: widget.imageData.data),
              SizedBox(height: 16),
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