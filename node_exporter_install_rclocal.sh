#! /bin/bash

# node_exporter package download
wget -P /root https://github.com/prometheus/node_exporter/releases/download/v1.3.0/node_exporter-1.3.0.linux-amd64.tar.gz
tar xvfz /root/node_exporter-1.3.0.linux-amd64.tar.gz

if [[ ! -f /usr/bin/node_exporter ]]; then
  mv /root/node_exporter-1.3.0.linux-amd64/node_exporter /usr/bin/
fi

chmod 755 /usr/bin/node_exporter

cd /root/
echo -e "\n[Install]\nWantedBy=multi-user.target" >> /usr/lib/systemd/system/rc-local.service
echo -e "/usr/bin/node_exporter &" >> /etc/rc.local
chmod u+x /etc/rc.d/rc.local

# rc-local.service 실행
/bin/systemctl daemon-reload
/bin/systemctl restart rc-local.service
/bin/systemctl enable rc-local.service

echo -e "\nrc-local.service가 rebooting에도 실행되는 지 확인"
/bin/systemctl list-unit-files | grep rc.local

echo -e "\n\nnode_exporter 실행한 경과 확인"
ps -ef |grep node
