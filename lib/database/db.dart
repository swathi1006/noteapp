// HiveDb class
import 'package:hive/hive.dart';
import '../model/note.dart';
class HiveDb {
  static Future<int?> addNote(Note note) async {
    int id = await Hive.box<Note>('my_notes').add(note);
    return id;
  }

  static void updateNote(Note newNote, Function refreshHome) {
    var box = Hive.box<Note>('my_notes');
    int index = box.values.toList().indexWhere((note) =>
    note.id == newNote.id);
    if (index != -1) {
      box.putAt(index, newNote);
      refreshHome();
    }
  }
  static void deleteNote(int noteId, Function refreshHome) {
    try {
      var box = Hive.box<Note>('my_notes');
      box.delete(noteId);
      refreshHome(); // Call refresh function to update the UI
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

}