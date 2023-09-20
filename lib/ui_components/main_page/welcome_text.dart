import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class GroupTextIdentifier extends StatelessWidget {
  const GroupTextIdentifier({required this.group, super.key});
  final String group;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$group Notes',
            style: const TextStyle(
              fontSize: 48,
              color: Constants.textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          //const Text(
          //  'Notes',
          //  style: TextStyle(
          //    fontSize: 48,
          //    color: Constants.textColor,
          //    fontWeight: FontWeight.w400,
          //  ),
          //),
        ],
      ),
    );
  }
}
