#! /bin/bash

# node_exporter package download
wget -P /root https://github.com/prometheus/node_exporter/releases/download/v1.3.0/node_exporter-1.3.0.linux-amd64.tar.gz
tar xvfz /root/node_exporter-1.3.0.linux-amd64.tar.gz

if [[ ! -f /usr/bin/node_exporter ]]; then
  mv /root/node_exporter-1.3.0.linux-amd64/node_exporter /usr/bin/
fi

rm -f /root/node_exporter-1.3.0.linux-amd64.tar.gz
rm -rf /root/node_exporter-1.3.0.linux-amd64/

# node_exporter service start
cat << EOF | tee /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# node_exporter.service 실행
/bin/systemctl daemon-reload
/bin/systemctl restart node_exporter.service
/bin/systemctl enable node_exporter.service

# check the node_exporter is installed
ps -ef | grep node_exporter
