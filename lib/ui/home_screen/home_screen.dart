import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notekeep/const/routes/routes.dart';
import 'package:notekeep/model/notes_model/notes_model.dart';
import 'package:notekeep/service/user_service/user_service.dart';
import 'package:notekeep/store/home_store/home_bloc/home_bloc.dart';
import 'package:notekeep/store/home_store/home_event/home_event.dart';
import 'package:notekeep/store/home_store/home_state/home_state.dart';
import 'package:notekeep/store/home_store/home_store.dart';
import 'package:notekeep/utility/mixin/base_mixin/base_mixin.dart';

class HomeScreen extends BasePageWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  late HomeStore _store;
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _store = HomeStore();
    _homeBloc = HomeBloc();
    Future.delayed(Duration(seconds: 2), () {
      _homeBloc.add(FetchNotes());
    });
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _homeBloc,
      builder: (context, state) {
        // if (state is NotesLoading) {
        //   return _buildLoading();
        // } else
        if (state is NotesLoaded) {
          return _buildBody(state.notesList);
        } else if (state is NotesError) {
          return _buildError(state.errorMessage);
        }
        return _buildLoading(); // Handle other states or return default widget
      },
    );
  }

  Widget _buildBody(List<NotesModel> notesList) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              UserLocalService().deleteUserLocal().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.intro_screen,
                  (route) => false,
                );
              });
            },
            icon: Icon(Icons.logout_sharp),
          ),
          IconButton(
            onPressed: () {
              _homeBloc.add(FetchNotes());
            },
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.notes_screen,
          ).then((value) {
            _homeBloc.add(FetchNotes());
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: _buildNotesList(notesList),
    );
  }

  Widget _buildNotesList(List<NotesModel> notesList) {
    return ListView.builder(
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        final note = notesList[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.notes_screen,
              arguments: {
                "notes": note,
              },
            ).then((value) {
              _homeBloc.add(FetchNotes());
            });
          },
          child: Dismissible(
            key: ValueKey(note.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                _homeBloc.add(DeleteNote(note.id));
              }
            },
            confirmDismiss: (direction) async {
              bool isDismissed = false;
              if (direction == DismissDirection.endToStart) {
                await showDialog(
                  context: context,
                  builder: (ctxt) {
                    return AlertDialog(
                      title: Text(
                          "Are you sure you want to delete ${note.title}?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _homeBloc.add(DeleteNote(note.id));
                            Navigator.pop(ctxt);
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctxt);
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                );
              }
              return isDismissed;
            },
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.025,
              ),
              padding: EdgeInsets.only(
                left: screenWidth * 0.035,
                right: screenWidth * 0.035,
                top: screenHeight * 0.015,
                bottom: screenHeight * 0.015,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "${note.title}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "${note.description}",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(), // Or your custom loading widget
    );
  }

  Widget _buildError(String errorMessage) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
        actions: [
          IconButton(
            onPressed: () {
              UserLocalService().deleteUserLocal().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.intro_screen,
                  (route) => false,
                );
              });
            },
            icon: Icon(Icons.logout_sharp),
          ),
          IconButton(
            onPressed: () {
              _homeBloc.add(FetchNotes());
            },
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Center(
        child: Text(errorMessage), // Display error message
      ),
    );
  }

  void toastMessage(String? message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? "")),
      );
    }
  }

  String dateFormat(String date) {
    return DateFormat.yMEd()
        .add_jm()
        .format(DateTime.tryParse(date) ?? DateTime.now());
  }

  void getNotes() {
    _store.getAllNotes().then((value) {
      _store.isLoading = false;
      if (_store.errorMessage != null) {
        toastMessage(_store.errorMessage);
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
