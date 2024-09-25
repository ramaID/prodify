SELECT 'CREATE DATABASE sonar'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sonar')\gexec
