import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtihon_4oyuchun/ui/login_screen/register_screen.dart';
import 'package:imtihon_4oyuchun/utils/extension/extension.dart';
import 'package:imtihon_4oyuchun/utils/image_path/images_path.dart';
import 'package:imtihon_4oyuchun/utils/style/app_text_style.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../cubit/user/user_cubit.dart';
import '../screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<bool> isFormFilled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateFormStatus);
    passwordController.addListener(_updateFormStatus);
  }

  void _updateFormStatus() {
    isFormFilled.value =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  void submit() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      context.read<AuthCubit>().login(
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,color: CupertinoColors.white
                      ),
                    ),
                    20.boxH(),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",labelStyle: TextStyle(fontSize: 19,color: Colors.white),
                      ),
                    ),
                    20.boxH(),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",labelStyle: TextStyle(fontSize: 19,color: Colors.white),
                      ),
                      obscureText: true,
                    ),
                    20.boxH(),
                    ValueListenableBuilder<bool>(
                      valueListenable: isFormFilled,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                            ),
                            child: const Text("LOGIN"),
                          )
                              : Container(),
                        );
                      },
                    ),
                    20.boxH(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child:  Text("Sign Up",style: AppTextStyle.medium.copyWith(color: CupertinoColors.white),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      listenWhen: (oldState, currentState) {
        if (currentState is AuthAuthenticated || currentState is AuthError) {
          return true;
        } else {
          return false;
        }
      },
      listener: (BuildContext context, AuthState state) {
        if (state is AuthAuthenticated) {
          context.read<UserCubit>().fetchUserDocId();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Login Error"),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"),
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
    super.dispose();
  }
}
