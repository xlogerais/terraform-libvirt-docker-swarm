timezone: Europe/Paris

package_update: true
package_upgrade: true

apt:
    sources:
        docker:
            keyid: "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
            source: "deb https://download.docker.com/linux/ubuntu xenial edge"

packages:
  - qemu-guest-agent
  - apt-transport-https
  - docker-ce

#write_files:
#  - path: /etc/docker/daemon.json
#    owner: root:root
#    content: |
#      {
#        "hosts": ["fd://", "tcp://0.0.0.0:2375"]
#      }
#

users:
  - default
  - name: "${sshuser}"
    groups: docker
    shell: /bin/bash
    ssh_authorized_keys: "${sshpubkey}"
    sudo: 'ALL=(ALL) NOPASSWD:ALL'

final_message: 'Boot finished at $TIMESTAMP, after $UPTIME seconds'
