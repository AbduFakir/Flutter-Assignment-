import '../models/home_life_event.dart';
import '../models/life_event.dart';
import '../services/dharma_data_service.dart';

class HomeController {
  const HomeController({this.service = const DharmaDataService()});

  final DharmaDataService service;

  List<LifeEvent> get featuredEvents => service.getFeaturedEvents();

  List<HomeLifeEvent> get todayEvents => service.getHomeLifeEvents();
}
