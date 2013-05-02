#!/bin/sh

rm db.json
rm -rf .deploy
hexo deploy --generate
