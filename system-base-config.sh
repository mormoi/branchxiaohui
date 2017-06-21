#!/bin/bash 




function  system_log_rotate {
 
sed -i '/^weekly/d ; /^#weekly/d ; /^rotate/d ; /^#rotate/d ; /^daily/d ; /^#daily/d'      /etc/logrotate.conf    
echo "daily"        >>  /etc/logrotate.conf 
echo "rotate 30"    >>  /etc/logrotate.conf         
          
}

#######################################

function  system_crontab_rotate {
 
sed -i  '/.*cron.hourly$/d ; /.*cron.daily$/d ; /.*cron.weekly$/d ; /.*cron.monthly$/d'     /etc/crontab 
echo "00 * * * * root run-parts /etc/cron.hourly"      >>   /etc/crontab 
echo "00 0 * * * root run-parts /etc/cron.daily"       >>   /etc/crontab 
echo "00 0 * * 0 root run-parts /etc/cron.weekly"      >>   /etc/crontab  
echo "00 0 1 * * root run-parts /etc/cron.monthly"     >>   /etc/crontab   
             
}

#######################################

function  system_crontab_config {
 
touch  /var/spool/cron/root
sed -i  '/\/usr\/sbin\/ntpdate ntp.api.bz/d '  /var/spool/cron/root
echo "*/1  *  * * * /usr/sbin/ntpdate ntp.api.bz  > /dev/null 2>&1 "  >>   /var/spool/cron/root

/etc/init.d/crond restart  > /dev/null  2>&1           
}
 
#######################################

function  shutdown_system_general_service {
 
/sbin/chkconfig  iptables   off
/sbin/chkconfig  acpid      off
/sbin/chkconfig  postfix    off
/sbin/chkconfig  httpd      off
/sbin/chkconfig  atd        off
/sbin/chkconfig  cpuspeed   off
#/sbin/chkconfig  portmap    off
/sbin/chkconfig  nfslock    off
/sbin/chkconfig  rpcbind    off
#/sbin/chkconfig  mysqld    off
 
}
#######################################

function  yum_config_update {
 
sed -i "s/.*keepcache=.*/keepcache=1/" /etc/yum.conf #在目录 /var/cache/yum 下就会有下载的 rpm 包
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup_`date +%F"~"%T`
cp -a  ./yum/CentOS6-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
               
}
#######################################

function  dns_config_update {

sed -i 's/^nameserver/#nameserver/g '      /etc/resolv.conf
echo 'nameserver 202.106.0.20'  >> /etc/resolv.conf 
#echo 'nameserver 8.8.8.8'       >> /etc/resolv.conf    
            
}

#######################################

function  ssh_config_update {
 
/bin/cp -af ./ssh-auto-keygen.sh /etc/profile.d/
sed -i '/UseDNS/d '          /etc/ssh/sshd_config
echo "UseDNS no"     >>      /etc/ssh/sshd_config
sed -i '/GSSAPIAuthentication/d '          /etc/ssh/sshd_config
echo "GSSAPIAuthentication no"     >>      /etc/ssh/sshd_config
#sed -i "s/#PermitRootLogin yes/PermitRootLogin no/g" '/etc/ssh/sshd_config'
/etc/init.d/sshd restart  > /dev/null  2>&1               
}

#######################################

function  system_general_config {
 
#echo "alias vi='vim'" >> /root/.bashrc  #root用户别名设置
#echo "alias less='less -r'" >> /root/.bashrc

#echo 'date=`date "+%s"`' >> /etc/skel/.bash_profile  #系统默认环境变量设置
#echo 'HISTSIZE=10000' >> /etc/skel/.bash_profile
#echo 'HISTFILESIZE=10000'  >> /etc/skel/.bash_profile #bash_history 中保存命令的记录总数
#echo 'HISTFILE=$HOME/.$USER_history_$date' >> /etc/skel/.bash_profile

sed -i '/export GREP_OPTIONS=--color=auto/d '          /etc/profile #给grep 设置默认颜色
echo "export GREP_OPTIONS="--color=auto"  "  >>  /etc/profile
source /etc/profile 
               
}

#######################################

function  disable_selinux {
 
sed -i '/SELINUX=/d  '      /etc/selinux/config  
echo "SELINUX=disabled"   >>   /etc/selinux/config  
setenforce 0          
 
}

#######################################

#function  kernal_parameter_config {
 
               
#}

#######################################

#function  root_password_config {
 
#echo "$root_password" | passwd --stdin root
               
#}

#######################################

