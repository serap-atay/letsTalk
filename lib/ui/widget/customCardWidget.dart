// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String path;
  final String title;
  final Color color;
  final Color textColor;
  final double textSize;
  final bool isImageVisible;
  final VoidCallback onPress;

  const CustomCard
      ({super.key, this.path  =  "images/icons8-loading-circle.gif", required this.onPress, required this.title,
      this.color = Colors.white10, this.textSize = 14, this.textColor = Colors.black, this.isImageVisible = false});



  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Card(
        color: widget.color,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: widget.isImageVisible,
                child: SizedBox(
                  width: 40,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Image.asset(widget.path),
                    )),
              ),
              Text(widget.title,
              style: TextStyle(fontSize: widget.textSize ,color: widget.textColor),)
            ],
          ),
        ),
      ),
    );
  }
}
