ssh:
	git push
	ssh island 'zsh -s' < ssh.sh
