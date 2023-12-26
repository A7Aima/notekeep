import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeep/model/notes_model/notes_model.dart';
import 'package:notekeep/store/notes_store/notes_event/notes_event.dart';
import 'package:notekeep/store/notes_store/notes_state/notes_state.dart';
import 'package:notekeep/store/notes_store/notes_store.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesStore _notesStore;

  NotesBloc(this._notesStore) : super(NotesInitial());

  Stream<NotesState> mapEventToState(NotesEvent event) async* {
    if (event is LoadNotes) {
      yield* _mapLoadNotesToState();
    } else if (event is UpdateTitle) {
      _notesStore.title = event.title;
    } else if (event is UpdateDescription) {
      _notesStore.description = event.description;
    } else if (event is SaveNotes) {
      yield* _mapSaveNotesToState();
    }
  }

  Stream<NotesState> _mapLoadNotesToState() async* {
    try {
      // Perform loading logic if needed
      yield NotesLoaded(_notesStore.notesModel ?? NotesModel());
    } catch (e) {
      yield NotesError('Failed to load notes: $e');
    }
  }

  Stream<NotesState> _mapSaveNotesToState() async* {
    try {
      if (!_notesStore.validateNotes()) {
        await _notesStore.saveNotes(
          savedModel: NotesModel(
            id: _notesStore.noteId ?? '',
            description: _notesStore.description ?? '',
            title: _notesStore.title ?? '',
            updateDate: DateTime.now().toIso8601String(),
          ),
        );
        yield NotesLoaded(_notesStore.notesModel ?? NotesModel());
      } else {
        yield NotesError(_notesStore.errorMessage ?? 'Validation Error');
      }
    } catch (e) {
      yield NotesError('Failed to save notes: $e');
    }
  }
}
