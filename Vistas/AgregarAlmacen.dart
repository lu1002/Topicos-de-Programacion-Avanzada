import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('almacenes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ventana Agregar Almacén')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlmacenScreen(),
        ),
      ),
    );
  }
}

class AlmacenScreen extends StatefulWidget {
  @override
  _AlmacenScreenState createState() => _AlmacenScreenState();
}

class _AlmacenScreenState extends State<AlmacenScreen> {
  late Box almacenBox;
  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    almacenBox = Hive.box('almacenes');
  }

  void _guardarAlmacen() {
    final almacen = {
      'id': idController.text,
      'nombre': nombreController.text,
      'tipo': tipoController.text,
    };

    almacenBox.add(almacen);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Almacén guardado')));
  }

  void _salir() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20), // Espacio adicional en la parte superior
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'ID'),
        ),
        TextField(
          controller: nombreController,
          decoration: InputDecoration(labelText: 'Nombre'),
        ),
        TextField(
          controller: tipoController,
          decoration: InputDecoration(labelText: 'Tipo'),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _guardarAlmacen,
              child: Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: _salir,
              child: Text('Salir'),
            ),
          ],
        ),
      ],
    );
  }
}
