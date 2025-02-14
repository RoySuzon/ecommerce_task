// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:ecommerce/core/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/core/services/secure_storage.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/domain/usecases/auth_use_case.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase useCase;
  final SecureStorageService secureStorageService;
  AuthBloc({required this.useCase, required this.secureStorageService})
    : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(LoginLoading());
      await useCase
          .loginUseCase(event.email, event.passaword)
          .then(
            (result) => result.fold(
              (faild) {
                emit(LoginFailed(failure: faild));
              },
              (success) async {
                await secureStorageService
                    .saveToken(success['token'])
                    .whenComplete(
                      () => emit(LoginSuccess(message: success['message'])),
                    );
              },
            ),
          );
    });
    on<AuthLogoutEvent>((event, emit) async {
      final res = await useCase.logoutUseCase();
      await secureStorageService.deleteToken();

      if (res) {
        emit(LogoutSuccess());
      } else {
        log('Something going wrong!');
        emit(LogoutFaild(failure: Failure('Something going wrong!')));
      }
    });
  }
}
