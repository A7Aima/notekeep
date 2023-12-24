class NotesModel {
  String id;
  String title;
  String description;
  String updateDate;

  NotesModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.updateDate = '',
  });

  factory NotesModel.fromJson(Map<String, dynamic> parseJson) {
    return NotesModel(
      id: parseJson['id'] ?? "",
      title: parseJson['title'] ?? "",
      description: parseJson['description'] ?? "",
      updateDate: parseJson['updateDate'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "updateDate": this.updateDate,
    };
  }
}
