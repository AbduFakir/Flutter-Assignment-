import '../core/constants/mock_data.dart';
import '../models/home_life_event.dart';
import '../models/life_event.dart';

class DharmaDataService {
  const DharmaDataService();

  List<LifeEvent> getFeaturedEvents() => MockData.featuredEvents;

  List<HomeLifeEvent> getHomeLifeEvents() => MockData.homeLifeEvents;

  List<String> getCalendarItems() => MockData.calendarItems;

  List<String> getBundleItems() => MockData.bundleItems;
}
