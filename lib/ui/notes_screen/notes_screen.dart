import 'package:flutter/material.dart';
import 'package:notekeep/model/notes_model/notes_model.dart';
import 'package:notekeep/store/notes_store/notes_store.dart';
import 'package:notekeep/utility/mixin/base_mixin/base_mixin.dart';
import 'package:uuid/uuid.dart';

class NotesScreen extends BasePageWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  BaseState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends BaseState<NotesScreen> {
  NotesStore _store = NotesStore();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initializeWithContext(BuildContext context) {
    super.initializeWithContext(context);
    if (routesArguments.isNotEmpty) {
      _store.notesModel = routesArguments['notes'];
      _store.noteId = _store.notesModel?.id ?? null;
    }
    if (_store.noteId == null) {
      _store.noteId = Uuid().v1();
    } else {
      _store.title = _store.notesModel?.title ?? "";
      _store.description = _store.notesModel?.description ?? "";
      _titleController.text = _store.notesModel?.title ?? "";
      _notesController.text = _store.notesModel?.description ?? "";
      setState(() {});
    }
    _initializeController();
  }

  void _initializeController() {
    _titleController.addListener(() {
      _store.title = _titleController.text;
    });
    _notesController.addListener(() {
      _store.description = _notesController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notes Screen"),
          actions: [
            TextButton.icon(
              onPressed: _saveNotes,
              icon: Icon(Icons.save),
              label: _store.notesModel == null ? Text("Add") : Text("Update"),
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  void _saveNotes() {
    if (!_store.validateNotes()) {
      _store
          .saveNotes(
              savedModel: NotesModel(
        id: _store.noteId ?? "",
        description: _store.description ?? "",
        title: _store.title ?? "",
        updateDate: DateTime.now().toIso8601String(),
      ))
          .then((value) {
        Navigator.pop(context);
      });
    } else {
      toastMessage(_store.errorMessage);
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField(
              label: "Title",
              controller: _titleController,
            ),
            _buildTextField(
              label: "Notes",
              maxLines: 25,
              controller: _notesController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    String label = "",
    String hint = "",
    TextEditingController? controller,
    int? maxLines = 1,
  }) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.only(
        bottom: screenHeight * 0.025,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          label: Text("$label"),
          hintText: "$hint",
          alignLabelWithHint: false,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void toastMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "")),
    );
  }
}
