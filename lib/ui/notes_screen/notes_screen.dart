import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeep/store/notes_store/notes_bloc/notes_bloc.dart';
import 'package:notekeep/store/notes_store/notes_event/notes_event.dart';
import 'package:notekeep/store/notes_store/notes_state/notes_state.dart';
import 'package:notekeep/store/notes_store/notes_store.dart';
import 'package:notekeep/utility/mixin/base_mixin/base_mixin.dart';
import 'package:uuid/uuid.dart';

class NotesScreen extends BasePageWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  BaseState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends BaseState<NotesScreen> {
  late NotesBloc _notesBloc;
  NotesStore _store = NotesStore();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesBloc = NotesBloc(_store);
    _notesBloc.add(LoadNotes());
  }

  @override
  void dispose() {
    _notesBloc.close();
    super.dispose();
  }

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
    return BlocProvider(
      create: (context) => _notesBloc,
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            _titleController.text = state.notesModel.title;
            _notesController.text = state.notesModel.description;
            return _buildScreen();
          } else if (state is NotesError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Notes Screen'),
              ),
              body: Center(
                child: Text('Error: ${state.errorMessage}'),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Notes Screen'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScreen() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notes Screen'),
          actions: [
            TextButton.icon(
              onPressed: () => _saveNotes(context),
              icon: Icon(Icons.save),
              label: _store.notesModel == null ? Text('Add') : Text('Update'),
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
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
              label: 'Title',
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
    required String label,
    String hint = '',
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
          labelText: label,
          hintText: hint,
          alignLabelWithHint: false,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _saveNotes(BuildContext context) {
    _notesBloc.add(SaveNotes());
  }
}
