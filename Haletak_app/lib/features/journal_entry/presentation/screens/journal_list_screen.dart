import 'package:aluna/features/auth/data/service/auth_service.dart';
import 'package:aluna/features/journal_entry/presentation/screens/add_journal_screen.dart';
import 'package:aluna/features/journal_entry/presentation/widgets/date_selector.dart';
import 'package:aluna/features/journal_entry/presentation/widgets/journal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../data/model/journal_entry.dart';
import '../../data/services/journal_service.dart';
import '../widgets/edit_journal_screen.dart';
import '../widgets/journal_header.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  _JournalListScreenState createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  late JournalService _journalService;
  List<Journal> _journals = [];
  bool _isLoading = true;
  String _sortOrder = 'Newest';
  DateTime _selectedDate = DateTime.now();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final token = await AuthService().getToken();
    _userId = await AuthService().getUserId();

    if (token == null || _userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login again')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    _journalService = JournalService(token: token);
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    setState(() => _isLoading = true);

    try {
      final journals = await _journalService.getJournals();

      setState(() {
        _journals = journals;
        _sortJournals();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load journals: ${e.toString()}')),
        );

        if (e.toString().contains('Authentication failed')) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
  }

  void _sortJournals() {
    if (_sortOrder == 'Newest') {
      _journals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      _journals.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _sortOrder = _sortOrder == 'Newest' ? 'Oldest' : 'Newest';
      _sortJournals();
    });
  }

  Future<void> _deleteJournal(Journal journal) async {
    try {
      await _journalService.deleteJournal(_userId!, journal.id!);
      setState(() {
        _journals.removeWhere((item) => item.id == journal.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete journal: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _navigateToAddJournal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddJournalScreen(),
      ),
    );

    if (result == true) {
      _loadJournals();
    }
  }

  Future<void> _navigateToEditJournal(Journal journal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditJournalScreen(journal: journal, userId: _userId!),
      ),
    );

    if (result == true) {
      _loadJournals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        body: Column(
          children: [
            JournalHeader(
              title: 'My Notes',
              onBack: () => Navigator.pop(context),
            ),
            DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Timeline',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorStyles.fontMainColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _toggleSortOrder,
                    icon: Icon(
                      _sortOrder == 'Newest'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      size: 16,
                      color: ColorStyles.mainColor,
                    ),
                    label: Text(
                      _sortOrder,
                      style: TextStyle(
                        color: ColorStyles.mainColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _journals.isEmpty
                      ? Center(
                          child: Text(
                            'No journals found',
                            style: TextStyle(
                              color: ColorStyles.fontMainColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: _journals.length,
                          itemBuilder: (context, index) {
                            final journal = _journals[index];
                            return JournalItem(
                              journal: journal,
                              onDelete: () => _deleteJournal(journal),
                              onEdit: () => _navigateToEditJournal(journal),
                            );
                          },
                        ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorStyles.mainColor,
          onPressed: _navigateToAddJournal,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
