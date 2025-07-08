import 'package:aluna/features/mood-check-in/data/model/mood_reason.dart';

class MoodState {
  final int moodScore;
  final List<MoodReason> allReasons;
  final List<MoodReason> displayedReasons;
  final List<MoodReason> recentlyUsedReasons;
  final List<MoodReason> selectedReasons;
  final String notes;
  final bool isLoading;
  final String searchQuery;
  final int currentPage;

  MoodState({
    this.moodScore = 3,
    this.allReasons = const [],
    this.displayedReasons = const [],
    this.recentlyUsedReasons = const [],
    this.selectedReasons = const [],
    this.notes = '',
    this.isLoading = false,
    this.searchQuery = '',
    this.currentPage = 0,
  });

  MoodState copyWith({
    int? moodScore,
    List<MoodReason>? allReasons,
    List<MoodReason>? displayedReasons,
    List<MoodReason>? recentlyUsedReasons,
    List<MoodReason>? selectedReasons,
    String? notes,
    bool? isLoading,
    String? searchQuery,
    int? currentPage,
  }) {
    return MoodState(
      moodScore: moodScore ?? this.moodScore,
      allReasons: allReasons ?? this.allReasons,
      displayedReasons: displayedReasons ?? this.displayedReasons,
      recentlyUsedReasons: recentlyUsedReasons ?? this.recentlyUsedReasons,
      selectedReasons: selectedReasons ?? this.selectedReasons,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
