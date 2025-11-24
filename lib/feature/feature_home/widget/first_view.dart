import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstView extends StatefulWidget {
  String baseImage = '';
  List<String> images = [
    'assets/images/bg1.jpg',
    'assets/images/bg2.jpg',
    'assets/images/bg3.jpg',
    'assets/images/bg4.jpg',
  ];
  int imageIndex = 0;

  @override
  State<FirstView> createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      if (widget.imageIndex < widget.images.length ) {
        setState(() {
          widget.imageIndex++;
        });
      } else {
        setState(() {
          widget.imageIndex = 0;
        });
      }
    });
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.images[widget.imageIndex]),
          fit: BoxFit.cover,
        ),
      ),
      width: 360.w,
      height: 690.h,
      alignment: Alignment.center,
      child: Text(
        'Welcome back!',
        style: TextStyle(
          fontSize: 25.sp,
          color: Colors.indigoAccent.shade400,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
