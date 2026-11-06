/// "9:05 am", "12:30 pm". Small enough that pulling in intl isn't worth it.
String formatTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour < 12 ? 'am' : 'pm';
  return '$hour:$minute $period';
}
