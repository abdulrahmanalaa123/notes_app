import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class AddGroupDialog extends StatefulWidget {
  const AddGroupDialog({
    super.key,
  });

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  late final TextEditingController groupController;

  @override
  void initState() {
    groupController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //coudlve put it in an willpopscope but didnt
    //since i only return a value if it has text and pressed the button
    //and if not it would return null as the basic functionality of the showdialog
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            //TODO
            //do a better implementation for dynamic sizing
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
                color: Constants.beige,
                borderRadius: BorderRadius.circular(50)),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter Group Name'),
                TextField(
                  controller: groupController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () async {
                          final groupName = groupController.text;
                          if (groupName.isNotEmpty) {
                            Navigator.pop(context, groupName);
                          }
                        },
                        child: const Text('Add Group')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
