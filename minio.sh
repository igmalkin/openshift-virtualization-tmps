#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
	    echo "Please run this script as root."
	        exit 1
fi

# MinIO configuration parameters
MINIO_USER="minio-user"
MINIO_GROUP="minio-user"
MINIO_ROOT_USER="minioadmin"
MINIO_ROOT_PASSWORD="lGQownmaHtOW674240HBuy"
MINIO_DATA_DIR="/data"
MINIO_PORT=9000
MINIO_CONSOLE_PORT=36645

echo "Starting MinIO installation..."

# Step 1: Download and install the MinIO server binary
echo "Downloading MinIO server..."
wget https://dl.min.io/server/minio/release/linux-amd64/minio -O /usr/local/bin/minio
chmod +x /usr/local/bin/minio

# Step 2: Download and install the MinIO client (optional)
echo "Downloading MinIO client..."
wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc
chmod +x /usr/local/bin/mc

# Step 3: Create a user and group for MinIO
echo "Creating MinIO user and group..."
useradd -r $MINIO_USER || echo "User $MINIO_USER already exists."

# Step 4: Create a directory for MinIO data
echo "Creating data directory for MinIO..."
mkdir -p $MINIO_DATA_DIR
chown -R $MINIO_USER:$MINIO_GROUP $MINIO_DATA_DIR

# Step 5: Configure MinIO environment variables
echo "Configuring MinIO environment variables..."
cat <<EOF > /etc/default/minio
MINIO_ROOT_USER=$MINIO_ROOT_USER
MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD
MINIO_VOLUMES="$MINIO_DATA_DIR"
MINIO_SERVER_OPTS="--console-address :$MINIO_CONSOLE_PORT"
EOF

# Step 6: Create a systemd service for MinIO
echo "Creating systemd service for MinIO..."
cat <<EOF > /etc/systemd/system/minio.service
[Unit]
Description=MinIO
Documentation=https://min.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
User=$MINIO_USER
Group=$MINIO_GROUP
EnvironmentFile=/etc/default/minio
ExecStart=/usr/local/bin/minio server \$MINIO_SERVER_OPTS \$MINIO_VOLUMES
Restart=always
RestartSec=10s
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Step 7: Reload systemd and start the MinIO service
echo "Reloading systemd and starting MinIO..."
systemctl daemon-reload
systemctl enable minio
systemctl start minio

# Step 8: Configure the firewall to allow MinIO ports
echo "Configuring the firewall for MinIO..."
firewall-cmd --permanent --add-port=$MINIO_PORT/tcp
firewall-cmd --permanent --add-port=$MINIO_CONSOLE_PORT/tcp
firewall-cmd --reload

# Step 9: Check the MinIO service status
echo "Checking MinIO service status..."
systemctl status minio --no-pager

# Final message
echo "MinIO installation is complete."
echo "MinIO server is available at: http://<your-server>:$MINIO_PORT"
echo "Web console is available at: http://<your-server>:$MINIO_CONSOLE_PORT"
echo "Username: $MINIO_ROOT_USER"
echo "Password: $MINIO_ROOT_PASSWORD"
