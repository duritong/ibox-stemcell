Veewee::Session.declare({
  # Minimum RAM requirement for installation is 512MB.
  :cpu_count => '1', :memory_size=> '1024',
  :disk_size => '10140', :disk_format => 'VDI', :hostiocache => 'off', :hwvirtext => 'on',
  :os_type_id => 'RedHat6_64',
  :iso_file => "CentOS-6.5-x86_64-netinstall.iso",
  :iso_src => "http://mirror.switch.ch/ftp/mirror/centos/6.5/isos/x86_64/CentOS-6.5-x86_64-netinstall.iso",
  :iso_sha256 => "d8aaf698408c0c01843446da4a20b1ac03d27f87aad3b3b7b7f42c6163be83b9",
  :iso_download_timeout => 1000,
  :boot_wait => "10", :boot_cmd_sequence => [ '<Tab> linux text biosdevname=0 ks=http://%IP%:%PORT%/ks.cfg<Enter><Enter>' ],
  :kickstart_port => "1994", :kickstart_timeout => 10000, :kickstart_file => "ks.cfg",
  :ssh_login_timeout => "600", :ssh_user => "root", :ssh_password => "vagrant", :ssh_key => "",
  :ssh_host_port => "2004", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'| sh '%f'",
  :shutdown_cmd => "/sbin/halt -h -p",
  :postinstall_files => [ "postinstall.sh"], :postinstall_timeout => 10000
})
