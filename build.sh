#!/bin/bash

set -e

apt update
apt install -y curl mediainfo sqlite3 libchromaprint-tools

arch=$(dpkg --print-architecture)
case $arch in
	amd64) arch="x64" ;;
	arm|armf|armhf) arch="arm" ;;
	arm64) arch="arm64" ;;
	*) echo "Unsupported architecture: $arch" && exit 1 ;;
esac

wget --content-disposition "http://lidarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=$arch" -O ./Lidarr.tar.gz
tar -xvzf ./Lidarr.tar.gz -C ./

mkdir -p ./build/
mv ./Lidarr ./build/Lidarr/
mkdir -p ~/.lidarr-data

cat <<'EOF' > ./build/run.sh
#!/bin/bash

DATA_DIR=$(readlink -f "$HOME/.lidarr-data")
exec "./Lidarr/Lidarr" -nobrowser -data="$DATA_DIR"
EOF

chmod +x ./build/run.sh
rm ./Lidarr.tar.gz

echo "Build complete. Run './build/run.sh' to start Lidarr."
