import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'add_note.dart';

//TODO
//decent dispose
//research difference between select and watch cuz i dont remember
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool initialized = false;

  customInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<NotesViewModel>(context, listen: false).init();
    });
    setState(() {
      initialized = true;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final modalRoute = ModalRoute.of(context)?.isActive;
    print('modalRoute ffs:$modalRoute');
    if (modalRoute != null && modalRoute && !initialized) {
      print('initing first time ever');
      customInit();
    }
  }

  //single instance of the Noterepo so initializing here would give an initialized instance to all
  @override
  Widget build(BuildContext context) {
    print('rebuilding basePage');
    final notesList = context.watch<NotesViewModel>().notesList;
    return Scaffold(
        appBar: AppBar(
          title: const Text('NotesApp'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: TextButton(
                  child: const Text('SignOut'),
                  onPressed: () async {
                    await Provider.of<AuthController>(context, listen: false)
                        .SignOut();
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TestingNote()));
                    if (context.mounted) {
                      print(context.read<AuthController>().currentUser?.id);
                    }
                    print(await context.read<NotesViewModel>().addNote(result));
                    print(await context.read<NotesViewModel>().notesList);
                  },
                  child: const Text('Test Button'),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  //this doesnt rebuild on notesList change
                  //issue was using select instead of watch
                  //but it works which is most important
                  child: notesList != null && notesList.isNotEmpty
                      ? ListView.builder(
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            return Wrap(
                              children: [
                                Text(notesList[index].noteData.title ?? 'null'),
                                Text(notesList[index].noteData.body ?? 'null'),
                                Text(notesList[index].noteData.description ??
                                    'null'),
                              ],
                            );
                          })
                      : const Text('empty list'),
                ),
              ),
            ],
          ),
        ));
  }
}