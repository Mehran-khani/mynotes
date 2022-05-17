import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    //registering
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.register(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateVerifyEmail(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoadin: false,
          ));
        }
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(
          exception: null,
          isLoadin: false,
        ));
      },
    );
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateVerifyEmail(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });
    //login
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while you are loging in'));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(const AuthStateVerifyEmail(isLoading: false));
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(const AuthStateUninitialized(isLoading: false));
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
