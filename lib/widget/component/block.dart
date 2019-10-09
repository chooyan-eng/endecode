import 'package:flutter/material.dart';

class Block extends StatefulWidget {

  final double size;
  final int row;
  final int column;
  final Function onChange;

  const Block({Key key, this.size, this.row, this.column, this.onChange}) : super(key: key);

  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {

  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() { _isSelected = !_isSelected; });
        if (widget.onChange != null) {
          widget.onChange(widget.row, widget.column, _isSelected);
        }
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(),
          color: _isSelected ? Colors.black : Colors.transparent,
        ),
      ),
    );
  }
}