import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtihon_4oyuchun/ui/screens/my_event_screen/my_event_screen.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/theme_bloc/theme_blocs.dart';
import '../../cubit/user/user_cubit.dart';
import '../../cubit/user/user_state.dart';
import '../../data/models/forms_status.dart';
import '../../utils/image_path/images_path.dart';
import '../screens/home_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: state.isTheme ? Colors.black : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocBuilder<UserCubit, UserState>(
                builder: (context, states) {
                  return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: state.isTheme ? Colors.white10 : Colors.grey[900],
                    ),
                    onDetailsPressed: () {},
                    accountEmail: const Text('xasanKarimovich0033@gmail.com'),
                    accountName: Text(states.status.name),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: AssetImage(
                        AppImages.onHasan,
                      ),

                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                ),
                title: const Text(
                  'Home',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return HomeScreen();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cable_rounded,
                ),
                title: const Text('my_event_screen'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const MyEventsScreen();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lightbulb,
                ),
                title: const Text(
                  'Change Theme',
                ),
                onTap: () {
                  bool isDarkTheme = !state.isTheme;
                  context.read<ThemeCubit>().checkTheme(isDarkTheme);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout,
                    color: state.isTheme ? Colors.white : Colors.black),
                title: Text('Logout',
                    style: TextStyle(
                        color: state.isTheme ? Colors.white : Colors.black)),
                onTap: () {
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
