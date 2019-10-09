import 'package:flutter/material.dart';

import 'block.dart';

class Canvas extends StatefulWidget {

  final double width;
  final int cellNum;
  final Function onChange;
  final List<List<bool>> dataSource;

  const Canvas({Key key, this.cellNum = 8, this.width, this.onChange, this.dataSource}) : super(key: key);

  @override
  _CanvasState createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<int>.generate(widget.cellNum, (int index) => index).map((row) =>
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<int>.generate(widget.cellNum, (int index) => index).map((column) =>
            Block(
              size: widget.width / widget.cellNum,
              column: column, row: row,
              onChange: widget.onChange,
              isSelected: widget.dataSource[row][column],
            )
          ).toList(),
        )
      ).toList()
    );
  }
}