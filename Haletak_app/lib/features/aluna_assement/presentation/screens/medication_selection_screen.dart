// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/model/medication_list_model.dart';
import 'package:aluna/features/aluna_assement/presentation/widgets/medication_list_item.dart';
import 'package:aluna/features/aluna_assement/data/service/medication_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import MedicationService

class MedicationSelectionScreen extends StatefulWidget {
  const MedicationSelectionScreen({super.key});

  @override
  _MedicationSelectionScreenState createState() =>
      _MedicationSelectionScreenState();
}

class _MedicationSelectionScreenState extends State<MedicationSelectionScreen> {
  final List<MedicationListModel> _allMedications = [
    // Antidepressants
    MedicationListModel(name: 'Prozac', type: 'P'),
    MedicationListModel(name: 'Zoloft', type: 'Z'),
    MedicationListModel(name: 'Lexapro', type: 'L'),
    MedicationListModel(name: 'Paxil', type: 'P'),
    MedicationListModel(name: 'Cymbalta', type: 'C'),
    MedicationListModel(name: 'Wellbutrin', type: 'W'),
    MedicationListModel(name: 'Effexor', type: 'E'),
    MedicationListModel(name: 'Celexa', type: 'C'),
    MedicationListModel(name: 'Remeron', type: 'R'),
    MedicationListModel(name: 'Brintellix', type: 'B'),
    MedicationListModel(name: 'Viibryd', type: 'V'),
    MedicationListModel(name: 'Anafranil', type: 'A'),
    MedicationListModel(name: 'Tofranil', type: 'T'),

    // Anti-Anxiety
    MedicationListModel(name: 'Xanax', type: 'X'),
    MedicationListModel(name: 'Ativan', type: 'A'),
    MedicationListModel(name: 'Klonopin', type: 'K'),
    MedicationListModel(name: 'Valium', type: 'V'),
    MedicationListModel(name: 'Buspirone', type: 'B'),
    MedicationListModel(name: 'Vistaril', type: 'V'),
    MedicationListModel(name: 'Librium', type: 'L'),
    MedicationListModel(name: 'Tranxene', type: 'T'),

    // Mood Stabilizers
    MedicationListModel(name: 'Lithium', type: 'L'),
    MedicationListModel(name: 'Lamictal', type: 'L'),
    MedicationListModel(name: 'Depakote', type: 'D'),
    MedicationListModel(name: 'Tegretol', type: 'T'),
    MedicationListModel(name: 'Trileptal', type: 'T'),

    // Antipsychotics
    MedicationListModel(name: 'Abilify', type: 'A'),
    MedicationListModel(name: 'Seroquel', type: 'S'),
    MedicationListModel(name: 'Risperdal', type: 'R'),
    MedicationListModel(name: 'Geodon', type: 'G'),
    MedicationListModel(name: 'Latuda', type: 'L'),
    MedicationListModel(name: 'Zyprexa', type: 'Z'),
    MedicationListModel(name: 'Haldol', type: 'H'),
    MedicationListModel(name: 'Clozaril', type: 'C'),

    // Sleep Aids
    MedicationListModel(name: 'Trazodone', type: 'T'),
    MedicationListModel(name: 'Ambien', type: 'A'),
    MedicationListModel(name: 'Lunesta', type: 'L'),
    MedicationListModel(name: 'Restoril', type: 'R'),
    MedicationListModel(name: 'Sonata', type: 'S'),

    // Other Mental Health Medications
    MedicationListModel(name: 'Prazosin', type: 'P'),
    MedicationListModel(name: 'Naltrexone', type: 'N'),
    MedicationListModel(name: 'Propranolol', type: 'P'),
  ];

  List<MedicationListModel> _filteredMedications = [];
  final List<MedicationListModel> _selectedMedications = [];
  final MedicationService _medicationService =
      MedicationService(); // Firebase Service

  String _selectedLetter = 'A';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filterMedications();
  }

  void _filterMedications() {
    setState(() {
      _filteredMedications = _allMedications.where((med) {
        bool matchesLetter = med.type == _selectedLetter;
        bool matchesSearch =
            med.name.toLowerCase().contains(_searchQuery.toLowerCase());
        return _searchQuery.isNotEmpty ? matchesSearch : matchesLetter;
      }).toList();
    });
  }

  void _toggleMedication(MedicationListModel medication) {
    setState(() {
      if (_selectedMedications.contains(medication)) {
        _selectedMedications.remove(medication);
      } else {
        _selectedMedications.add(medication);
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterMedications();
    });
  }

  void _selectLetter(String letter) {
    setState(() {
      _selectedLetter = letter;
      _searchQuery = '';
      _filterMedications();
    });
  }

  Future<void> _saveMedications() async {
    if (_selectedMedications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one medication')),
      );
      return;
    }

    try {
      // Get the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      await _medicationService.saveMedications(_selectedMedications);

      Navigator.pushNamed(context, Routes.mentalHealthSymptom);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving medications: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildSearchBar(),
          _buildAlphabetFilter(),
          _buildMedicationList(),
          _buildSelectedMedications(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Assessment',
        style: TextStyle(
            color: ColorStyles.fontMainColor,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorStyles.fontMainColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorStyles.mainColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("10 of 13",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.backgroundColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        'Please specify your medications!',
        style: TextStyle(
            color: ColorStyles.fontMainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _selectedMedications.isNotEmpty ? _saveMedications : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedMedications.isNotEmpty
              ? ColorStyles.mainColor
              : Colors.grey,
          minimumSize: const Size(double.infinity, 54),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Continue',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(width: 8.w),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildAlphabetFilter() {
    List<String> letters = ['A', 'B', 'C', 'L', 'P', 'W', 'X', 'Y', 'Z'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: letters.map((letter) {
          bool isSelected = letter == _selectedLetter;
          return GestureDetector(
            onTap: () => _selectLetter(letter),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? ColorStyles.mainColor : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                letter,
                style: TextStyle(
                  color: isSelected ? Colors.white : ColorStyles.fontMainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search medication...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildMedicationList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _filteredMedications.length,
        itemBuilder: (context, index) {
          final medication = _filteredMedications[index];
          return MedicationListItem(
            medication: medication,
            isSelected: _selectedMedications.contains(medication),
            onTap: () => _toggleMedication(medication),
          );
        },
      ),
    );
  }

  Widget _buildSelectedMedications() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: _selectedMedications.map((med) {
          return Chip(
            label: Text(med.name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: Colors.orangeAccent,
            deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white),
            onDeleted: () => _toggleMedication(med),
          );
        }).toList(),
      ),
    );
  }
}
