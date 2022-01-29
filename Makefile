update-kubeconfig:
	aws eks update-kubeconfig --name workshop --alias workshop --region eu-west-2
deploy:
	./scripts/deploy.sh
clean:
	./scripts/clean.sh

