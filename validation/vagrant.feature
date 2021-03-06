Feature: vagrant box validation
  As a user of example.org
  I need to login remotely

Scenario: Checking login
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password | port |
	| vagrant | vagrant  | 7222 |
	And I run "whoami"
	Then I should see "vagrant" in the output

Scenario: Checking sudo
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password | port |
	| vagrant | vagrant  | 7222 |
	And I run "sudo whoami"
	Then I should see "root" in the output

Scenario: Checking ruby
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password | port |
	| vagrant | vagrant  | 7222 |
	And I run ". /etc/profile ;ruby --version 2> /dev/null 1> /dev/null;  echo $?"
	Then I should see "0" in the output

Scenario: Checking gem
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password | port |
	| vagrant | vagrant  | 7222 |
	And I run ". /etc/profile; gem --version 2> /dev/null 1> /dev/null ; echo $?"
	Then I should see "0" in the output

Scenario: Checking chef
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password | port |
	| vagrant | vagrant  | 7222 |
	And I run ". /etc/profile ;chef-client --version 2> /dev/null 1>/dev/null; echo $?"
	Then I should see "0" in the output

Scenario: Checking puppet
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password | port |
	| vagrant | vagrant  | 7222 |
	And I run ". /etc/profile ; puppet --version 2> /dev/null 1>/dev/null; echo $?"
	Then I should see "0" in the output

Scenario: Checking puppet
	When I ssh to "127.0.0.1" with the following credentials: 
	| username| password |keyfile  | port |
	| vagrant | vagrant  | vagrant-private.key | 7222 |
	And I run "whoami"
	Then I should see "vagrant" in the output
