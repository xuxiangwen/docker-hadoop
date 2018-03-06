#!/usr/bin/expect -f

#if you don't install expect, run `sudo yum install expect`
set server [lindex $argv 0 ]
set user [lindex $argv 1 ]
set password [lindex $argv 2 ]
set newuser [lindex $argv 3 ]
set newpassword [lindex $argv 4 ]

set timeout 4
spawn ssh $user@$server
expect {
"*yes/no" { send "yes\r"; exp_continue}
"*assword:" { send "$password\r" }
}
expect "#*"
send "sudo useradd $newuser\r"
send "sudo passwd $newuser\r"
expect "*New password:" {send "$newpassword\r"}
expect "*Retype new password:" {send "$newpassword\r"}

send "echo $newuser    ALL=\\(ALL\\)       NOPASSWD: ALL   > ~/$newuser\r"
send "chmod 440 ~/$newuser\r "
send "sudo chown root:root ~/$newuser\r "
send "sudo mv ~/$newuser /etc/sudoers.d\r"

send "exit\r"
expect eof

