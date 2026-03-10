import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ConnectivityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> result;
  ConnectivityChanged(this.result);

  @override
  List<Object> get props => [result];
}

// State
class ConnectivityState extends Equatable {
  final bool isConnected;
  const ConnectivityState({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

// Bloc
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityBloc(this._connectivity)
    : super(const ConnectivityState(isConnected: true)) {
    on<ConnectivityChanged>((event, emit) {
      final isConnected = !event.result.contains(ConnectivityResult.none);
      emit(ConnectivityState(isConnected: isConnected));
    });

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      add(ConnectivityChanged(result));
    });

    // Initial check
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    add(ConnectivityChanged(result));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
