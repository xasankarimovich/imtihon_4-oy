import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final bool isTheme;

  ThemeState(this.isTheme);

  @override
  List<Object?> get props => [isTheme];
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(false));

  void checkTheme(bool isDark) {
    emit(ThemeState(isDark));
  }
}
