import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notekeep/const/config/config.dart';
import 'package:notekeep/const/db_store/note_db_store/note_db_store.dart';
import 'package:notekeep/const/local_data/local_data.dart';
import 'package:notekeep/model/notes_model/notes_model.dart';

class NotesService {
  final db = FirebaseFirestore.instance;
  late NotesDBStore _dbStore;
  NotesService() {
    _dbStore = NotesDBStore();
  }

  Future<dynamic> getAllNotes() async {
    await _saveAllNotes();
    return _dbStore.getNotesList();
  }

  Future<void> _saveAllNotes() async {
    final List<Map<String, dynamic>> allList = [];
    await accessNotes().get().then((snapshot) async {
      await Future.forEach(snapshot.docs, (element) async {
        final model = NotesModel.fromJson(element.data());
        allList.add(model.toMap());
      });
    });
    print("object:  ${_dbStore.getNotesList().runtimeType.toString()}");
    final offlineList = (_dbStore.getNotesList() as List)
        .map((e) => NotesModel.fromJson(e).toMap())
        .toList();

    print("object Ahead:  ${offlineList.runtimeType.toString()}");
    allList.addAll(offlineList);
    await Future.forEach(allList, (element) async {
      await saveNotes(
        id: element['id'],
        savedValue: element,
      );
    });
  }

  Future<void> saveNotes({
    required String id,
    required Map<String, dynamic> savedValue,
  }) async {
    // will do both add and update
    try {
      final access = accessNotes().doc(id);
      await access.set(savedValue);
      await _dbStore.saveNotes(id: id, savedValue: savedValue);
    } catch (_) {
      await _dbStore.saveNotes(id: id, savedValue: savedValue);
    }
  }

  Future<void> deleteNotes({
    required String id,
  }) async {
    try {
      final access = accessNotes().doc(id);
      await access.delete();
      await _dbStore.deleteNotesWithId(id: id);
    } catch (_) {}
  }

  CollectionReference<Map<String, dynamic>> accessNotes() {
    return db
        .collection(Config.userCollection)
        .doc(LocalData().userModel?.userId ?? "")
        .collection(Config.notesCollection);
  }
}
