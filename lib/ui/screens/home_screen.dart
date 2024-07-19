import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtihon_4oyuchun/ui/screens/registration_screen/evemt_detail_screen.dart';
import 'package:imtihon_4oyuchun/utils/extension/extension.dart';
import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/event_state_event.dart';
import '../../blocs/event/event_state_state.dart';
import '../../data/models/forms_status.dart';
import '../../utils/image_path/images_path.dart';
import '../../utils/style/app_text_style.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/event_widget.dart';
import '../widgets/search_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _initEvent() {
    context.read<EventBloc>().add(FetchEvent());
  }

  @override
  void initState() {
    Future.microtask(() {
      debugPrint(
          '__________________________________________________________________- maulumot olishga kiridi');
      _initEvent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Home Screen'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SearchEvent(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yaqin yetti kun ichida',
                style: AppTextStyle.semiBold.copyWith(color: Colors.white),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return EventDetailsScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    AppImages.onMoon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Barcha tadbirlar',
                style: AppTextStyle.regular.copyWith(color: Colors.white),
              ),
              BlocBuilder<EventBloc, EventState>(
                bloc: context.read<EventBloc>()..add(FetchEvent()),
                builder: (context, state) {
                  if (state.status == FormsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == FormsStatus.error) {
                    return Center(child: Text(state.errorMessage));
                  }
                  if (state.status == FormsStatus.success) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.eventData.length,
                      itemBuilder: (context, index) {
                        final event = state.eventData[index];
                        return ListTile(
                          title: Text(event.name),
                          subtitle: Text(event.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Tahrirlash tugmasi bosilganda

                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  // O'chirish tugmasi bosilganda
                                  _showDeleteConfirmationDialog(event.uid);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                          leading: event.imageUrl.isNotEmpty
                              ? Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(event.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              : null,
                          onTap: () {
                            // Navigate to event details screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return EventDetailsScreen(); // EventDetailsScreen-ni tanlangan event bilan ochish
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No events found'));
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) {
                return CreateEventScreen();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // O'chirish tasdiqlash dialogini ko'rsatish funksiyasi
  void _showDeleteConfirmationDialog(String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tadbirni o\'chirish'),
          content: Text('Siz ushbu tadbirni o\'chirishni xohlaysizmi?'),
          actions: <Widget>[
            TextButton(
              child: Text('Bekor qilish'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
            ),
            TextButton(
              child: Text('O\'chirish'),
              onPressed: () {
                context.read<EventBloc>().add(DeleteEvent(eventId)); // DeleteEvent hodisasi qo'shish
                Navigator.of(context).pop(); // Dialogni yopish
              },
            ),
          ],
        );
      },
    );
  }
}
