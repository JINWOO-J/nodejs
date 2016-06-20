REPO = dr.ytlabs.co.kr
REPO_HUB = jinwoo
NAME = nodejs
VERSION = 4.4.5
nodejs_modules = gds_nodejs_modules
NPM_LIST = pm2@0.15.10 gulp@3.9.0 bower@1.7.2 nodemon@1.8.1 gulp-livereload@3.8.1
ModuleVERSION = 1.0

include ENVAR

.PHONY: all build push test tag_latest release ssh bash push_hub

all: build 

build:
	cat .Dockerfile | sed  "s/__NODEJS_VERSION__/v$(VERSION)/g"   > Dockerfile
	docker build --no-cache --rm=true -t $(NAME):$(VERSION) .

push:
	docker tag -f$(NAME):$(VERSION) $(REPO)/$(NAME):$(VERSION)
	docker push $(REPO)/$(NAME):$(VERSION)

push_hub:
	docker tag -f $(NAME):$(VERSION) $(REPO_HUB)/$(NAME):$(VERSION)
	docker push $(REPO_HUB)/$(NAME):$(VERSION)

build_hub:
	echo "TRIGGER_KEY" ${TRIGGERKEY}
	cat .Dockerfile | sed  "s/__NGINX_VERSION__/nginx-$(VERSION)/g"   > Dockerfile
	git add .
	git commit -m "$(NAME):$(VERSION) by Makefile"
	git tag -a "$(VERSION)" -m "$(VERSION) by Makefile"
	git push origin --tags
	curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "$(VERSION)"}' -X POST https://registry.hub.docker.com/u/jinwoo/${NAME}/trigger/${TRIGGERKEY}/

bash:
	docker run --entrypoint="bash" --rm -it $(NAME):$(VERSION)

tag_latest:
	docker tag -f $(REPO)/$(NAME):$(VERSION) $(REPO)/$(NAME):latest
	docker push $(REPO)/$(NAME):latest

init:
	git init
	git add .
	git commit -m "first commit"
	git remote add origin git@github.com:JINWOO-J/$(NAME).git
	git push -u origin master
	
build_module:
	mkdir -p export/
			
	docker run -i -t --name temp_volume -v /usr/local/node/lib/node_modules busybox true
	docker run --rm -it -v ${PWD}/installer.sh:/installer.sh -v ${PWD}/package.json:/usr/local/node/lib/package.json -v ${PWD}/npm_installer.sh:/usr/local/node/npm_installer.sh \
                --volumes-from temp_volume --cidfile "./cidfile" \
                -e "NodeVersion=${NodeVersion}" --name nodejs_modules_builder $(NAME):$(VERSION) bash -c "/installer.sh v$(VERSION)"
	docker cp temp_volume:/usr/local/node/lib/node_modules ./export/                
	docker build -f Dockerfile_module --no-cache -t $(nodejs_modules)/$(ModuleVERSION) .	
#	docker tag  -f ${nodejs_modules}:${ModuleVersion} ${REPO}/${nodejs_modules}:${ModuleVersion}
#	docker -D push ${REPO}/${nodejs_modules}:${ModuleVersion}	
	docker stop temp_volume
	docker rm -f temp_volume

clean:
	rm -f ./cidfile
	docker stop temp_volume
	docker rm -f temp_volume
	rm -rf ./export/*




