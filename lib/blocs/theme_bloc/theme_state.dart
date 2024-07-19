class ThemeState {
  bool isTheme;

  ThemeState({
    required this.isTheme,
  });
  ThemeState  copyWith({bool? isTheme}){
    return ThemeState(isTheme: isTheme ?? this.isTheme);

  }
  static ThemeState initialValue()=> ThemeState(isTheme: false);
}
