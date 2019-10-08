import 'package:ende_code/widget/component/block.dart';
import 'package:flutter/material.dart';

class Encode extends StatefulWidget {
  @override
  _EncodeState createState() => _EncodeState();
}

class _EncodeState extends State<Encode> {

  var _encodedData = List<int>();

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
    final blockSize = (MediaQuery.of(context).size.width - 32) / 16;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Column(
              children: List<int>.generate(16, (int index) => index).map((column) =>
                Row(
                  children: List<int>.generate(16, (int index) => index).map((row) => Block(size: blockSize, column: column, row: row, onChange: _onChange,)).toList(),
                )
              ).toList()
            ),
            SizedBox(height: 32),
            Wrap(
              children: _encodedData.map((num) => Padding(padding: const EdgeInsets.all(8.0), child:Text("$num", style: const TextStyle(fontSize: 24.0),))).toList(),
            ),
          ],
        ),
      ),
    );

  }
}