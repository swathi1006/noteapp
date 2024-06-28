import 'package:flutter/material.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/screens/addNoteScreen.dart';
import 'package:noteapp/utils/appcolors.dart';
import 'package:noteapp/utils/textConstants.dart';

class NoteDetails extends StatefulWidget {
  final Note note;
  final Function(int) onDelete;

  const NoteDetails({Key? key, required this.note, required this.onDelete}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}
class _NoteDetailsState extends State<NoteDetails> {
  late List<bool> isChecked;

  @override
  void initState() {
    isChecked = widget.note.isCheckedList ??
        List<bool>.filled(widget.note.isCheckedList?.length
            ?? 0, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.basicTheme,
        title: Text(
          widget.note.title!,
          style: AppTextTheme.appBarTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white,),
            onPressed: () {
              _navigateToEditScreen();
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.75),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
            image: const AssetImage("assets/images/back.png"),
          ),
        ),
        child: ListView(
          children: [
            Text(
              widget.note.content!,
              style: AppTextTheme.bodyTextStyle,
            ),
            const SizedBox(height: 15),
            if (widget.note.checklist != null &&
                widget.note.checklist!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CheckList : ",
                    style: AppTextTheme.bodyTextStyle,
                  ),
                  Divider(
                    color: AppColor.basicTheme,
                    thickness: 3,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.note.checklist!.length,
                    itemBuilder: (context, index) {
                      final item = widget.note.checklist![index];
                      return CheckboxListTile(
                        checkColor: AppColor.basicTheme,
                        activeColor: Colors.white,
                        title: Text(
                          item,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.basicTheme,
                            decoration: isChecked[index]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        value: isChecked[index],
                        onChanged: (value) {
                          setState(() {
                            isChecked[index] = value!;
                          });
                        },);},),],
              ),],),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.basicTheme,
        onPressed: () {
          _deleteNote();
        },
        child: const Icon(Icons.delete, color: Colors.white,),
      ),
    );
  }

  void _deleteNote() {
    widget.onDelete(widget.note.id!);
    Navigator.pop(context); // Navigate back to the home page after deletion
  }


  void _navigateToEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddNoteScreen(note: widget.note),
      ),
    ).then((updatedNote) {
      if (updatedNote != null) {
        setState(() {
          widget.note.title = updatedNote.title;
          widget.note.content = updatedNote.content;
          widget.note.checklist = updatedNote.checkList;
          widget.note.isCheckedList =
              updatedNote.isCheckedList ?? [];
          isChecked = List<bool>.filled(
            widget.note.checklist!.length,
            false,
          );
        });
      }
    });
  }

}