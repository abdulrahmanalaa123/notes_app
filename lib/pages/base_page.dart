import 'package:flutter/material.dart';
import 'package:notes_app/view_models/multi_select_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import '../ui_components/main_page/main_page_layout.dart';

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
    });
    setState(() {
      _initialized = true;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context)?.isActive;
    if (modalRoute != null && modalRoute && !_initialized) {
      customInit();
    }
  }

  //single instance of the Noterepo so initializing here would give an initialized instance to all
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MultiSelect(),
        child: const SafeArea(child: MainPageLayout()));
  }
}
