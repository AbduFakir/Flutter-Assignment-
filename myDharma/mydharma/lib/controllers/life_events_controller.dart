import '../models/life_event.dart';
import '../services/dharma_data_service.dart';

class LifeEventsController {
  const LifeEventsController({this.service = const DharmaDataService()});

  final DharmaDataService service;

  List<LifeEvent> get events => service.getFeaturedEvents();
}
