import 'package:notekeep/const/config/config.dart';
import 'package:hive/hive.dart';

class NotesDBStore {
  late Box _notes;
  NotesDBStore() {
    _openCollection();
  }

  void _openCollection() async {
    if (Hive.isBoxOpen(Config.noteBoxName)) {
      _notes = Hive.box(Config.noteBoxName);
    } else {
      _notes = await Hive.openBox(Config.noteBoxName);
    }
  }

  Future<void> saveNotes({
    required String id,
    required Map<String, dynamic> savedValue,
  }) async {
    if (savedValue.isNotEmpty) {
      await _notes.put(id, savedValue);
    }
  }

  dynamic getNotesList() {
    return _notes.values.toList();
  }

  Future<void> deleteAllNotes() async {
    await _notes.clear();
  }

  Future<void> deleteNotesWithId({required String id}) async {
    await _notes.delete(id);
  }

  void closeCollection() async {
    Hive.close();
  }
}
