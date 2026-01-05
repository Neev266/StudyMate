import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_handleFirebaseLogin);
  }

  Future<void> _handleFirebaseLogin(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_firebaseErrorMessage(e)));
    } catch (e) {
      emit(LoginFailure("Something went wrong. Try again."));
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "Invalid email address.";
      case "user-disabled":
        return "Your account has been disabled.";
      case "user-not-found":
        return "No account found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
