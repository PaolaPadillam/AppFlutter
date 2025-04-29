<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Manejar preflight request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// Obtener datos del POST
$data = json_decode(file_get_contents('php://input'), true) ?? $_POST;

// Validación básica
if (empty($data['nombre']) || empty($data['matricula_o_id']) || empty($data['password'])) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Todos los campos son requeridos"
    ]);
    exit;
}

require 'db.php';

$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Error de conexión a la base de datos"
    ]);
    exit;
}

// Verificar si el usuario ya existe
$matricula = $conn->real_escape_string(trim($data['matricula_o_id']));
$check_query = "SELECT id_usuario FROM usuarios WHERE matricula_o_id = '$matricula'";
$result = $conn->query($check_query);

if ($result->num_rows > 0) {
    http_response_code(409);
    echo json_encode([
        "success" => false,
        "message" => "La matrícula/número de control ya está registrado"
    ]);
    $conn->close();
    exit;
}

// Insertar nuevo usuario
$nombre = $conn->real_escape_string(trim($data['nombre']));
$password = password_hash($data['password'], PASSWORD_BCRYPT);
$id_tipo_usuario = 2;

$insert_query = "INSERT INTO usuarios (nombre, matricula_o_id, password, id_tipo_usuario) 
                VALUES ('$nombre', '$matricula', '$password', $id_tipo_usuario)";

if ($conn->query($insert_query)) {
    http_response_code(201);
    echo json_encode([
        "success" => true,
        "message" => "Usuario registrado exitosamente",
        "usuario_id" => $conn->insert_id
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Error al registrar usuario: " . $conn->error
    ]);
}

$conn->close();
?>