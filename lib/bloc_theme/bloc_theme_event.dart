enum TypeEvent { green, red, blue, black, tor, teal }

class EventTheme {
  TypeEvent eventType;
  EventTheme.green({this.eventType = TypeEvent.green});
  EventTheme.red({this.eventType = TypeEvent.red});
  EventTheme.blue({this.eventType = TypeEvent.blue});
  EventTheme.black({this.eventType = TypeEvent.black});
  EventTheme.tor({this.eventType = TypeEvent.tor});
  EventTheme.teal({this.eventType = TypeEvent.teal});
}
