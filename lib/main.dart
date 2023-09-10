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

//when i was signed in already it read as if the user was null which is kind of weird needs checking
//I dont understand proxy provider or either it doesnt work as advertised the user is null
//when its opened from cache in the notesviewmodel
//as well as i havent figured a neat way to initialize a listenable provider i might initialize on each needed part which is the right thing
//but the consumer was a solution which solved everything and it doesnt work there so that is my thought of mimicking that functionality

//TODO
//implement decent provider listeners and readers on widgets either each widget would be a child of a consumer probably
//fix the proxy provider bugs and the non synchronous userId values
//if it fixes the behaviour on launch on cached user then ok if not figure out a solution for that
//try to figure out the disposing of the database after logging out and opening on signing in
//which should be in the update method of proxy provider but it doesnt work so its soon to be figured out

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

  runApp(ChangeNotifierProvider(
      create: (_) => AuthController(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Constants.yellow),
            useMaterial3: true,
            fontFamily: 'Lufga'),
        //rebuilding the app if the user logs in or logs logs out
        home: Consumer<AuthController>(builder: (context, auth, child) {
          return auth.loginState != LoginState.loggedIn
              //reason its wrapped on the landing page and not multiple providers
              // is because the controllers will be of no use If we're logged in from cache
              //plus using the change notifier on some random part should work and would be used at some point
              //so looking up it's errors would be useful now

              ? const LandingPage()
              : ChangeNotifierProvider(
                  create: (_) => NotesViewModel(),
                  child: BasePage(),
                );
        }));
  }
}
