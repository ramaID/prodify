SELECT 'CREATE DATABASE matomo'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'matomo')\gexec
