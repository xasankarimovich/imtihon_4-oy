import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtihon_4oyuchun/utils/image_path/images_path.dart';
import 'package:lottie/lottie.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../cubit/user/user_cubit.dart';
import '../../data/models/user/user_model.dart';
import '../screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final ValueNotifier<bool> isPasswordConfirmed = ValueNotifier<bool>(false);
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(notification.title!),
              content: Text(notification.body!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });

    passwordConfirmationController.addListener(() {
      isPasswordConfirmed.value = passwordController.text ==
          passwordConfirmationController.text &&
          passwordConfirmationController.text.isNotEmpty;
    });
  }

  void submit() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      context.read<AuthCubit>().register(
        emailController.text,
        passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: Lottie.asset(
                  AppImages.onJson,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Parol",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordConfirmationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Parolni tasdiqlang",
                        ),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<bool>(
                        valueListenable: isPasswordConfirmed,
                        builder: (context, value, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: double.infinity,
                            height: value ? 50 : 0,
                            child: value
                                ? FilledButton(
                              onPressed: submit,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text("CREATE ACCOUNT"),
                            )
                                : Container(),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listenWhen: (oldState, currentState) {
        return currentState is AuthAuthenticated || currentState is AuthError;
      },
      listener: (BuildContext context, AuthState state) {
        if (state is AuthAuthenticated) {
          UserModel userModel = UserModel(
            firstName: 'firstName',
            lastName: 'lastName',
            email: emailController.text,
            password: passwordController.text,
            myEvent: [],
            isLiked: [],
            attendanceEvent: [],
            lateEvent: [],
            fcmToken: '',
            uid: '',
          );
          context.read<UserCubit>().insertUser(userModel: userModel);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Registration Error"),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}



class MessageArguments {
  final RemoteMessage message;
  final bool fromNotification;

  MessageArguments(this.message, this.fromNotification);
}
