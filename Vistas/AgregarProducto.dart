import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('productos');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(' Agregar Producto')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductoScreen(),
        ),
      ),
    );
  }
}

class ProductoScreen extends StatefulWidget {
  @override
  _ProductoScreenState createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  late Box productoBox;
  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController almacenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productoBox = Hive.box('productos');
  }

  void _guardarProducto() {
    final producto = {
      'id': idController.text,
      'nombre': nombreController.text,
      'precio': double.parse(precioController.text),
      'stock': int.parse(stockController.text),
      'descripcion': descripcionController.text,
      'almacen': almacenController.text,
    };

    productoBox.add(producto);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto guardado')));
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
          controller: precioController,
          decoration: InputDecoration(labelText: 'Precio'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: stockController,
          decoration: InputDecoration(labelText: 'Stock'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: descripcionController,
          decoration: InputDecoration(labelText: 'Descripción'),
        ),
        TextField(
          controller: almacenController,
          decoration: InputDecoration(labelText: 'Almacén'),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _guardarProducto,
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
