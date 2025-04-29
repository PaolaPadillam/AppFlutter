<?php
header("Access-Control-Allow-Origin: *"); // Permite acceso desde cualquier origen
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

// Mostrar errores para depurar
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Incluir la conexión a la base de datos
require 'db.php';

// Crear conexión
$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

// Verificar conexión
if ($conn->connect_error) {
    echo json_encode([
        "success" => false,
        "message" => "Error de conexión a la base de datos: " . $conn->connect_error
    ]);
    exit;
}

// Leer los datos enviados en el cuerpo de la solicitud
$data = json_decode(file_get_contents("php://input"));

if (!isset($data->matricula_o_id) || !isset($data->password)) {
    echo json_encode([
        "success" => false,
        "message" => "Faltan campos necesarios."
    ]);
    exit;
}

$matricula = $conn->real_escape_string($data->matricula_o_id);
$password = $data->password;

// Buscar al usuario por matrícula o ID
$sql = "SELECT * FROM usuarios WHERE matricula_o_id = '$matricula'";
$result = $conn->query($sql);

if ($result->num_rows == 0) {
    echo json_encode([
        "success" => false,
        "message" => "No se encontró ningún usuario con esa matrícula."
    ]);
    exit;
}

// El usuario existe, verificamos la contraseña
$user = $result->fetch_assoc();
if (password_verify($password, $user['password'])) {
    // La contraseña es correcta
    echo json_encode([
        "success" => true,
        "message" => "Inicio de sesión exitoso",
        "usuario_id" => $user['id_usuario']
    ]);
} else {
    // Contraseña incorrecta
    echo json_encode([
        "success" => false,
        "message" => "Contraseña incorrecta."
    ]);
}

$conn->close();
?>
