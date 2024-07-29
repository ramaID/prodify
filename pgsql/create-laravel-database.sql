SELECT 'CREATE DATABASE laravel'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'laravel')\gexec
