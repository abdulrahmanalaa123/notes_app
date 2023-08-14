import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.text, this.ontap});

  final String text;
  final void Function()? ontap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
          onTap: ontap ??
              () {
                Navigator.pop(context);
              },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Constants.yellow,
          )),
      title: Text(
        text,
        style: const TextStyle(color: Constants.yellow, fontSize: 40),
      ),
    );
  }
}
