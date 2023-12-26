import 'package:equatable/equatable.dart';
import 'package:notekeep/model/notes_model/notes_model.dart';

abstract class NotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  final NotesModel notesModel;

  NotesLoaded(this.notesModel);

  @override
  List<Object?> get props => [notesModel];
}

class NotesError extends NotesState {
  final String errorMessage;

  NotesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
