#!/bin/sh

git filter-branch -f --env-filter "GIT_AUTHOR_NAME='skifary'; GIT_AUTHOR_EMAIL='gskifary@outlook.com'; GIT_COMMITTER_NAME='Skifary'; GIT_COMMITTER_EMAIL='376512563@qq.com';" HEAD
