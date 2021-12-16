import 'package:flutter/cupertino.dart';

class OverlayData {
  const OverlayData({this.options,this.heading="",@required this.profession});
  final List<String> options;
  final String heading;
  final String profession;
}