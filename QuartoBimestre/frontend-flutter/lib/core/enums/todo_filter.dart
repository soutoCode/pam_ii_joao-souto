enum TodoFilter{
  all,
  today,
  thisWeek,
  overdue,
}

extension TodoFilterLabel on TodoFilter{
  String get label{
    switch(this){
      case TodoFilter.all:
        return 'Todos';
      case TodoFilter.today:
        return 'Hoje';
      case TodoFilter.thisWeek:
        return 'Esta semana';
      case TodoFilter.overdue:
        return 'Atrasados';
    }
  }
}
