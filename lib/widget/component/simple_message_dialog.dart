import 'package:ende_code/widget/component/colors.dart';
import 'package:flutter/material.dart';

class SimpleMessageDialog extends StatelessWidget {

  final String title;
  final String message;
  final Function onPositiveTapped;
  final Function onNegativeTapped;
  final bool hasPositive;
  final bool hasNegative;

  const SimpleMessageDialog({Key key, this.title, this.message, this.onPositiveTapped, this.onNegativeTapped, this.hasPositive = true, this.hasNegative = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(message, style: TextStyle(fontSize: 16))
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              hasNegative ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (onNegativeTapped != null) {
                    onNegativeTapped();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("キャンセル", style: TextStyle(fontSize: 18)),
                ),
              ) : SizedBox(),
              hasPositive ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (onPositiveTapped != null) {
                    onPositiveTapped();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Text("はい", style: TextStyle(fontSize: 18, color: EndecodeColors.blue.shade700)),
                ),
              ) : SizedBox(),
            ],
          ),
        ),

      ],
    );
  }
}