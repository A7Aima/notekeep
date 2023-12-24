import 'package:notekeep/model/notes_model/notes_model.dart';
import 'package:notekeep/service/notes_service/notes_service.dart';
import 'package:notekeep/service/user_service/user_service.dart';

class HomeStore {
  NotesService _notesService = NotesService();
  UserLocalService userService = UserLocalService();

  String? errorMessage;

  bool isLoading = false;

  List<NotesModel> notesList = [];

  Future<void> getAllNotes() async {
    try {
      final result = await _notesService.getAllNotes();
      final notes = (result as List<dynamic>?) ?? [];
      notesList.clear();
      notes.forEach((element) {
        notesList.add(NotesModel.fromJson(element));
      });
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> deleteNotes(String id) async {
    try {
      await _notesService.deleteNotes(id: id);
      errorMessage = null;
    } catch (e) {
      errorMessage =
          "Delete notes can only applicable if online for maintaining synchronousity\n${e.toString()}";
    }
  }
}
