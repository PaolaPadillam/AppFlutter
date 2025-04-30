import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'vehiculo_model.dart';
import 'tipo_vehiculo_model.dart'; // Importa el nuevo modelo
import 'registro_exitoso_screen.dart';
import 'vehiculo_service.dart'; // Para cargar tipos desde API/BD

class RegistroVehiculoScreen extends StatefulWidget {
  final int tipoVehiculoId; // ID inicial (opcional)

  const RegistroVehiculoScreen({
    this.tipoVehiculoId = 1,
  }); // Valor por defecto: Automóvil

  @override
  _RegistroVehiculoScreenState createState() => _RegistroVehiculoScreenState();
}

class _RegistroVehiculoScreenState extends State<RegistroVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _marcaController = TextEditingController();
  String _color = 'Rojo';
  Uint8List? _foto;
  TipoVehiculo? _tipoSeleccionado;
  List<TipoVehiculo> _tiposVehiculo = []; // Lista dinámica desde BD

  @override
  void initState() {
    super.initState();
    _cargarTiposVehiculo(); // Carga los tipos al iniciar
  }

  Future<void> _cargarTiposVehiculo() async {
    try {
      final tipos = await VehiculoService.fetchTiposVehiculo();
      setState(() {
        _tiposVehiculo = tipos;
        _tipoSeleccionado = tipos.firstWhere(
          (tipo) => tipo.idTipoVehiculo == widget.tipoVehiculoId,
          orElse: () => tipos.first,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar tipos de vehículo')),
      );
    }
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _foto = bytes);
    }
  }

  void _registrarVehiculo() {
    if (_formKey.currentState!.validate() && _tipoSeleccionado != null) {
      final vehiculo = Vehiculo(
        idVehiculo: 0,
        placa: _placaController.text,
        marca: _marcaController.text,
        color: _color,
        idTipoVehiculo: _tipoSeleccionado!.idTipoVehiculo,
        tipo: _tipoSeleccionado!, // Nuevo campo en Vehiculo
        foto: _foto,
      );
      // Guardar en BD (implementa VehiculoService.registrarVehiculo)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistroExitosoScreen(vehiculo: vehiculo),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Vehículo')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Selector de tipo de vehículo
              if (_tiposVehiculo.isNotEmpty)
                DropdownButtonFormField<TipoVehiculo>(
                  value: _tipoSeleccionado,
                  items:
                      _tiposVehiculo.map((tipo) {
                        return DropdownMenuItem(
                          value: tipo,
                          child: Row(
                            children: [
                              Text(tipo.icono ?? '🚗'), // Emoji por defecto
                              SizedBox(width: 10),
                              Text(tipo.nombre),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged:
                      (value) => setState(() => _tipoSeleccionado = value),
                  decoration: InputDecoration(labelText: 'Tipo de vehículo'),
                  validator:
                      (value) => value == null ? 'Seleccione un tipo' : null,
                ),
              SizedBox(height: 20),

              // Campo de placa (oculto para bicicletas)
              if (_tipoSeleccionado?.idTipoVehiculo != 3) // ID 3 = Bicicleta
                TextFormField(
                  controller: _placaController,
                  decoration: InputDecoration(labelText: 'Placa'),
                  validator:
                      (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                ),

              // Resto de campos
              TextFormField(
                controller: _marcaController,
                decoration: InputDecoration(labelText: 'Marca/Modelo'),
              ),
              DropdownButtonFormField(
                value: _color,
                items:
                    ['Rojo', 'Azul', 'Negro', 'Blanco'].map((color) {
                      return DropdownMenuItem(value: color, child: Text(color));
                    }).toList(),
                onChanged: (value) => setState(() => _color = value.toString()),
              ),
              SizedBox(height: 20),
              _foto != null
                  ? Image.memory(_foto!, height: 100)
                  : ElevatedButton(
                    onPressed: _tomarFoto,
                    child: Text('Tomar Foto'),
                  ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registrarVehiculo,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
