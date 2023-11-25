import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letstalk/locator.dart';
import 'package:letstalk/ui/cubit/allChatCubit.dart';
import 'package:letstalk/ui/cubit/authCubit.dart';
import 'package:letstalk/ui/cubit/messageCubit.dart';
import 'package:letstalk/ui/cubit/profileCubit.dart';
import 'package:letstalk/ui/cubit/usersCubit.dart';
import 'package:letstalk/ui/views/landingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => UsersCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => MessageCubit()),
        BlocProvider(create: (context) => AllChatCubit()),
      ],
      child: MaterialApp(
        title: "Let's Talk About It",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
          useMaterial3: true,
        ),
        home: const LandingPage(),
      
      ),
    );
  }
}

