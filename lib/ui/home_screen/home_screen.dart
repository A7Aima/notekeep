import 'package:notekeep/const/routes/routes.dart';
import 'package:notekeep/store/home_store/home_store.dart';
import 'package:notekeep/utility/loading_widget/loading_widget.dart';
import 'package:notekeep/utility/mixin/base_mixin/base_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends BasePageWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  HomeStore _store = HomeStore();

  @override
  void initializeWithContext(BuildContext context) {
    super.initializeWithContext(context);
    _store.isLoading = true;
    Future.delayed(Duration(seconds: 2), () {
      getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              _store.userService.deleteUserLocal().then((value) {
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
              setState(() {
                _store.isLoading = true;
              });
              Future.delayed(Duration(seconds: 2), () {
                getNotes();
              });
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
            getNotes();
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: Align(
        alignment: _store.isLoading ? Alignment.center : Alignment.topCenter,
        child: LoadingWidget(
          loading: _store.isLoading,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._store.notesList.map((note) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.notes_screen,
                    arguments: {
                      "notes": note,
                    },
                  ).then((value) {
                    getNotes();
                  });
                },
                child: Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      _store.deleteNotes(note.id).then((value) {
                        _store.isLoading = false;
                        if (_store.errorMessage != null) {
                          toastMessage(_store.errorMessage);
                        } else {
                          getNotes();
                        }
                      });
                    }
                  },
                  confirmDismiss: (direction) async {
                    bool isDissmised = false;
                    if (direction == DismissDirection.endToStart) {
                      await showDialog(
                        context: context,
                        builder: (ctxt) {
                          return AlertDialog(
                            title: Text(
                                "Are u sure u want to delete ${note.title}"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  isDissmised = true;
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
                    return isDissmised;
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
            }).toList()
          ],
        ),
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
