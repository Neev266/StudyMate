import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const SignupState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  SignupState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}
