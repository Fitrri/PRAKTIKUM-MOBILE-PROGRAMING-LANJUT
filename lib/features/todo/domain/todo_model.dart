import 'package:isar/isar.dart';

// Bagian ini wajib ada untuk proses generate kode otomatis
part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // ID otomatis (1, 2, 3...)

  late String title;
  
  late bool isDone;

  late String prioritas; // Tinggi, Sedang, Rendah
}