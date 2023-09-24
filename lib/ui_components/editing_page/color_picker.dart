import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({required this.color, required this.func, super.key});
  final Color color;
  final void Function(Color color) func;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 250,
                padding: const EdgeInsets.all(32),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: Constants.listOfColors
                      .map((e) => GestureDetector(
                            onTap: () {
                              func(e);
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              height: 70,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: e,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            });
      },
      child: Icon(
        Icons.circle,
        color: color,
        size: 40,
      ),
    );
  }
}
