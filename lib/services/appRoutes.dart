import 'package:assyifa_chatbot/component/add_event.dart';
import 'package:assyifa_chatbot/component/event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String addEvent = "add_event";
  static const String editEvent = "edit_event";
  static const String viewEvent = "view_event";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          switch (settings.name) {
            case editEvent:
              return AddEventPage(event: settings.arguments);
            case viewEvent:
              return EventDetails(event: settings.arguments);
            case addEvent:
              return AddEventPage(
                selectedDate: settings.arguments,
              );
            default:
              return null;
          }
        });
  }
}
