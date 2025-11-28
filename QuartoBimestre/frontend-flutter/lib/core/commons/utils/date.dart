import 'package:timeago/timeago.dart' as timeago;

List<String> daysOfWeek=[
  'Domingo',
  'Segunda-Feira',
  'Terca-Feira',
  'Quarta-Feira',
  'Quinta-Feira',
  'Sexta-Feira',
  'Sábado',
];

List<String> months=[
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

String formatDueDate(DateTime dueDate){
  final String dayOfWeek=daysOfWeek[dueDate.weekday].substring(0,3);
  final String month=months[dueDate.month-1].substring(0,3);
  final String day=dueDate.day.toString();

  return '$dayOfWeek, $month $day';
}

bool sameDate(DateTime a,DateTime b){
  return a.year==b.year&&a.month==b.month&&a.day==b.day;
}

bool isBeforeDateOnly(DateTime a,DateTime b){
  final normalizedA=DateTime(a.year,a.month,a.day);
  final normalizedB=DateTime(b.year,b.month,b.day);

  return normalizedA.isBefore(normalizedB);
}

String formatCreatedAt(DateTime t){
  timeago.setLocaleMessages('pt_BR',timeago.PtBrMessages());
  return timeago.format(t,locale:'pt_BR');
}

String getCurrentMonth(DateTime day){
  return months[day.month-1];
}
