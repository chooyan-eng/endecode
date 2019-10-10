import 'package:ende_code/widget/component/colors.dart';
import 'package:flutter/material.dart';

class DataField extends StatelessWidget {

  final List<int> dataList;

  const DataField({Key key, this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: EndecodeColors.blue),
        color: EndecodeColors.blue.shade50,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Wrap(
          children: dataList.map((num) => Padding(padding: const EdgeInsets.all(8.0), child:Text("$num", style: const TextStyle(fontSize: 24.0),))).toList(),
        ),
      ),
    );
  }
}