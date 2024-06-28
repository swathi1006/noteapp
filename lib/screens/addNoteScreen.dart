import 'package:flutter/material.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/utils/appcolors.dart';
import 'package:noteapp/utils/snackbar.dart';

import '../database/db.dart';
import '../utils/textConstants.dart';

class AddNoteScreen extends StatefulWidget {

  final Note? note;

  AddNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _addItemController = TextEditingController();

  List<String> checkListItems = [];
  List<bool> _isChecked = [];
  bool isCheckListEnabled = false;
  var formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title ?? '';
      _contentController.text = widget.note!.content ?? '';
      if (widget.note!.checklist != null) {
        checkListItems.addAll(widget.note!.checklist!);
        _isChecked = List<bool>.filled(widget.note!.checklist!.length, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.basicTheme,
        title: Text(
          widget.note == null ? 'Add Your Notes' : 'Edit Your Note',
          style: AppTextTheme.appBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title",
                  style: AppTextTheme.bodyTextStyle,
                ),
                TextFormField(
                  validator: (title) {
                    if (title!.isEmpty) {
                      return "Please Enter a Title.";
                    } else {
                      return null;
                    }
                  },
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Title",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Content",
                  style: AppTextTheme.bodyTextStyle,
                ),
                TextFormField(
                  controller: _contentController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Content",
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckListEnabled,
                      onChanged: (value) {
                        setState(() {
                          isCheckListEnabled = value!;
                        });
                      },
                    ),
                    Text(
                      "Create CheckList",
                      style: AppTextTheme.bodyTextStyle,
                    ),
                  ],
                ),
                if (isCheckListEnabled == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _addItemController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Add Item",
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            backgroundColor: AppColor.basicTheme,
                            child: IconButton(
                              onPressed: () {
                                _addCheckListItem(_addItemController.text);
                                _addItemController.clear();
                              },
                              icon: Icon(
                                Icons.add,
                                color: AppColor.headTextTheme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: checkListItems.length,
                  itemBuilder: (context, index) {
                    final item = checkListItems[index];
                    return ListTile(
                      title: Text(
                        item,
                        style: AppTextTheme.bodyTextStyle,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _editCheckListItem(index);
                            },
                            icon: Icon(
                              size: 25,
                              Icons.edit,
                              color: AppColor.basicTheme,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteCheckListItem(index);
                            },
                            icon: Icon(
                              size: 25,
                              Icons.delete,
                              color: AppColor.basicTheme,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: AppColor.basicTheme,
          onPressed: () {
            var valid = formkey.currentState!.validate();
            if (valid == true) {
              String title = _titleController.text;
              String content = _contentController.text;
              final checklist =
              checkListItems.isNotEmpty ? checkListItems : null;
              final checked = _isChecked.isNotEmpty ? _isChecked : null;

              final note = Note(
                title: title,
                content: content,
                checklist: checklist,
                isCheckedList: checked,
              );

              if (widget.note == null) {
                final id = HiveDb.addNote(note);
                if (id != null) {
                  successSnackBar(context);
                  Navigator.pop(context, true); // Pass true to indicate success
                } else {
                  errorSnackBar(context);
                }
              } else {
                // Update the existing note
                HiveDb.updateNote(widget.note!, () {
                  // Refresh UI after updating the note
                });
                updateSuccessSnackBar(context);
                Navigator.pop(context, note); // Pass updated note back
              }
            } else {
              warningSnackBar(context);
            }
          },
          label: Text(
            widget.note == null ? 'Add Note' : 'Update Note',
            style: AppTextTheme.appBarTextStyle,
          ),
          icon: Icon(
            Icons.note_add_outlined,
            size: 20,
            color: AppColor.headTextTheme,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _addCheckListItem(String checkListItem) {
    setState(() {
      if (checkListItem.trim().isNotEmpty) {
        checkListItems.add(checkListItem.trim());
        _addItemController.clear();
        _isChecked.add(false);
        _addItemController.clear();
      }
    });
  }

  void _deleteCheckListItem(int index) {
    setState(() {
      checkListItems.removeAt(index);
      setState(() {});
      _isChecked.removeAt(index);
    });
  }

  void _editCheckListItem(int index) {
    String initialText = checkListItems[index];
    showDialog(
      context: context,
      builder: (context) {
        String newText = initialText;
        print("initialtext:  $initialText");
        return AlertDialog(
          title: Text('Edit Checklist Item'),
          content: TextField(
            controller: TextEditingController(text: initialText),
            onChanged: (value) {
              newText = value;
              print("newText: $newText");
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  checkListItems[index] = newText;
                  print("checkedListItems[index] = ${checkListItems[index]}");
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}