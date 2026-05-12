import 'package:intl/intl.dart';

abstract final class DateFormatters {
  static final shortMonthDay = DateFormat('MMM d');
  static final fullCeremonyDate = DateFormat('EEEE, MMMM d');
}
