import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent(
      {Key key,
      this.title = 'Nothing here',
      this.message = 'Add a new item to get started',this.belowWidget})
      : super(key: key);
  final String title;
  final String message;
  final Widget belowWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black54,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          belowWidget??Container(height: 0,)
        ],
      ),
    );
  }
}