function  interactive_config_server_ip {

echo -e "\n" 

server_nic_list=`  ls -l   /etc/sysconfig/network-scripts/ifcfg-* | awk '{print $9}' | awk -F / '{print $5}' | sed 's/ifcfg-//g' | grep -v 'lo' | xargs  `

read   -p  "Please choose NIC (${server_nic_list})  :"      nic    

while !  echo   "$server_nic_list" | grep -w "$nic"  > /dev/null
do
      read   -p  "Please choose NIC (${server_nic_list})  :"      nic    
done

read   -p  "Please input the IP address of $nic (Format: standard IP format. e.g. 192.168.0.1)  :"      nic_ip    
user_input_confirm  $nic_ip 
while   [ "$user_input_confirm" !=  "ok"  ]
do
        read   -p  "Please input the IP address of $nic (Format: standard IP format. e.g. 192.168.0.1)  :"      nic_ip    
	    user_input_confirm  $nic_ip
done
check_ip_format    nic_ip  $nic_ip 

#########
      
echo -e "\n"

read   -p  "subnet mask is 255.255.255.0 ?  Input Y/y use 255.255.255.0 , Input  N/n manual config  :"      input_confirm
check_yn_input  input_confirm   $input_confirm

if  [   "$input_confirm"  ==  "y"  ]   ||  [   "$input_confirm"  ==  "Y"  ]
then
	nic_netmask="255.255.255.0"
else        
	read   -p  "Please input subnet mask of the $nic(Format: standard IP format. e.g. 255.255.255.0)    :"      nic_netmask
	user_input_confirm  $nic_netmask
	while   [ "$user_input_confirm" !=  "ok"  ]
	do
		   read   -p  "Please input subnet mask of the $nic(Format: standard IP format. e.g. 255.255.255.0)    :"  nic_netmask
		   user_input_confirm  $nic_netmask
	done
	check_netmask_format    nic_netmask   $nic_netmask        
fi 
  
need_change_nic_configfile="/etc/sysconfig/network-scripts/ifcfg-"$nic""

sed -i '/BOOTPROTO/d;  /ONBOOT/d  ;  /IPADDR/d  ;  /NETMASK/d '               $need_change_nic_configfile
echo  "BOOTPROTO="static""                >>  $need_change_nic_configfile
echo  "ONBOOT="yes""                      >>  $need_change_nic_configfile
echo  "IPADDR="$nic_ip""                  >>  $need_change_nic_configfile
echo  "NETMASK="$nic_netmask""            >>  $need_change_nic_configfile

#read   -p  "config complete ,need restart network ?  Input Y/y to restart , Input  N/n to remain unchange  :"      input_confirm
#check_yn_input  input_confirm   $input_confirm

#if  [   "$input_confirm"  ==  "y"  ]   ||  [   "$input_confirm"  ==  "Y"  ]
#then
#    /etc/init.d/network  restart
#fi

echo -e "\n"

}

#######################################

function  interactive_config_server_default_gateway {
 
echo -e "\n"

read   -p  "Please input default_gateway address(Format: standard IP format. e.g. 192.168.0.1)    :"      default_gateway
user_input_confirm  $default_gateway
while   [ "$user_input_confirm" !=  "ok"  ]
do
	  read   -p  "Please input default_gateway address(Format: standard IP format. e.g. 192.168.0.1)    :"      default_gateway
	  user_input_confirm  $default_gateway
done
check_ip_format    default_gateway  $default_gateway 

sed -i '/GATEWAY/d  '        /etc/sysconfig/network
echo  "GATEWAY="$default_gateway""   >>  /etc/sysconfig/network

echo -e "\n"
	
}

#######################################

function  interactive_config_server_hostname {
 
echo -e "\n"

read   -p  "Please input local_server_name    :"      local_server_name
user_input_confirm  $local_server_name
while   [ "$user_input_confirm" !=  "ok"  ]
do
	  read   -p  "Please input local_server_name    :"      local_server_name
	  user_input_confirm  $local_server_name
done 

sed -i '/HOSTNAME/d  '        /etc/sysconfig/network
echo  "HOSTNAME="$local_server_name""   >>  /etc/sysconfig/network

hostname $local_server_name

echo -e "\n"
	
}



initialization_oma_environment


system_log_rotate


system_crontab_rotate



system_crontab_config



shutdown_system_general_service


yum_config_update


dns_config_update



ssh_config_update



system_general_config

disable_selinux

disable_selinux


read   -p  "interactive_config_server_network(ip,gateway)_and_hostname ?  Input Y/y to change , Input  N/n to remain unchange  :"      input_confirm
check_yn_input  input_confirm   $input_confirm

if  [  "$input_confirm"  ==  "y"  ]  ||  [  "$input_confirm"  ==  "Y"  ]
then
	interactive_config_server_ip
	interactive_config_server_default_gateway
	interactive_config_server_hostname
fi






