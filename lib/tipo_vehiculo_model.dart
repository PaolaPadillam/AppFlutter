class TipoVehiculo {
  final int idTipoVehiculo;
  final String nombre;
  final String? icono; // Opcional para mostrar íconos en la UI

  const TipoVehiculo({
    required this.idTipoVehiculo,
    required this.nombre,
    this.icono,
  });

  // Método para convertir a Map (útil para SQLite/API)
  Map<String, dynamic> toMap() {
    return {
      'id_tipo_vehiculo': idTipoVehiculo,
      'nombre': nombre,
      'icono': icono,
    };
  }

  // Factory para crear desde Map (ej: al leer de la BD)
  factory TipoVehiculo.fromMap(Map<String, dynamic> map) {
    return TipoVehiculo(
      idTipoVehiculo: map['id_tipo_vehiculo'],
      nombre: map['nombre'],
      icono: map['icono'],
    );
  }
}
