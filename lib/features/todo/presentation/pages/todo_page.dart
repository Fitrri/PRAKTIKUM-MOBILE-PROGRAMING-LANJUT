import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../data/isar_service.dart';
import '../../domain/todo_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // Mengambil IsarService dari locator (Dependency Injection)
  final IsarService isarService = locator<IsarService>();
  
  List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  String _selectedPriority = 'Sedang'; // Default prioritas

  @override
  void initState() {
    super.initState();
    _refreshData(); // Ambil data saat halaman dibuka
  }

  // Fungsi untuk mengambil data terbaru dari database Isar
  Future<void> _refreshData() async {
    final data = await isarService.getAllTodos();
    setState(() {
      _todos = data;
    });
  }

  // Fungsi untuk menampilkan Dialog Tambah Todo
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // Agar dropdown di dalam dialog bisa update
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Tambah Tugas Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Nama tugas...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: "Prioritas"),
                items: ['Tinggi', 'Sedang', 'Rendah'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) {
                  setDialogState(() {
                    _selectedPriority = val!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _controller.clear();
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  final newTodo = Todo()
                    ..title = _controller.text
                    ..isDone = false
                    ..prioritas = _selectedPriority;
                  
                  await isarService.saveTodo(newTodo);
                  _controller.clear();
                  if (mounted) Navigator.pop(context);
                  _refreshData();
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan Todo (Isar)"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text("Belum ada catatan. Klik + untuk menambah."))
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final item = _todos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.isDone,
                      onChanged: (val) async {
                        // Update status selesai/belum di database
                        item.isDone = val!;
                        await isarService.saveTodo(item);
                        _refreshData();
                      },
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: item.isDone 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text("Prioritas: ${item.prioritas}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await isarService.deleteTodo(item.id);
                        _refreshData();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // Footer identitas sesuai permintaan modul
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.grey[200],
        child: const Text(
          "Fitri Anisa - 20123020",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
    );
  }
}