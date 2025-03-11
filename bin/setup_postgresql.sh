#!/bin/bash

# Exit immediately if any command fails
set -e

echo "🔧 Setting up PostgreSQL for testing..."

# Read input from arguments or prompt the user
PG_DATABASE=${1:-}
PG_USER=${2:-}
PG_PASSWORD=${3:-}

if [[ -z "$PG_DATABASE" ]]; then
  read -p "Enter PostgreSQL database name: " PG_DATABASE
fi

if [[ -z "$PG_USER" ]]; then
  read -p "Enter PostgreSQL username: " PG_USER
fi

if [[ -z "$PG_PASSWORD" ]]; then
  read -s -p "Enter PostgreSQL password: " PG_PASSWORD
  echo ""
fi

# Check if the user exists, create if not
echo "👤 Checking if user '$PG_USER' exists..."
USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$PG_USER'")

if [[ "$USER_EXISTS" != "1" ]]; then
  echo "👤 Creating user '$PG_USER'..."
  sudo -u postgres psql -c "CREATE USER $PG_USER WITH SUPERUSER;"
  echo "🔑 Setting password for user '$PG_USER'..."
  sudo -u postgres psql -c "ALTER USER $PG_USER WITH PASSWORD '$PG_PASSWORD';"
else
  echo "✅ User '$PG_USER' already exists."
fi

# Check if the database exists, create if not
echo "📦 Checking if database '$PG_DATABASE' exists..."
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$PG_DATABASE'")

if [[ "$DB_EXISTS" != "1" ]]; then
  echo "📦 Creating database '$PG_DATABASE'..."
  sudo -u postgres psql -c "CREATE DATABASE $PG_DATABASE OWNER $PG_USER;"
else
  echo "✅ Database '$PG_DATABASE' already exists."
fi

# Grant privileges to the user on the database
echo "🔑 Granting privileges to '$PG_USER' on '$PG_DATABASE'..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PG_DATABASE TO $PG_USER;"

echo "✅ PostgreSQL setup complete!"
