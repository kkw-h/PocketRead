import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String serverUrl;
  final String apiKey;
  const AuthAuthenticated(this.serverUrl, this.apiKey);
  @override
  List<Object?> get props => [serverUrl, apiKey];
}
class AuthUnauthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}
class AuthLoginRequested extends AuthEvent {
  final String serverUrl;
  final String apiKey;
  const AuthLoginRequested(this.serverUrl, this.apiKey);
}
class AuthLogoutRequested extends AuthEvent {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;
  
  AuthBloc(this._prefs) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final url = _prefs.getString('server_url');
    final key = _prefs.getString('api_key');
    
    if (url != null && key != null && url.isNotEmpty && key.isNotEmpty) {
      emit(AuthAuthenticated(url, key));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Verify connection with ApiClient here
      await _prefs.setString('server_url', event.serverUrl);
      await _prefs.setString('api_key', event.apiKey);
      emit(AuthAuthenticated(event.serverUrl, event.apiKey));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _prefs.remove('server_url');
    await _prefs.remove('api_key');
    emit(AuthUnauthenticated());
  }
}
