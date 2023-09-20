import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/multi_select_provider.dart';
import 'elements_count_component.dart';

class MultiSelectAppBar extends StatelessWidget {
  const MultiSelectAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            context.read<MultiSelect>().changeMode();
            context.read<MultiSelect>().clear();
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        const Text(
          //selected to rebuild
          'Selected',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(
          width: 4,
        ),
        ElementsCountComponent(
            count: context
                .select<MultiSelect, int>((value) => value.checkSet.length)),
      ],
    );
  }
}
