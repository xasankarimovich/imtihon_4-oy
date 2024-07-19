import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/event_state_event.dart';

class SearchEvent extends StatefulWidget {
  const SearchEvent({super.key});
  @override
  State<SearchEvent> createState() => _SearchEventState();
}
class _SearchEventState extends State<SearchEvent> {
  TextEditingController textController = TextEditingController();
  void _onSearchChanged() {
    context.read<EventBloc>().add(EventSearch(textController.text));
  }
  @override
  Widget build(BuildContext context) {
    return AnimSearchBar(
      width: 400,
      textController: textController,
      onSuffixTap: () {
        setState(() {
          textController.clear();
          context.read<EventBloc>().add(FetchEvent());
        });
      },
      onSubmitted: (String value) {
        _onSearchChanged();
      },
    );
  }
}
