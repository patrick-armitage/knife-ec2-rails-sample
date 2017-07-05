#!/bin/bash
knife ec2 server create -r 'role[interview]' -I 'ami-########' -f 't2.micro' -g 'sg-########' -N 'interview-rails' --subnet 'subnet-########' -i ~/.ssh/Interview.pem --ssh-user ubuntu -S 'Interview'
