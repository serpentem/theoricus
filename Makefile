.PHONY: docs

THE=bin/the
POLVO=node_modules/polvo/bin/polvo

SELENIUM=tests/www/services/selenium-server-standalone-2.35.0.jar
SAUCE_CONNECT=tests/www/services/Sauce-Connect.jar
CHROME_DRIVER=tests/www/services/chromedriver

CS=node_modules/coffee-script/bin/coffee
MOCHA=node_modules/mocha/bin/mocha
COVERALLS=node_modules/coveralls/bin/coveralls.js

MVERSION=node_modules/mversion/bin/version
VERSION=`$(MVERSION) | sed -E 's/\* package.json: //g'`

YUIDOC=node_modules/yuidocjs/lib/cli.js


# SETTTING UP DEV ENV
#-------------------------------------------------------------------------------

install_test_suite:
	@mkdir -p tests/www/services

	@echo '-----'
	@echo 'Downloading Selenium..'
	@curl -o tests/www/services/selenium-server-standalone-2.35.0.jar \
		https://selenium.googlecode.com/files/selenium-server-standalone-2.35.0.jar
	@echo 'Done.'

	@echo '-----'
	@echo 'Downloading Chrome Driver..'
	@curl -o tests/www/services/chromedriver.zip \
		https://chromedriver.googlecode.com/files/chromedriver_mac32_2.3.zip
	@echo 'Done.'
	
	@echo '-----'
	@echo 'Unzipping chromedriver..'
	@cd tests/www/services/; unzip chromedriver.zip; \
		rm chromedriver.zip; cd -
	@echo 'Done.'

	@echo '-----'
	@echo 'Downloading Sauce Connect..'
	@curl -o tests/www/services/sauceconnect.zip \
		http://saucelabs.com/downloads/Sauce-Connect-latest.zip
	
	@echo '-----'
	@echo 'Unzipping Sauce Connect..'
	@cd tests/www/services/; unzip sauceconnect.zip; \
		rm NOTICE.txt license.html sauceconnect.zip; cd -
	@echo '-----'
	@echo 'Done.'
	@echo 


setup: install_test_suite
	@echo '-----'
	npm link


# DEVELOPING
#-------------------------------------------------------------------------------

# watch / build
watch:
	$(CS) -wmco lib cli/src

build:
	$(CS) -mco lib cli/src


# GENERATING DOCS
#-------------------------------------------------------------------------------

# docs generation
docs.www:
	cd www/src && \
	../../$(YUIDOC) \
	--syntaxtype coffee \
	-e .coffee \
	-o ../../docs/www \
	-t ../../docs/bootstrap-theme \
	-H ../../docs/bootstrap-theme/helpers/helpers.js \
	.

docs.www.server:
	cd www/src && \
	../../$(YUIDOC) \
	--syntaxtype coffee \
	-e .coffee \
	-o ../../docs/www \
	-t ../../docs/bootstrap-theme \
	-H ../../docs/bootstrap-theme/helpers/helpers.js \
	--server \
	.



# TESTS
#-------------------------------------------------------------------------------

# SELENIUM & SAUCE CONNECT
test.selenium.run:
	@java -jar $(SELENIUM) -Dwebdriver.chrome.driver=$(CHROME_DRIVER)

test.sauce.connect.run:
	@java -jar $(SAUCE_CONNECT) $(SAUCE_USERNAME) $(SAUCE_ACCESS_KEY)

# MANUALLY TESTING PROBATUS
test.probatus:
	@$(THE) -s --base tests/www/probatus

# BUILDING TEST APP
test.build.prod:
	@echo 'Building app before testing..'
	@$(THE) -r --base tests/www/probatus > /dev/null

test.build.split:
	@echo 'Compiling app before testing..'
	@# @$(THE) -c --base tests/www/probatus > /dev/null
	@$(POLVO) -cxb tests/www/probatus > /dev/null


# NORMALIZING COVERAGE AND POSTING TO COVERALLS
test.cover.normalize:
	@sed -i.bak \
		"s/^.*public\/__split__\/theoricus\/www\/src\/theoricus/SF:theoricus/g" \
		tests/www/coverage/lcov.info

test.cover.publish:
	@cd tests/www/probatus/public/__split__/theoricus/www/src && \
		cat ../../../../../../coverage/lcov.info | \
		../../../../../../../../$(COVERALLS)
	
	@cd ../../../../../../../../	

# TESTING LOCALLY
test: test.build.prod
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='local'

test.cover: test.build.split
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='local' --coverage

test.coveralls: test.cover test.cover.normalize test.cover.publish

test.cover.preview: test.cover
	@cd tests/www/coverage/lcov-report; python -m SimpleHTTPServer 8080; cd -


# TESTING ON SAUCE LABS

# NOTE: The `--bail` option is hidden until Mocha fix the hooks execution
#   https://github.com/visionmedia/mocha/issues/937

test.sauce: test.build.prod
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='sauce labs'

test.sauce.cover: test.build.split
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='sauce labs' --coverage

test.sauce.coveralls: test.sauce.cover test.cover.normalize test.cover.publish


test.travis:
# Technique (skipping pull requests) borrowed from WD:
#   https://github.com/admc/wd/blob/master/Makefile
ifdef TRAVIS
# secure env variables are not available for pull reuqests
# so you won't be able to run test against Sauce on these
ifneq ($(TRAVIS_PULL_REQUEST),false)
	@echo 'Skipping Sauce Labs tests as this is a pull request'
else
	@make test.coveralls
endif
else
	@make test.coveralls
endif


# MANAGING VERSIONS
#-------------------------------------------------------------------------------

bump.minor:
	@$(MVERSION) minor

bump.major:
	@$(MVERSION) major

bump.patch:
	@$(MVERSION) patch


# PUBLISHING / RE-PUBLISHING
#-------------------------------------------------------------------------------

publish:
	git tag $(VERSION)
	git push origin $(VERSION)
	git push origin master
	npm publish

re-publish:
	git tag -d $(VERSION)
	git tag $(VERSION)
	git push origin :$(VERSION)
	git push origin $(VERSION)
	git push origin master -f
	npm publish -f