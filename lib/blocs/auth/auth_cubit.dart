import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firebase_auth_services.dart';
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.login(email, password);
      User? user = _authService.authService.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError("User not found."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }



  Future<void> register(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.register(email, password);
      User? user = _authService.authService.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError("User not found."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthLoggedOut());
  }
}



