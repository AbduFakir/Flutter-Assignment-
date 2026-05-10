import 'package:get/get.dart';
import '../services/quote_service.dart';

class QuoteController extends GetxController {
  final _service = QuoteService();

  final quote = ''.obs;
  final author = ''.obs;
  final isLoading = true.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final result = await _service.fetchRandom();
      quote.value = result.quote;
      author.value = result.author;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
