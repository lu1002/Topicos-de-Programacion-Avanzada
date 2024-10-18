import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('clientes');
  runApp(Contacto());
}

class Contacto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late Box contactBox;

  @override
  void initState() {
    super.initState();
    contactBox = Hive.box('clientes');
  }

  void deleteContact(int index) {
    setState(() {
      contactBox.deleteAt(index); // Eliminar el contacto de la caja
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No hay clientes.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              var cliente = box.getAt(index) as Map;

              return ListTile(
                title: Text(cliente['nombreCompleto']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${cliente['id']}'),
                    Text('Email: ${cliente['email']}'),
                    Text('Teléfono: ${cliente['telefono']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditContactScreen(
                              cliente: cliente,
                              onSave: (id, nombreCompleto, email, telefono) {
                                setState(() {
                                  // Actualizar el contacto en la caja
                                  contactBox.putAt(index, {
                                    'id': id,
                                    'nombreCompleto': nombreCompleto,
                                    'email': email,
                                    'telefono': telefono,
                                  });
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteContact(index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarContactos(
                onSave: (id, nombreCompleto, email, telefono) {
                  setState(() {
                    // Agregar un nuevo contacto en la caja
                    contactBox.add({
                      'id': id,
                      'nombreCompleto': nombreCompleto,
                      'email': email,
                      'telefono': telefono,
                    });
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AgregarContactos extends StatelessWidget {
  final Function(String, String, String, String) onSave;

  AgregarContactos({required this.onSave});

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreCompletoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: nombreCompletoController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSave(
                  idController.text,
                  nombreCompletoController.text,
                  emailController.text,
                  telefonoController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditContactScreen extends StatelessWidget {
  final Map cliente;
  final Function(String, String, String, String) onSave;

  EditContactScreen({required this.cliente, required this.onSave});

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreCompletoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    idController.text = cliente['id'];
    nombreCompletoController.text = cliente['nombreCompleto'];
    emailController.text = cliente['email'];
    telefonoController.text = cliente['telefono'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: nombreCompletoController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSave(
                  idController.text,
                  nombreCompletoController.text,
                  emailController.text,
                  telefonoController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
