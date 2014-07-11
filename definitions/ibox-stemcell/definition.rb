Veewee::Session.declare({
  # Minimum RAM requirement for installation is 512MB.
  :cpu_count => '1', :memory_size=> '1024',
  :disk_size => '10140', :disk_format => 'VDI', :hostiocache => 'off', :hwvirtext => 'on',
  :os_type_id => 'RedHat6_64',
  :iso_file => "CentOS-7.0-1406-x86_64-NetInstall.iso",
  :iso_src => "http://linuxsoft.cern.ch/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-NetInstall.iso",
  :iso_sha256 => "df6dfdd25ebf443ca3375188d0b4b7f92f4153dc910b17bccc886bd54a7b7c86",
  :iso_download_timeout => 1000,
  :boot_wait => "10", :boot_cmd_sequence => [ '<Tab> linux text biosdevname=0 ks=http://%IP%:%PORT%/ks.cfg<Enter><Enter>' ],
  :kickstart_port => "1994", :kickstart_timeout => 10000, :kickstart_file => "ks.cfg",
  :ssh_login_timeout => "6000", :ssh_user => "root", :ssh_password => "vagrant", :ssh_key => "",
  :ssh_host_port => "2004", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'| sh '%f'",
  :shutdown_cmd => "/sbin/halt -h -p",
  :postinstall_files => [ "postinstall.sh"], :postinstall_timeout => 10000
})
