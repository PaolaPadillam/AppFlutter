<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Manejar preflight request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

error_reporting(E_ALL);
ini_set('display_errors', 1);

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

// Obtener datos del POST (soporta tanto JSON como form-data)
$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    // Si no es JSON válido, probar con form-data
    $data = $_POST;
}

if (empty($data['matricula_o_id']) || empty($data['password'])) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Matrícula y contraseña son requeridas"
    ]);
    exit;
}

$matricula = $conn->real_escape_string(trim($data['matricula_o_id']));
$password = $data['password'];

// Buscar usuario con LIMIT 1 para mejor performance
$sql = "SELECT id_usuario, nombre, password FROM usuarios WHERE matricula_o_id = '$matricula' LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows == 0) {
    http_response_code(404);
    echo json_encode([
        "success" => false,
        "message" => "Usuario no encontrado"
    ]);
    exit;
}

$user = $result->fetch_assoc();

if (password_verify($password, $user['password'])) {
    // Login exitoso
    http_response_code(200);
    echo json_encode([
        "success" => true,
        "message" => "Inicio de sesión exitoso",
        "usuario" => [
            "id" => $user['id_usuario'],
            "nombre" => $user['nombre'],
            "matricula" => $matricula
        ]
    ]);
} else {
    http_response_code(401);
    echo json_encode([
        "success" => false,
        "message" => "Contraseña incorrecta"
    ]);
}

$conn->close();
?>