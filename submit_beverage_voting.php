<?php

include('db_config.php');

$name = htmlentities($_REQUEST['name']);
$email = htmlentities($_REQUEST['email']);
$beverage = htmlentities($_REQUEST['beverage']);

if ($name === '' || $email === '' || $beverage === '') {
    echo json_encode(array('message' => 'Please fill all fields', 'status' => 'error'));
    exit();
}

if (!isset($connection) || $connection->connect_error) {
    echo json_encode(array('message' => 'Database connection failed', 'status' => 'error'));
    exit();
}

$stmt = $connection->prepare("INSERT INTO beverage_voting (name, email, beverage) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $email, $beverage);

if ($stmt->execute()) {
    echo json_encode(array('message' => 'Thank you for voting!', 'status' => 'success'));
} else {
    echo json_encode(array('message' => 'Error on submit data', 'status' => 'error', 'sql_error' => $stmt->error));
}

$stmt->close();
$connection->close();