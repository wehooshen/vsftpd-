#version1.0 此版本只适合centos7自动配置可用的vsftpd
yum install -y  vsftpd 
touch vsftpd.conf
echo  -e " anonymous_enable=NO\n local_enable=YES\n write_enable=YES\n local_umask=022\n dirmessage_enable=YES\n xferlog_enable=YES\n connect_from_port_20=NO\n port_enable=NO\n pasv_enable=YES\n pasv_min_port=10050\n pasv_max_port=10060\n pasv_promiscuous=YES\n xferlog_std_format=YES\n chroot_local_user=YES\n chroot_list_enable=YES\n chroot_list_file=/etc/vsftpd/chroot_list\n listen=YES\n listen_ipv6=NO\n pam_service_name=vsftpd\n userlist_enable=NO\n tcp_wrappers=YES\n " > vsftpd.conf
rm /etc/vsftpd/vsftpd.conf 2> /dev/null
cp  vsftpd.conf  /etc/vsftpd/vsftpd.conf
rm vsftpd.conf
systemctl restart vsftpd

#配置防火墙，开放21连接端口和10050到10060的传输端口
firewall-cmd --zone=public --add-port=21/tcp --permanent   > /dev/null
firewall-cmd --zone=public --add-port=10050-10060/tcp --permanent  > /dev/null
firewall-cmd --reload  > /dev/null

#创建ftp用户
echo "正在创建ftp用户名ftp"
useradd -d /home/ftp -s /sbin/nologin ftp
passwd ftp
echo "ftp" >> /etc/vsftpd/chroot_list
chmod 777 /home/ftp
systemctl restart vsftpd
