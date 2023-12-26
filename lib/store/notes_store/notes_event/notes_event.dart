import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class UpdateTitle extends NotesEvent {
  final String title;

  UpdateTitle(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateDescription extends NotesEvent {
  final String description;

  UpdateDescription(this.description);

  @override
  List<Object?> get props => [description];
}

class SaveNotes extends NotesEvent {}
