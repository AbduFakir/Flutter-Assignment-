import '../services/dharma_data_service.dart';

class CalendarController {
  const CalendarController({this.service = const DharmaDataService()});

  final DharmaDataService service;

  List<String> get observances => service.getCalendarItems();
}
