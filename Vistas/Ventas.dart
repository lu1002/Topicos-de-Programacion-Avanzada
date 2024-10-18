import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('ventas');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: VentaScreen(),
        ),
      ),
    );
  }
}

class VentaScreen extends StatefulWidget {
  @override
  _VentaScreenState createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  late Box ventasBox;
  final TextEditingController codigoController = TextEditingController();
  final List<Map<String, dynamic>> ventas = [];
  final Map<String, Map<String, dynamic>> productos = {
    '001': {'descripcion': 'Producto A', 'precio': 10.0},
    '002': {'descripcion': 'Producto B', 'precio': 15.0},
  };

  @override
  void initState() {
    super.initState();
    ventasBox = Hive.box('ventas');
    _loadVentas();
  }

  void _loadVentas() {
    final storedVentas = ventasBox.values.toList();
    setState(() {
      ventas.addAll(storedVentas.cast<Map<String, dynamic>>());
    });
  }

  void _addVenta(String codigo, int cantidad) {
    if (productos.containsKey(codigo)) {
      final producto = productos[codigo]!;
      final total = producto['precio'] * cantidad;
      final venta = {
        'codigo': codigo,
        'descripcion': producto['descripcion'],
        'precio': producto['precio'],
        'cantidad': cantidad,
        'total': total,
      };

      setState(() {
        ventas.add(venta);
        ventasBox.add(venta);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto no encontrado')),
      );
    }
  }

  void _deleteVenta(int index) {
    setState(() {
      ventas.removeAt(index);
      ventasBox.deleteAt(index);
    });
  }

  void _procesarPago() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pago procesado')),
    );
    setState(() {
      ventas.clear();
      ventasBox.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50), 
        Text('No. Venta: 1'),
        SizedBox(height: 10),
        Center(
          child: TextField(
            controller: codigoController,
            decoration: InputDecoration(
              labelText: 'Código',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _addVenta(value, 1);
              codigoController.clear();
            },
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 10.0, 
              columns: [
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('Cantidad')),
                DataColumn(label: Text('Total')),
              ],
              rows: ventas.map((venta) {
                return DataRow(cells: [
                  DataCell(Text(venta['codigo'])),
                  DataCell(Text(venta['descripcion'])),
                  DataCell(Text('\$${venta['precio']}')),
                  DataCell(Text('${venta['cantidad']}')),
                  DataCell(Text('\$${venta['total']}')),
                ]);
              }).toList(),
            ),
          ),
        ),
        SizedBox(height:10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: \$${ventas.fold<double>(0, (sum, item) => sum + item['total'] as double)}'),
            ElevatedButton(
              onPressed: _procesarPago,
              child: Text('COBRAR'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
