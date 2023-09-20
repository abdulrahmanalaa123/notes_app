import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/ui_components/main_page/welcome_text.dart';
import 'package:notes_app/view_models/multi_select_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import '../constants/style_constants.dart';
import '../models/notes.dart';
import '../ui_components/main_page/cards_view.dart';
import 'package:notes_app/ui_components/main_page/top_button.dart';

import '../ui_components/main_page/group_list.dart';
import '../ui_components/main_page/multi_select_app_bar.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<NotesViewModel>(context, listen: false).init();
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

class _MainPageState extends State<MainPage> {
  final Random rand = Random();

  @override
  Widget build(BuildContext context) {
    final bool multiSelect = context.watch<MultiSelect>().isMultiSelectEnabled;

    return Scaffold(
      backgroundColor: Constants.backGround,
      body: Stack(
        children: [
          if (!multiSelect)
            const Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        MainPageTopButtons(),
                        GroupTextIdentifier(group: 'All')
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
            //TODO
            //add button
            alignment: Alignment.bottomCenter,
            child: GlassContainer(
              blur: 5,
              opacity: 0.3,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(bottom: 16),
              child: !multiSelect
                  ? const PlusButton()
                  : const MultiSelectButtons(),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  const GlassContainer(
      {required this.blur,
      required this.opacity,
      required this.child,
      required this.padding,
      required this.margin,
      super.key});
  final double blur;
  final double opacity;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  const PlusButton({this.buttonFunc, super.key});
  final void Function()? buttonFunc;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: buttonFunc ?? () {},
      icon: const Icon(
        CupertinoIcons.add,
        color: Colors.white,
        size: 30,
      ),
      style: IconButton.styleFrom(backgroundColor: Colors.black),
    );
  }
}

class MultiSelectButtons extends StatelessWidget {
  const MultiSelectButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //not satisfied with this solution
      constraints: const BoxConstraints(maxHeight: 85, maxWidth: 158),
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.delete,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(backgroundColor: Colors.black),
              ),
              const Text('delete'),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.select_all,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(backgroundColor: Colors.black),
              ),
              const Text('Select All'),
            ],
          ),
        ],
      ),
    );
  }
}
