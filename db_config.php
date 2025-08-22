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
$host_param     = $_ENV["DB_SERVER_PARAM"];
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
    die();
}

$connection = new mysqli($host, $username, $password, $database);

if ($connection->connect_error) {
    echo "error in connection";
} else {
    $table = mysqli_real_escape_string($connection, "beverage_voting");

    $checktable = mysqli_query($connection, "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '$table' AND TABLE_SCHEMA = '$database'");

    if (mysqli_num_rows($checktable) > 0) {
        // Table exists
    } else {
        $query = "CREATE TABLE `beverage_voting` (
            `beverage_voting_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
            `name` varchar(50) NOT NULL,
            `email` varchar(50) NOT NULL,
            `beverage` varchar(50) NOT NULL,
            `created_on` datetime NOT NULL DEFAULT current_timestamp()
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci";

        if ($connection->query($query) === TRUE) {
            // Table created
        } else {
            echo json_encode(['message' => 'Error on submit data', 'status' => 'error', 'sql_error' => mysqli_error($connection)]);
            die();
        }
    }
}
?>