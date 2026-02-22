import 'package:flutter/material.dart';

import '../enums/order_option.dart';
import '../models/note.dart';
import '../core/extensions.dart';
import '../services/firestore_service.dart';

class NotesProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Note> _notes = [];
  
  NotesProvider() {
    print('🆕 NotesProvider created for new user');
    _listenToNotes();
  }

  void _listenToNotes() {
    _firestoreService.getNotes().listen((notes) {
      _notes = notes;
      notifyListeners();
    }, onError: (error) {
      print('Error listening to notes: $error');
    });
  }

  List<Note> get notes {
    if (_searchTerm.isEmpty) return _applySorting(_notes);
    return _applySorting(_notes.where(_test).toList());
  }

  List<Note> _applySorting(List<Note> notes) {
    notes.sort(_compare);
    return notes;
  }

  bool _test(Note note) {
    final term = _searchTerm.toLowerCase().trim();
    final title = note.title?.toLowerCase() ?? '';
    final content = note.content?.toLowerCase() ?? '';
    final tags = note.tags?.map((e) => e.toLowerCase()).toList() ?? [];
    return title.contains(term) ||
        content.contains(term) ||
        tags.deepContains(term);
  }

  int _compare(Note note1, Note note2) {
    return _orderBy == OrderOption.dateModified
        ? _isDescending
            ? note2.dateModified.compareTo(note1.dateModified)
            : note1.dateModified.compareTo(note2.dateModified)
        : _isDescending
            ? note2.dateCreated.compareTo(note1.dateCreated)
            : note1.dateCreated.compareTo(note2.dateCreated);
  }

  Future<void> addNote(Note note) async {
    await _firestoreService.addNote(note);
  }

  Future<void> updateNote(Note note) async {
    await _firestoreService.updateNote(note);
  }

  Future<void> deleteNote(Note note) async {
    if (note.id != null) {
      await _firestoreService.deleteNote(note.id!);
    }
  }

  OrderOption _orderBy = OrderOption.dateModified;
  set orderBy(OrderOption value) {
    _orderBy = value;
    notifyListeners();
  }

  OrderOption get orderBy => _orderBy;

  bool _isDescending = true;
  set isDescending(bool value) {
    _isDescending = value;
    notifyListeners();
  }

  bool get isDescending => _isDescending;

  bool _isGrid = true;
  set isGrid(bool value) {
    _isGrid = value;
    notifyListeners();
  }

  bool get isGrid => _isGrid;

  String _searchTerm = '';
  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;

  @override
  void dispose() {
    print('🗑️ NotesProvider disposed');
    super.dispose();
  }
}