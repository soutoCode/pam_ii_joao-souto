enum TheTheme{light,dark}

extension ThemeLabel on TheTheme{
  String get label{
    switch(this){
      case TheTheme.light:
        return 'Tema claro';
      case TheTheme.dark:
        return 'Tema escuro';
    }
  }
}
