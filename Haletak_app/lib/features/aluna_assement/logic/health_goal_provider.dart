// lib/logic/providers/health_goal_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routing/routes.dart';
import '../data/service/health_goal_service.dart';

// Create a provider for the HealthGoalService
final healthGoalServiceProvider = Provider<HealthGoalService>((ref) {
  return HealthGoalService();
});

// Create a state class to hold the health goal state
class HealthGoalState {
  final String selectedGoal;
  final bool isLoading;
  final String errorMessage;

  HealthGoalState({
    this.selectedGoal = '',
    this.isLoading = false,
    this.errorMessage = '',
  });

  // Create a copy of the state with some values changed
  HealthGoalState copyWith({
    String? selectedGoal,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HealthGoalState(
      selectedGoal: selectedGoal ?? this.selectedGoal,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Create a notifier class to manage the state
class HealthGoalNotifier extends StateNotifier<HealthGoalState> {
  final HealthGoalService _healthGoalService;

  HealthGoalNotifier(this._healthGoalService) : super(HealthGoalState());

  // Set selected goal
  void setGoal(String goal) {
    state = state.copyWith(selectedGoal: goal);
  }

  // Save goal to Firebase
  Future<void> saveGoalToFirebase(BuildContext context) async {
    if (state.selectedGoal.isEmpty) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: '');

      await _healthGoalService.saveHealthGoal(state.selectedGoal);

      if (context.mounted) {
        Navigator.pushNamed(context, Routes.genderSelectionScreen);
      }
    } catch (e) {
      state =
          state.copyWith(errorMessage: 'Failed to save goal: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Initialize with existing goal if available
  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      final latestGoal = await _healthGoalService.getLatestHealthGoal();
      if (latestGoal != null) {
        state = state.copyWith(selectedGoal: latestGoal.goalType);
      }
    } catch (e) {
      state =
          state.copyWith(errorMessage: 'Failed to load goal: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// Create the provider
final healthGoalProvider =
    StateNotifierProvider<HealthGoalNotifier, HealthGoalState>((ref) {
  final service = ref.watch(healthGoalServiceProvider);
  return HealthGoalNotifier(service);
});
