// lib/logic/providers/gender_selection_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/service/user_profile_service.dart';

// Gender selection state
class GenderSelectionState {
  final String selectedGender;
  final bool isLoading;
  final String errorMessage;

  GenderSelectionState({
    this.selectedGender = '',
    this.isLoading = false,
    this.errorMessage = '',
  });

  GenderSelectionState copyWith({
    String? selectedGender,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GenderSelectionState(
      selectedGender: selectedGender ?? this.selectedGender,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Provider for UserProfileService
final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});

// Gender selection notifier
class GenderSelectionNotifier extends StateNotifier<GenderSelectionState> {
  final UserProfileService _userProfileService;

  GenderSelectionNotifier(this._userProfileService)
      : super(GenderSelectionState());

  // Set selected gender
  void setGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  // Save gender to Firebase
  Future<void> saveGenderToFirebase(BuildContext context) async {
    if (state.selectedGender.isEmpty) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: '');

      await _userProfileService.updateUserGender(state.selectedGender);

      if (context.mounted) {
        Navigator.pushNamed(context, '/ageSelectionScreen');
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to save gender: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      final userProfile = await _userProfileService.getUserProfile();
      if (userProfile != null && userProfile.gender.isNotEmpty) {
        state = state.copyWith(selectedGender: userProfile.gender);
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to load profile: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final genderSelectionProvider =
    StateNotifierProvider<GenderSelectionNotifier, GenderSelectionState>((ref) {
  final service = ref.watch(userProfileServiceProvider);
  return GenderSelectionNotifier(service);
});
