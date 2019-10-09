import 'package:flutter/material.dart';

class Block extends StatefulWidget {

  final double size;
  final int row;
  final int column;
  final Function onChange;
  final isSelected;

  const Block({Key key, this.size, this.row, this.column, this.onChange, this.isSelected}) : super(key: key);

  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onChange != null) {
          widget.onChange(widget.row, widget.column);
        }
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(),
          color: widget.isSelected ? Colors.black : Colors.transparent,
        ),
      ),
    );
  }
}