import '../services/dharma_data_service.dart';

class BundleController {
  const BundleController({this.service = const DharmaDataService()});

  final DharmaDataService service;

  List<String> get bundles => service.getBundleItems();
}
