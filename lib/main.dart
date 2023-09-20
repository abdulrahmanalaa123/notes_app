import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/enums/login_state.dart';
import 'package:notes_app/pages/base_page.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/pages/auth_pages/landing_page.dart';
import 'constants/style_constants.dart';
import 'view_models/auth_view_model/auth_controller_provider.dart';
import 'firebase_options.dart';

//and a decent implementation might be left as is or
// wrapping the basePage with a provider using the consumer of auth
//on second thoughts this is a good implementation will be tested tmrw

// runApp(MultiProvider(providers: [
// ChangeNotifierProvider(create: (_) => AuthController()),
// ChangeNotifierProxyProvider<AuthController, NotesViewModel>(
// create: (BuildContext context) => NotesViewModel(
// //nullable user which makes sense
// //it changed the whole levels of the code but still makes sense
// //i feel like everything is falling apart
// userId: Provider.of<AuthController>(context, listen: false)
//     .currentUser
//     ?.id),
// update: (cote, auth, noteView) {
// noteView?.updateUser(auth.currentUser?.id);
// return noteView;
// })
// ], child: MyApp()));
//https://github.com/rrousselGit/provider/issues/519
//same issue with this implementation

//so after testing the id is null thing isnt related to proxy provider
//all it does is create and update at the same time
//I dont know what is the issue with it and with the database being randomly closed
//both issues needs to be fixeds
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthController()),
    ChangeNotifierProvider(create: (_) => NotesViewModel())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthController>().loginState;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Constants.yellow),
          useMaterial3: true,
          fontFamily: 'Lufga'),
      //rebuilding the app if the user logs in or logs logs out
      home: state != LoginState.loggedIn
          //reason its wrapped on the landing page and not multiple providers
          // is because the controllers will be of no use If we're logged in from cache
          //plus using the change notifier on some random part should work and would be used at some point
          //so looking up it's errors would be useful now

          ? const LandingPage()
          : const BasePage(),
    );
  }
}

//dead code
//class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

//final NotesViewModel notesViewModel = NotesViewModel();
//  //single instance of the Noterepo so initializing here would give an initialized instance to all
//  //providers
//  final _noteRepo = NoteRepo();
//  @override
//  void initState() {
//    super.initState();
//    WidgetsBinding.instance.addObserver(this);
//    Future.microtask(() => _noteRepo.init());
//  }
////
//  @override
//  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//    print('this is the app state: $state');
//    switch (state) {
//      case AppLifecycleState.resumed:
//        await _noteRepo.init();
//        break;
//      case AppLifecycleState.paused:
//        await _noteRepo.dispose();
//        break;
//      default:
//        break;
//    }
//  }
////
//  @override
//  Future<bool> didPopRoute() async {
//    await _noteRepo.dispose();
//    return super.didPopRoute();
//  }
////
//  @override
//  void dispose() {
//    Future.microtask(() => _noteRepo.dispose());
//    WidgetsBinding.instance.removeObserver(this);
//    super.dispose();
//  }
//
//  @override
//  //reason database isnt closed in the basePage or in the disposal of the providers
//  //is 1- its used in all
//  //2-when pushing new routes it goes out of the tree and disposes the widgets so hence the provider so it closes the database prematurely
//  //3-the desired behaviour isnt achieved except in this way
//  Widget build(BuildContext context) {
//    final state = context.watch<AuthController>().loginState;
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//          colorScheme: ColorScheme.fromSeed(seedColor: Constants.yellow),
//          useMaterial3: true,
//          fontFamily: 'Lufga'),
//      //rebuilding the app if the user logs in or logs logs out
//      home: state != LoginState.loggedIn
//      //reason its wrapped on the landing page and not multiple providers
//      // is because the controllers will be of no use If we're logged in from cache
//      //plus using the change notifier on some random part should work and would be used at some point
//      //so looking up it's errors would be useful now
//
//          ? const LandingPage()
//          //even with changeNotifierProvider.value and using 1 instance it for some reason
//initializes two instances when changing to this page after logging in

//          : ChangeNotifierProvider.value(
//          value: notesViewModel, child: const BasePage()),
//    );
//  }
//}
//
