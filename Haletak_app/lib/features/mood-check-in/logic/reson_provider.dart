// lib/features/mood/logic/providers/mood_provider.dart
import 'package:aluna/features/mood-check-in/data/model/mood_reason.dart';
import 'package:aluna/features/mood-check-in/data/model/mood_state.dart';
import 'package:aluna/features/mood-check-in/data/service/reason_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moodStateProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return MoodNotifier(repository);
});

class MoodNotifier extends StateNotifier<MoodState> {
  final MoodRepository _repository;
  static const int _reasonsPerPage = 8;

  MoodNotifier(this._repository) : super(MoodState()) {
    _initializeReasons();
  }

  // Initialize reasons
  Future<void> _initializeReasons() async {
    state = state.copyWith(isLoading: true);

    try {
      // Get predefined or user reasons
      final allReasons = await _repository.getPredefinedReasons();

      // Get recently used reasons
      final recentlyUsedReasons = await _repository.getRecentlyUsedReasons();

      // Calculate displayed reasons (first page)
      final displayedReasons = _getPagedReasons(allReasons, 0);

      state = state.copyWith(
        allReasons: allReasons,
        recentlyUsedReasons: recentlyUsedReasons,
        displayedReasons: displayedReasons,
        isLoading: false,
      );
    } catch (e) {
      print('Error initializing reasons: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  // Get paged reasons
  List<MoodReason> _getPagedReasons(List<MoodReason> reasons, int page) {
    final startIndex = page * _reasonsPerPage;
    final endIndex = startIndex + _reasonsPerPage;

    if (startIndex < reasons.length) {
      return reasons.sublist(
          startIndex, endIndex < reasons.length ? endIndex : reasons.length);
    }

    return [];
  }

  // Update displayed reasons based on search or pagination
  void _updateDisplayedReasons() {
    if (state.searchQuery.isNotEmpty) {
      final filteredReasons = state.allReasons
          .where((reason) => reason.name
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase()))
          .toList();

      state = state.copyWith(displayedReasons: filteredReasons);
    } else {
      final pagedReasons =
          _getPagedReasons(state.allReasons, state.currentPage);
      state = state.copyWith(displayedReasons: pagedReasons);
    }
  }

  // Set mood score
  void setMoodScore(int score) {
    if (score >= 1 && score <= 5) {
      state = state.copyWith(moodScore: score);
    }
  }

  // Toggle a reason selection
  void toggleReason(MoodReason reason) {
    final currentSelected = List<MoodReason>.from(state.selectedReasons);

    final index = currentSelected.indexWhere((r) => r.id == reason.id);
    if (index >= 0) {
      currentSelected.removeAt(index);
    } else {
      currentSelected.add(reason);
    }

    state = state.copyWith(selectedReasons: currentSelected);
  }

  // Set notes
  void setNotes(String value) {
    state = state.copyWith(notes: value);
  }

  // Search reasons
  void searchReasons(String query) {
    state = state.copyWith(
      searchQuery: query,
      currentPage: 0, // Reset to first page when searching
    );
    _updateDisplayedReasons();
  }

  // Load more reasons (pagination)
  void loadMoreReasons() {
    if (state.searchQuery.isNotEmpty) return; // Don't paginate during search

    final nextPage = state.currentPage + 1;
    final newReasons = _getPagedReasons(state.allReasons, nextPage);

    if (newReasons.isNotEmpty) {
      state = state.copyWith(
        currentPage: nextPage,
        displayedReasons: [...state.displayedReasons, ...newReasons],
      );
    }
  }

  // Add custom reason
  Future<void> addCustomReason(String name) async {
    if (name.isEmpty) return;

    state = state.copyWith(isLoading: true);

    try {
      final newReason = await _repository.addCustomReason(name);

      if (newReason != null) {
        final updatedAllReasons = [...state.allReasons, newReason];
        final updatedSelected = [...state.selectedReasons, newReason];

        state = state.copyWith(
          allReasons: updatedAllReasons,
          selectedReasons: updatedSelected,
          isLoading: false,
        );

        _updateDisplayedReasons();
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print('Error adding custom reason: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  // Save the current mood entry with selected reasons
  Future<bool> saveMoodEntry() async {
    if (state.selectedReasons.isEmpty) return false;

    state = state.copyWith(isLoading: true);

    try {
      final reasonIds = state.selectedReasons.map((r) => r.id).toList();

      final entryId = await _repository.saveMoodEntry(
        moodScore: state.moodScore,
        reasonIds: reasonIds,
        notes: state.notes.isNotEmpty ? state.notes : null,
      );

      state = state.copyWith(isLoading: false);
      if (entryId != null) {
        resetCurrentEntry();
        return true;
      }
      return false;
    } catch (e) {
      print('Error saving mood entry: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // Save selected reasons (intermediate step)
  void saveSelectedReasons() {
    // This method doesn't need to do anything special with Riverpod
    // as we already have the selected reasons in the state
  }

  // Reset current entry (after saving or canceling)
  void resetCurrentEntry() {
    state = state.copyWith(
      moodScore: 3,
      selectedReasons: [],
      notes: '',
    );
  }
}
