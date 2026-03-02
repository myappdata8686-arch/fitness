enum AppEventType {
  ritualUpdated,
  spiritualUpdated,
  healthUpdated,
  journeyUpdated,
  daySelected,
  weekClosed,
  manualRecalculate,
}

class AppEvent {
  const AppEvent({required this.type, this.payload});

  final AppEventType type;
  final dynamic payload;
}
