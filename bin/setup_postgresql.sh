#!/bin/bash

# Exit immediately if any command fails
set -e

echo "🔧 Setting up PostgreSQL for testing..."

# Read input from ENV variables or use default one
POSTGRES_DB=${POSTGRES_DB:-"rails_test"}
POSTGRES_USER=${POSTGRES_USER:-"rails"}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-"password"}

# Check if the user exists, create if not
echo "👤 Checking if user '$POSTGRES_USER' exists..."
USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$POSTGRES_USER'")

if [[ "$USER_EXISTS" != "1" ]]; then
  echo "👤 Creating user '$POSTGRES_USER'..."
  sudo -u postgres psql -c "CREATE USER $POSTGRES_USER WITH SUPERUSER;"
  echo "🔑 Setting password for user '$POSTGRES_USER'..."
  sudo -u postgres psql -c "ALTER USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"
else
  echo "✅ User '$POSTGRES_USER' already exists."
fi

# Check if the database exists, create if not
echo "📦 Checking if database '$POSTGRES_DB' exists..."
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DB'")

if [[ "$DB_EXISTS" != "1" ]]; then
  echo "📦 Creating database '$POSTGRES_DB'..."
  sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;"
else
  echo "✅ Database '$POSTGRES_DB' already exists."
fi

# Grant privileges to the user on the database
echo "🔑 Granting privileges to '$POSTGRES_USER' on '$POSTGRES_DB'..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;"

echo "✅ PostgreSQL setup complete!"
