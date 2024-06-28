import'package:hive/hive.dart';
part 'note.g.dart';
@HiveType(typeId: 0)
class Note{
  
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? content;
  @HiveField(3)
  List<String>? checklist;
  @HiveField(4)
  List<bool>? isCheckedList;
  @HiveField(5)
  int? id;

  Note({required this.title, this.content,this.checklist,this.isCheckedList,}){
    id = DateTime.now().microsecondsSinceEpoch;
  }

}

