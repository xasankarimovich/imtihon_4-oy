import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtihon_4oyuchun/services/firebase_auth_services.dart';
import 'package:imtihon_4oyuchun/services/geolocator_services.dart';
import 'package:imtihon_4oyuchun/services/my_observier.dart';
import 'package:imtihon_4oyuchun/splash_screen.dart';
import 'package:imtihon_4oyuchun/ui/login_screen/login_screen.dart';
import 'package:imtihon_4oyuchun/ui/screens/my_event_screen/my_event_screen.dart';
import 'blocs/auth/auth_cubit.dart';
import 'blocs/event/event_bloc.dart';
import 'blocs/theme_bloc/theme_blocs.dart';
import 'cubit/user/user_cubit.dart';
import 'firebase_options.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GeolocatorService.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(FirebaseAuthService()),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        BlocProvider<EventBloc>(
          create: (_) => EventBloc(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.isTheme ? ThemeData.dark() : ThemeData.light(),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

