import 'package:flutter/material.dart';
import 'package:notes_app/ui_components/main_page/welcome_text.dart';
import 'package:provider/provider.dart';

import '../../constants/style_constants.dart';
import '../../view_models/multi_select_provider.dart';
import 'buttons/main_page_top_actions.dart';
import 'group_list.dart';
import 'main_page_action_widget.dart';
import 'multi_select_page/multi_select_app_bar.dart';
import 'note_card/cards_view.dart';

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  @override
  Widget build(BuildContext context) {
    //using select is to select the specific multiSelect bool
    //idk if i should use watch but i feel that i use watch when whenever the
    //viewmodel is changed and i wont need anychange to rebuild the main widget
    //and all is rebuilt inside using distinct values
    //i feel that this is the better less expensive option
    //if so why would you use watch in general?
    //maybe if you need an instance and will be reused
    final bool multiSelect =
        context.select<MultiSelect, bool>((val) => val.isMultiSelectEnabled);

    return Scaffold(
      //tofIx the keyboard in the addGroup dialog
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backGround,
      body: Stack(
        children: [
          if (!multiSelect)
            const Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(child: MainPageTopButtons()),
                        Expanded(child: GroupTextIdentifier())
                      ],
                    )),
                Expanded(flex: 1, child: GroupsList()),
                Expanded(
                  flex: 6,
                  child: NoteView(
                    gridState: true,
                  ),
                ),
              ],
            )
          else
            WillPopScope(
              onWillPop: () async {
                context.read<MultiSelect>().changeMode();
                context.read<MultiSelect>().clear();
                return false;
              },
              child: const Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: MultiSelectAppBar(),
                  ),
                  Expanded(
                    flex: 8,
                    child: NoteView(
                      gridState: true,
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PageActions(multiSelect: multiSelect),
          ),
        ],
      ),
    );
  }
}
