import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

sealed class Styles {
  static Radius radius = Radius.circular(10.sp);
  static BorderRadius receiveMessageBorder =
      BorderRadius.only(topLeft: radius, bottomRight: radius, topRight: radius);
  static BorderRadius sendMessageBorder =
      BorderRadius.only(topLeft: radius, bottomLeft: radius, topRight: radius);
}
