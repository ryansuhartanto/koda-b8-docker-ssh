FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y sudo openssh-server --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -mG sudo ryan && \
    echo 'ryan:1234' | chpasswd && \
    sudo -u ryan mkdir /home/ryan/.ssh

COPY --chown=ryan:ryan --chmod=644 id_ed25519.pub /home/ryan/.ssh/authorized_keys

RUN sed -i 's/^#\?Port .*/Port 8088/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 8088

CMD ["/usr/sbin/sshd", "-D", "-e"]
