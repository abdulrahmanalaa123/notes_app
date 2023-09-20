import 'package:flutter/material.dart';

class GridViewButton extends StatelessWidget {
  const GridViewButton({
    required this.viewFunc,
    super.key,
  });

  final void Function() viewFunc;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: viewFunc,
        icon: const Icon(
          Icons.grid_view,
          color: Colors.white,
          size: 20,
        ),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF1B1B1B),
          padding: const EdgeInsets.all(16),
        ));
  }
}
