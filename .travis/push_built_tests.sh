#! /usr/bin/env sh
#
# Helper script run from travis that pushes compiled tests to github so they can be referenced by coverage providers
#
# travis clones in a weird way and the head gets detached, so checkout master again
git checkout .
git checkout master
# decrypt private key that gives us push access and add it to ssh agent
openssl aes-256-cbc -K $encrypted_c4563c0abb0a_key -iv $encrypted_c4563c0abb0a_iv -in .travis/travis_deploy_key.enc -out .travis/travis_deploy_key -d
eval "$(ssh-agent -s)"
echo "running chmod command"
chmod 600 .travis/travis_deploy_key
echo "moving the encryption file to id_rsa"
mv .travis/travis_deploy_key ~/.ssh/id_rsa
echo "adding encryption file to ssh"
ssh-add .travis/travis_deploy_key
# using -f as www/build is in .gitignore for dev purposes
git add -f www/build/test/app
git remote rm origin                                       # originally cloned by travis on https
git remote add origin git@github.com:udayakanth1122/ionic2-karma-jasmine-travis-seed.git  # ditto
# careful not to trigger another build
git -c user.name='travis' -c user.email='travis@travis-ci.org' commit -m "updating compiled tests [ci skip]"
git push origin master
