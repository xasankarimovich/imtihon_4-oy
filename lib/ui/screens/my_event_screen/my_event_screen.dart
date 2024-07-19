import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtihon_4oyuchun/blocs/event/event_bloc.dart';
import 'package:imtihon_4oyuchun/data/models/forms_status.dart';
import 'package:imtihon_4oyuchun/utils/extension/extension.dart';
import 'package:imtihon_4oyuchun/utils/style/app_text_style.dart';
import '../../../blocs/event/event_state_state.dart';
import '../../../data/models/event_model/event.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My events'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.black,
          isScrollable: true,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          tabs: const [
            Tab(text: 'Tashkil qilganlarim'),
            Tab(text: 'Yaqinda'),
            Tab(text: 'Ishtirok etganlarim'),
            Tab(text: 'Bekor qilganlarim'),
          ],
        ),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (BuildContext context, EventState state) {
          if (state.status == FormsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
            children: [
              _buildTabContent(events: state.eventData),
              _buildTabContent(events: state.eventData),
              _buildTabContent(events: state.eventData),
              _buildTabContent(events: state.eventData),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent({
    required List<EventModel> events,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        final event = events[index];
        return Card(
          elevation: 20,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10.0),
            leading: event.imageUrl.isNotEmpty
                ? Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(event.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: AppTextStyle.regular
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
               5.boxH(),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    5.boxH(),

                    Text(
                      event.location,
                      style: AppTextStyle.regular
                          .copyWith(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                event.description,
                style: AppTextStyle.regular
                    .copyWith(fontSize: 14, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
