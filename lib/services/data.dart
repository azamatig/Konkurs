import 'package:konkurs_app/models/date_model.dart';
import 'package:konkurs_app/models/event.dart';
import 'package:konkurs_app/models/event_type.dart';

List<DateModel> getDates() {
  List<DateModel> dates = new List<DateModel>();
  DateModel dateModel = new DateModel();

  //1
  dateModel.date = "10";
  dateModel.weekDay = "Sun";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "11";
  dateModel.weekDay = "Mon";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "12";
  dateModel.weekDay = "Tue";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "13";
  dateModel.weekDay = "Wed";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "14";
  dateModel.weekDay = "Thu";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "15";
  dateModel.weekDay = "Fri";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "16";
  dateModel.weekDay = "Sat";
  dates.add(dateModel);

  dateModel = new DateModel();

  return dates;
}

List<EventTypeModel> getEventTypes() {
  List<EventTypeModel> events = new List();
  EventTypeModel eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/concert.png";
  eventModel.eventType = "Все конкурсы";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/sports.png";
  eventModel.eventType = "Мои конкурсы";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/education.png";
  eventModel.eventType = "Завершенные";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  return events;
}

List<EventsModel> getEvents() {
  List<EventsModel> events = new List<EventsModel>();
  EventsModel eventsModel = new EventsModel();

  //1
  eventsModel.imgeAssetPath = "assets/images/tileimg.png";
  eventsModel.date = "Jan 22, 2021";
  eventsModel.desc = "Путевка в Дубай";
  eventsModel.address = "Путевка в Дубай на 2х";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //2
  eventsModel.imgeAssetPath = "assets/images/second.png";
  eventsModel.date = "Jan 22, 2021";
  eventsModel.desc = "Гив от Pegas";
  eventsModel.address = "Galaxyfields, Sector 22, Faridabad";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //3
  eventsModel.imgeAssetPath = "assets/images/music_event.png";
  eventsModel.date = "Jan 22, 2021";
  eventsModel.address = "Galaxyfields, Sector 22, Faridabad";
  eventsModel.desc = "Конкурс от Pegas Touristik";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  return events;
}
