abstract class HomeEvent {}

class FetchNotes extends HomeEvent {}

class DeleteNote extends HomeEvent {
  final String id;

  DeleteNote(this.id);
}
