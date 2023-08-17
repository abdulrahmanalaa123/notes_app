import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/enums/login_state.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/pages/auth_pages/landing_page.dart';
import 'constants/style_constants.dart';
import 'view_models/auth_view_model/auth_controller_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (_) => AuthController(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final currenState = Provider.of<AuthController>(context).loginState;
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Constants.yellow),
            useMaterial3: true,
            fontFamily: 'Lufga'),
        //rebuilding the app if the user logs in or logs logs out
        home: Consumer<AuthController>(
          builder: (context, auth, child) {
            return auth.loginState != LoginState.loggedIn
                //reason its wrapped on the landing page and not multiple providers
                // is because the controllers will be of no use If we're logged in from cache
                //plus using the change notifier on some random part should work and would be used at some point
                //so looking up it's errors would be useful now
                ? LandingPage()
                : Placeholder(
                    color: Constants.beige,
                    child: TextButton(
                      child: const Text('SignOut'),
                      onPressed: () async {
                        await auth.SignOut();
                      },
                    ),
                  );
          },
        ));
  }
}
