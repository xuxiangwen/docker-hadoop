#!/usr/bin/expect -f

#if you don't install expect, run `sudo yum install expect`
set server [lindex $argv 0 ]
set user [lindex $argv 1 ]
set password [lindex $argv 2 ]
set master [lindex $argv 3]

set timeout 7
spawn ssh $user@$server
expect {
"*yes/no" { send "yes\r"; exp_continue}
"*assword:" { send "$password\r" }
}
expect "#*"
send "ll ~/.ssh/id_rsa.pub\r"
expect {
"*No such file or directory" {send "sudo rm -rf ~/.ssh; ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa\r"}
"*Not a directory" {send "sudo rm -rf ~/.ssh; ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa\r"}
}
send "ll ~/.ssh/id_rsa.pub\r"
send "exit\r"
expect eof
spawn ssh-copy-id $user@$server 
expect {
"*Are you sure you want to continue connecting*" {send "yes\r; exp_continue "}
"*assword:" { send "$password\r" }
"Now try logging into the machine*" {send 'echo logging success'}
}
expect "#*"
send "tail -n ~/.ssh/" 
expect eof

