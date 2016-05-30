#!/usr/bin/env bash

# Install packages
yum install -y keepalived ipvsadm tcpdump

# Configure keepalived
cat << EOF > /etc/keepalived/keepalived.conf
global_defs {
  router_id lb-01
}

vrrp_instance VirtIP_10 {
  state MASTER
  interface eth1
  virtual_router_id 10
  priority 100
  authentication {
    auth_type PASS
    auth_pass MY_PASS
  }
  virtual_ipaddress {
    172.16.10.10
  }
  lvs_sync_daemon_interface eth1
}

virtual_server 172.16.10.10 80 {
  delay_loop 10
  lb_algo rr
  lb_kind DR
  protocol TCP

  real_server 172.16.10.21 80 {
    TCP_CHECK {
      connect_timeout 3
    }
  }

  real_server 172.16.10.22 80 {
    TCP_CHECK {
      connect_timeout 3
    }
  }
}

EOF

# Run keepalived
systemctl start keepalived
systemctl enable keepalived
