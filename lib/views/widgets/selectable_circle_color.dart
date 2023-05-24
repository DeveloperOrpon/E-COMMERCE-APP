import 'package:flutter/material.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/ColorWay.dart';

class SelectableCircleColor extends StatefulWidget {
  final EdgeInsetsGeometry margin, padding;
  final List<ColorWay> colorWay;

  const SelectableCircleColor(
      {super.key,
      required this.colorWay,
      required this.margin,
      required this.padding});

  @override
  _SelectableCircleState createState() => _SelectableCircleState();
}

class _SelectableCircleState extends State<SelectableCircleColor> {
  int? _selectedIndex;

  _change(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        children: List.generate(
          widget.colorWay.length,
          (index) {
            return InkWell(
              onTap: () {
                _change(index);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: AppColor.primarySoft),
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Color(num.parse(widget.colorWay[index].color
                            .split(RegExp(r"[()]"))[1])
                        .toInt()),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 4,
                      color: (index == _selectedIndex)
                          ? AppColor.primarySoft.withOpacity(0.9)
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
