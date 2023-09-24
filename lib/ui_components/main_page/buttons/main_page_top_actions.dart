import 'package:flutter/material.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'package:provider/provider.dart';

import 'grid_view_button.dart';

class MainPageTopButtons extends StatelessWidget {
  const MainPageTopButtons({
    super.key,
    this.button2Func,
  });
  final void Function()? button2Func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              await context.read<AuthController>().signOut();
            },
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
            viewFunc: button2Func ?? () {},
          ),
        ],
      ),
    );
  }
}
