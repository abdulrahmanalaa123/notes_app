import 'package:flutter/material.dart';

import 'grid_view_button.dart';

class MainPageTopButtons extends StatelessWidget {
  const MainPageTopButtons({
    super.key,
    this.button1Func,
  });
  final void Function()? button1Func;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: button1Func ?? () {},
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF1B1B1B),
              padding: const EdgeInsets.all(16),
            ),
          ),
          GridViewButton(
            viewFunc: () {},
          ),
        ],
      ),
    );
  }
}
