import 'package:konkurs_app/models/event.dart';

List<EventTypeModel> getEventTypes() {
  List<EventTypeModel> events = new List();
  EventTypeModel eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/crystal.png";
  eventModel.eventType = "Все конкурсы";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/rewards.png";
  eventModel.eventType = "Мои участия";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/banner1.png";
  eventModel.eventType = "Завершенные";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  return events;
}
