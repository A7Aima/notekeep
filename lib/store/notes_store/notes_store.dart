import 'package:notekeep/model/notes_model/notes_model.dart';
import 'package:notekeep/service/notes_service/notes_service.dart';

class NotesStore {
  NotesService _notesService = NotesService();

  String? errorMessage;

  bool isLoading = false;

  List<NotesModel> bookingList = [];

  NotesModel? notesModel;

  String? noteId;

  String? title;

  String? description;

  bool validateNotes() {
    if (title == null || (title ?? "").isEmpty) {
      errorMessage = "Note Title Is Empty";
      return true;
    }

    if (description == null || (description ?? "").isEmpty) {
      errorMessage = "Note Description Is Empty";
      return true;
    }
    errorMessage = null;
    return false;
  }

  Future<void> saveNotes({required NotesModel savedModel}) async {
    try {
      await _notesService.saveNotes(
        id: noteId ?? "",
        savedValue: savedModel.toMap(),
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
