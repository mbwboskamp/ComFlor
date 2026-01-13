import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

/// BLoC for handling trip tracking state
class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  TrackingBloc() : super(const TrackingState()) {
    on<TrackingStarted>(_onTrackingStarted);
    on<TrackingStopped>(_onTrackingStopped);
    on<TrackingPaused>(_onTrackingPaused);
    on<TrackingResumed>(_onTrackingResumed);
    on<TrackingLocationUpdated>(_onLocationUpdated);
    on<TrackingPrivacyZoneEntered>(_onPrivacyZoneEntered);
    on<TrackingPrivacyZoneExited>(_onPrivacyZoneExited);
  }

  Future<void> _onTrackingStarted(
    TrackingStarted event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(
      status: TrackingStatus.active,
      tripId: event.tripId,
      vehicleId: event.vehicleId,
      startTime: DateTime.now(),
      startKm: event.startKm,
    ));

    // TODO: Start location tracking service
  }

  Future<void> _onTrackingStopped(
    TrackingStopped event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(
      status: TrackingStatus.idle,
      endTime: DateTime.now(),
    ));

    // TODO: Stop location tracking service
    // TODO: Save trip data
  }

  Future<void> _onTrackingPaused(
    TrackingPaused event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(status: TrackingStatus.paused));
  }

  Future<void> _onTrackingResumed(
    TrackingResumed event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(status: TrackingStatus.active));
  }

  Future<void> _onLocationUpdated(
    TrackingLocationUpdated event,
    Emitter<TrackingState> emit,
  ) async {
    final newDistance = state.distance + event.distanceDelta;
    final newSpeed = event.speed;

    emit(state.copyWith(
      currentLatitude: event.latitude,
      currentLongitude: event.longitude,
      distance: newDistance,
      currentSpeed: newSpeed,
    ));
  }

  Future<void> _onPrivacyZoneEntered(
    TrackingPrivacyZoneEntered event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(
      isInPrivacyZone: true,
      currentPrivacyZoneId: event.zoneId,
    ));
  }

  Future<void> _onPrivacyZoneExited(
    TrackingPrivacyZoneExited event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(
      isInPrivacyZone: false,
      currentPrivacyZoneId: null,
    ));
  }
}
