<?php
<?php

require 'vendor/aws-autoloader.php';

use Aws\Ssm\SsmClient;
use Aws\Exception\AwsException;

$client = new SsmClient([
    'region' => $_ENV["AWS_REGION"],
    'version' => 'latest',
]);

// Parameter names
$username_param = $_ENV["DB_USERNAME_PARAM"];
$password_param = $_ENV["DB_PASSWORD_PARAM"];
$host_param     = $_ENV["DB_HOST_PARAM"];
$database_param = $_ENV["DB_DATABASE_PARAM"];

try {
    $username = $client->getParameter([
        'Name' => $username_param,
        'WithDecryption' => true,
    ])['Parameter']['Value'];

    $password = $client->getParameter([
        'Name' => $password_param,
        'WithDecryption' => true,
    ])['Parameter']['Value'];

    $host = $client->getParameter([
        'Name' => $host_param,
        'WithDecryption' => true,
    ])['Parameter']['Value'];

    $database = $client->getParameter([
        'Name' => $database_param,
        'WithDecryption' => true,
    ])['Parameter']['Value'];
} catch (AwsException $e) {
    echo json_encode(['message' => 'Error fetching parameters', 'status' => 'error', 'aws_error' => $e->getMessage()]);
    exit();
}

$connection = new mysqli($host, $username, $password, $database);

if ($connection->connect_error) {
    echo json_encode(['message' => 'Database connection failed', 'status' => 'error', 'error' => $connection->connect_error]);
    exit();
}

$table_name = "beverage_voting";

$stmt = $connection->prepare("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = ? AND TABLE_SCHEMA = ?");
$stmt->bind_param("ss", $table_name, $database);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    $create_query = "CREATE TABLE `beverage_voting` (
        `beverage_voting_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `name` varchar(50) NOT NULL,
        `email` varchar(50) NOT NULL,
        `beverage` varchar(50) NOT NULL,
        `created_on` datetime NOT NULL DEFAULT current_timestamp()
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci";

    if (!$connection->query($create_query)) {
        echo json_encode(['message' => 'Error creating table', 'status' => 'error', 'sql_error' => $connection->error]);
        exit();
    }
}

$stmt->close();
?>