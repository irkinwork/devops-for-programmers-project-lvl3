install:
	ansible-galaxy install -r requirements.yml

run:
	ansible-playbook ansible/playbook.yml -i ansible/hosts --vault-password-file .ansible-vault

prepare:
	ansible-playbook ansible/preparing.yml -i ansible/hosts --vault-password-file .ansible-vault

deploy:
	ansible-playbook ansible/playbook.yml -i ansible/hosts -t deploy --vault-password-file .ansible-vault

datadog:
	ansible-playbook ansible/datadog.yml -i ansible/hosts --vault-password-file .ansible-vault

lint:
	terraform -chdir=terraform fmt
