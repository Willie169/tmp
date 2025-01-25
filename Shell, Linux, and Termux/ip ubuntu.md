# /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: networkd
  wifis:
    wlp2s0:
      dhcp4: no
      addresses:
        - 192.168.67.200/24
      gateway4: 192.168.67.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4