**VeeWee:** the tool to easily build vagrant base boxes
Vagrant is a great tool to test new things or changes in a virtual machine(Virtualbox) using either chef or puppet.
The first step is to download an existing 'base box'. I believe this scares a lot of people as they don't know who or how this box was build. Therefore lots of people end up first building their own base box to use with vagrant.

Veewee tries to automate this and to share the knowledge and sources you need to create a basebox. Instead of creating custom ISO's from your favorite distribution, it leverages the 'keyboardputscancode' command of Virtualbox so send the actual 'boot prompt' keysequence to boot an existing iso.

Before we can actually build the boxes, we need to take care of the minimal things to install:
- Have Virtualbox 4.x installed -> download it from http://download.virtualbox.org/virtualbox/


ALPHA CODE: -> you're on your own....

## Installation: 
__from source__

<pre>
$ git clone https://github.com/jedi4ever/veewee.git
$ cd veewee
$ gem install bundler
$ bundle install
</pre>
__as a gem__
<pre>
$ gem install veewee 
</pre>

## List all templates
<pre>
$ vagrant basebox templates
The following templates are available:
vagrant basebox define 'boxname' 'CentOS-4.8-i386'
vagrant basebox define 'boxname' 'CentOS-5.5-i386'
vagrant basebox define 'boxname' 'CentOS-5.5-i386-netboot'
vagrant basebox define 'boxname' 'ubuntu-10.04.1-server-amd64'
vagrant basebox define 'boxname' 'ubuntu-10.04.1-server-i386'
vagrant basebox define 'boxname' 'ubuntu-10.10-server-amd64'
vagrant basebox define 'boxname' 'ubuntu-10.10-server-i386'

</pre>
## Define a new box 
Let's define a  Ubuntu 10.10 server i386 basebox called myunbuntubox
this is essentially making a copy based on the  templates provided above.
<pre>$ vagrant basebox define 'myubuntubox' 'ubuntu-10.10-server-i386'</pre>
template successfully copied

-> This copies over the templates/ubuntu-10.10-server-i386 to definition/myubuntubox

<pre>$ ls definitions/myubuntubox
definition.rb	postinstall.sh	postinstall2.sh	preseed.cfg
</pre>

## Optionally modify the definition.rb , postinstall.sh or preseed.cfg

<pre>
Veewee::Session.declare( {
  :cpu_count => '1', :memory_size=> '256', 
  :disk_size => '10140', :disk_format => 'VDI',:disk_size => '10240' ,
  :os_type_id => 'Ubuntu',
  :iso_file => "ubuntu-10.10-server-i386.iso", 
  :iso_src => "http://releases.ubuntu.com/maverick/ubuntu-10.10-server-i386.iso",
  :iso_md5 => "ce1cee108de737d7492e37069eed538e",
  :iso_download_timeout => "1000",
  :boot_wait => "10",
  :boot_cmd_sequence => [ 
      '<Esc><Esc><Enter>',
      '/install/vmlinuz noapic preseed/url=http://%IP%:%PORT%/preseed.cfg ',
      'debian-installer=en_US auto locale=en_US kbd-chooser/method=us ',
      'hostname=%NAME% ',
      'fb=false debconf/frontend=noninteractive ',
      'console-setup/ask_detect=false console-setup/modelcode=pc105 console-setup/layoutcode=us ',
      'initrd=/install/initrd.gz -- <Enter>' 
    ],
  :kickstart_port => "7122", :kickstart_timeout => "10000",:kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "10000",:ssh_user => "vagrant", :ssh_password => "vagrant",:ssh_key => "",
  :ssh_host_port => "2222", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "shutdown -H",
  :postinstall_files => [ "postinstall.sh"],:postinstall_timeout => "10000"
   }
)
</pre>

If you need to change values in the templates, be sure to run the rake undefine, the rake define again to copy the changes across.

## Getting the cdrom file in place
Put your isofile inside the 'currentdir'/iso directory or if you don't run
<pre>$ vagrant basebox build 'myubuntubox'</pre>

- the build assumes your iso files are in 'currentdir'/iso
- if it can not find it will suggest to download the iso for you

## Build the new box:
<pre>
$ vagrant basebox build 'myubuntubox'</pre>

- This will create a machine + disk according to the definition.rb
- Note: :os_type_id = The internal Name Virtualbox uses for that Distribution
- Mount the ISO File :iso_file
- Boot up the machine and wait for :boot_time
- Send the keystrokes in :boot_cmd_sequence
- Startup a webserver on :kickstart_port to wait for a request for the :kickstart_file
- Wait for ssh login to work with :ssh_user , :ssh_password
- Sudo execute the :postinstall_files

## Export the vm to a .box file
<pre>$ vagrant basebox export 'myubuntubox' </pre>

this is actually calling - vagrant package --base 'myubuntubox' --output 'boxes/myubuntubox.box'

this will result in a myubuntubox.box

## Add the box as one of your boxes
To import it into vagrant type:

<pre>$ vagrant box add 'myubuntubox' 'myubuntubox.box'
</pre>
## Use it in vagrant

To use it:
<pre>
$ vagrant init 'myubuntubox'
$ vagrant up
$ vagrant ssh
</pre>
## If you have a setup working, share your 'definition' with me. That would be fun! 

IDEAS:

- Now you integrate this with your CI build to create a daily basebox

FUTURE IDEAS:

- use snapshots to fastforward initial boot, and every postinstall command
- export to AMI too
- provide for more failsafe execution, testing parameters
- use more virtualbox ruby instead of calling the VBoxManage command
- Verify the installation with cucumber-nagios (ssh functionality)
- Do the same for Vmware Fusion

BUGS: Lots = Like I said it currently works for me, on my machine and with the correct magic sequence :)
