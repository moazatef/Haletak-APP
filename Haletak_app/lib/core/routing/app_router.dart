import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/age_selection_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/ai_sound_analysis_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/gender_selection_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/medication_assessment_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/medication_selection_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/mental_health_symptom_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/physiacal_distress_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/prof_help_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/sleep_quality_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/stress_level_screen.dart';
import 'package:aluna/features/aluna_assement/presentation/screens/weight_selection_screen.dart';
import 'package:aluna/features/camera-feature/presentation/screens/camera_screen.dart';
import 'package:aluna/features/journal_entry/presentation/screens/journal_list_screen.dart';
import 'package:aluna/features/mood-check-in/presentation/screens/old_note_screen.dart';
import 'package:aluna/features/mood-check-in/presentation/screens/reason_screen.dart';
import 'package:aluna/features/mood_stats/presentation/screens/mood_stats_screen.dart';
import 'package:aluna/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:aluna/features/smart_watch/presentation/screens/heart_state_screen.dart';
import 'package:aluna/features/splash%20screen/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../features/aluna_assement/presentation/screens/health_goal_screen.dart';
import '../../features/auth/presentation/screens/login.dart';
import '../../features/auth/presentation/screens/register.dart';
import '../../features/chatbot/presentation/screens/chat_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/journal_entry/presentation/screens/add_journal_screen.dart';
import '../../features/mood-check-in/presentation/screens/mood_screen.dart';
import '../../features/note-list/presentation/screens/notes_screen.dart';

class AppRouter {
  Route genrateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.moodCheckInScreen:
        return MaterialPageRoute(builder: (_) => const MoodScreen());
      case Routes.moodReasonScreen:
        return MaterialPageRoute(builder: (_) => const MoodReasonScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(
                  username: '',
                ));
      case Routes.notesHistoryScreen:
        return MaterialPageRoute(builder: (_) => const NotesScreen());
      case Routes.noteList:
        return MaterialPageRoute(builder: (_) => const NotesScreen());
      case Routes.healthGoalScreen:
        return MaterialPageRoute(builder: (_) => const HealthGoalScreen());
      case Routes.genderSelectionScreen:
        return MaterialPageRoute(builder: (_) => const GenderSelectionScreen());
      case Routes.ageSelectionScreen:
        return MaterialPageRoute(builder: (_) => const AgeSelectionScreen());
      case Routes.weightSelection:
        return MaterialPageRoute(builder: (_) => const WeightSelectionScreen());
      case Routes.professionalHelpQuestion:
        return MaterialPageRoute(
            builder: (_) => const ProfessionalHelpScreen());
      case Routes.physicalExpScreen:
        return MaterialPageRoute(
            builder: (_) => const PhysicalDistressScreen());
      case Routes.sleepQualityScreen:
        return MaterialPageRoute(builder: (_) => const SleepQualityScreen());
      case Routes.medicationScreen:
        return MaterialPageRoute(
            builder: (_) => const MedicationAssessmentScreen());
      case Routes.medicationListScreen:
        return MaterialPageRoute(
            builder: (_) => const MedicationSelectionScreen());
      case Routes.mentalHealthSymptom:
        return MaterialPageRoute(builder: (_) => const MentalHealthScreen());

      case Routes.userStressLevel:
        return MaterialPageRoute(builder: (_) => const StressLevelScreen());

      case Routes.aiSoundAnalysisScreen:
        return MaterialPageRoute(builder: (_) => const AISoundAnalysisScreen());

      case Routes.addJournalScreen:
        return MaterialPageRoute(builder: (_) => const AddJournalScreen());
      case Routes.journalListScreen:
        return MaterialPageRoute(builder: (_) => const JournalListScreen());
      case Routes.cameraModel:
        return MaterialPageRoute(builder: (_) => const CameraScreen());
      case Routes.chatbotScreen:
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      case Routes.moodStatsScreen:
        return MaterialPageRoute(builder: (_) => const MoodStatsScreen());
      case Routes.heartRateScreen:
        return MaterialPageRoute(builder: (_) => const HeartRateScreen());

      case Routes.addNoteScreen:
        return MaterialPageRoute(builder: (_) => const AddNoteScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
