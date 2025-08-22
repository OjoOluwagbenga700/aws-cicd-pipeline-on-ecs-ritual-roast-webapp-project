[
  {
    "name": "${container_name}",
    "image": "${image}",
    "portMappings": [
      {
        "name": "${container_name}", 
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp",
        "appProtocol": "http"
      }
    ],
    "essential": true,
    "environment": [
      {
        "name": "DB_HOST",
        "value": "${db_host}"
      },
      {
        "name": "DB_NAME",
        "value": "${db_name}"
      },
      {
        "name": "DB_USERNAME",
        "value": "${db_username}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${db_password}"
      }
    ],
    "linuxParameters": {
      "initProcessEnabled": true
    },
    
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group_name}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ritual-roast"
      }
    }
  }
]
