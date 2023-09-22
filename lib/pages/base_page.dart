import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/models/notes_data.dart';
import 'package:notes_app/ui_components/main_page/welcome_text.dart';
import 'package:notes_app/view_models/multi_select_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import '../constants/style_constants.dart';
import '../ui_components/main_page/main_page_action_widget.dart';
import '../ui_components/main_page/multi_select_page/multi_select_app_bar.dart';
import '../ui_components/main_page/note_card/cards_view.dart';
import 'package:notes_app/ui_components/main_page/buttons/main_page_top_actions.dart';

import '../ui_components/main_page/group_list.dart';

//TODO
//decent dispose
//Current App state isnt satisfying the UI isnt as i imagined the app is slow
//cuz i had too many computations and layers as well as I've done too much refactoring
//and such little reusability where i can edit each one but i cant edit common things
//becuase i wasnt able to identify common stuff to combine in one place
//IDK i wont try to improve this is as far as i can get atm
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool _initialized = false;

  customInit() {
    //to ensure everything is built and not perform inconsistencies
    //in the context
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<NotesViewModel>(context, listen: false).init();
      await Provider.of<NotesViewModel>(context, listen: false).addNote(Note(
          createdAt: DateTime.now(),
          noteData: NoteData(
              title: 'test noteView',
              body: 'wahtevere',
              description:
                  'this is a logn description to repressent my notes capabilitesnhhhhhhhhhhhhhhhhhhhhnhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
              color: Constants.listOfColors[Random().nextInt(5)])));
    });
    setState(() {
      _initialized = true;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final modalRoute = ModalRoute.of(context)?.isActive;
    print('modalRoute ffs:$modalRoute');
    if (modalRoute != null && modalRoute && !_initialized) {
      print('initing first time ever');
      customInit();
    }
  }

  //single instance of the Noterepo so initializing here would give an initialized instance to all
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MultiSelect(), child: const SafeArea(child: MainPage()));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

//TODO
//add remove group button on non multiselectPage
//list of notes is read from the viewmodel
//add delete functionality
//add selectAll
//add removeFromGroup button
//add triple dots bar
//finally the editing page i think
class _MainPageState extends State<MainPage> {
  final Random rand = Random();

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
                      children: [MainPageTopButtons(), GroupTextIdentifier()],
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
            //TODO
            //add button
            alignment: Alignment.bottomCenter,
            child: PageActions(multiSelect: multiSelect),
          ),
        ],
      ),
    );
  }
}
