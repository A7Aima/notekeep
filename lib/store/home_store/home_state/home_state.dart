import 'package:notekeep/model/notes_model/notes_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class NotesLoading extends HomeState {}

class NotesLoaded extends HomeState {
  final List<NotesModel> notesList;

  NotesLoaded(this.notesList);
}

class NotesError extends HomeState {
  final String errorMessage;

  NotesError(this.errorMessage);
}

class NoteDeleted extends HomeState {}
