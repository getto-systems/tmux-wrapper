#!/bin/bash

git remote add super https://getto-systems:$GITLAB_ACCESS_TOKEN@gitlab.com/getto-systems-labo/tmux-wrapper.git
git remote add backup https://getto-systems:$GITHUB_ACCESS_TOKEN@github.com/getto-systems/tmux-wrapper.git
git tag $(cat .release-version)
git push super HEAD:master --tags
git push backup HEAD:master --tags
