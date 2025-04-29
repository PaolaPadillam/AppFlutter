<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);

require 'db.php';

// Verificar si las variables están definidas
if (!isset($db_host, $db_user, $db_pass, $db_name)) {
    die(json_encode([
        "success" => false,
        "message" => "Configuración de base de datos incompleta en db.php"
    ]));
}

try {
    $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
    
    if ($conn->connect_error) {
        throw new Exception("Error de conexión: " . $conn->connect_error);
    }

    // Verificar si la tabla usuarios existe
    $result = $conn->query("SHOW TABLES LIKE 'usuarios'");
    if ($result->num_rows == 0) {
        throw new Exception("La tabla 'usuarios' no existe");
    }

    // Verificar estructura de la tabla
    $columns_required = ['nombre', 'ap1', 'ap2', 'num_control', 'correo', 'password', 'adscripcion'];
    $result = $conn->query("DESCRIBE usuarios");
    $columns_exist = [];
    while ($row = $result->fetch_assoc()) {
        $columns_exist[] = $row['Field'];
    }

    $missing = array_diff($columns_required, $columns_exist);
    if (!empty($missing)) {
        throw new Exception("Faltan columnas: " . implode(', ', $missing));
    }

    echo json_encode([
        "success" => true,
        "message" => "Conexión exitosa y estructura correcta",
        "database" => $db_name,
        "user" => $db_user
    ]);

    $conn->close();
} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage(),
        "config" => [
            "host" => $db_host,
            "user" => $db_user,
            "dbname" => $db_name
        ]
    ]);
}
?>