#!/bin/sh

git filter-branch -f --env-filter "GIT_AUTHOR_NAME='skifary'; GIT_AUTHOR_EMAIL='gskifary@outlook.com'; GIT_COMMITTER_NAME='Kinghht'; GIT_COMMITTER_EMAIL='1012809472@qq.com';" HEAD
