import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:notekeep/model/notes_model/notes_model.dart';
import 'package:notekeep/store/home_store/home_event/home_event.dart';
import 'package:notekeep/store/home_store/home_state/home_state.dart';
import 'package:notekeep/store/home_store/home_store.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeStore _homeStore = HomeStore();

  HomeBloc() : super(HomeInitial()) {
    on<FetchNotes>((event, emit) async {
      emit(NotesLoading());
      try {
        await _homeStore.getAllNotes();
        if (_homeStore.errorMessage != null) {
          emit(NotesError(_homeStore.errorMessage!));
        } else {
          emit(NotesLoaded(_homeStore.notesList));
        }
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    });
    on<DeleteNote>((event, emit) async {
      emit(NotesLoading());
      try {
        await _homeStore.deleteNotes(event.id);
        if (_homeStore.errorMessage != null) {
          emit(NotesError(_homeStore.errorMessage!));
        } else {
          emit(NotesLoaded(_homeStore.notesList));
        }
      } catch (e) {
        emit(NotesError(
            "Delete notes can only be applicable if online for maintaining synchronicity\n${e.toString()}"));
      }
    });
  }

  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchNotes) {
      yield* _mapFetchNotesToState();
    } else if (event is DeleteNote) {
      yield* _mapDeleteNoteToState(event.id);
    }
  }

  Stream<HomeState> _mapFetchNotesToState() async* {
    yield NotesLoading();
    try {
      final result = await _homeStore.getAllNotes();
      final notes = (result as List<dynamic>?) ?? [];
      List<NotesModel> notesList = [];
      notes.forEach((element) {
        notesList.add(NotesModel.fromJson(element));
      });
      yield NotesLoaded(notesList);
    } catch (e) {
      yield NotesError("Failed to fetch notes: ${e.toString()}");
    }
  }

  Stream<HomeState> _mapDeleteNoteToState(String id) async* {
    try {
      await _homeStore.deleteNotes(id);
      yield NoteDeleted();
    } catch (e) {
      yield NotesError(
          "Delete notes can only be applicable if online for maintaining synchronicity\n${e.toString()}");
    }
  }
}
