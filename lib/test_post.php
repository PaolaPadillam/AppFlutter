<?php
$url = 'http://192.168.119.7/Control_vehicular/registro.php';
$data = [
    'nombre' => 'Juan',
    'ap1' => 'Perez',
    'ap2' => 'Gomez',
    'num_control' => '12345',
    'correo' => 'test@test.com',
    'password' => '123456',
    'adscripcion' => 'alumno'
];

$options = [
    'http' => [
        'header' => "Content-type: application/x-www-form-urlencoded\r\n",
        'method' => 'POST',
        'content' => http_build_query($data)
    ]
];

$context = stream_context_create($options);
$result = file_get_contents($url, false, $context);
echo $result;
?>