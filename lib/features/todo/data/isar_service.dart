import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/todo_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // Membuka koneksi database
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TodoSchema], // Menggunakan schema yang di-generate
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  // Fungsi Simpan atau Update
  Future<void> saveTodo(Todo newTodo) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todos.putSync(newTodo));
  }

  // Fungsi Ambil Semua Data
  Future<List<Todo>> getAllTodos() async {
    final isar = await db;
    return await isar.todos.where().findAll();
  }

  // Fungsi Hapus Data
  Future<void> deleteTodo(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.todos.delete(id));
  }
}