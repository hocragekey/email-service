#!/bin/bash
set -o errexit -o nounset
cd tf
export TF_VAR_account_id=$AWS_ACCESS_KEY_ID
terraform plan
terraform apply


NOW=$(TZ=America/New_York date)
echo $GH_USER_NAME
git config user.name $GH_USER_NAME
git config user.email $GH_USER_EMAIL
git remote add upstream "https://$GH_TOKEN@github.com/$GH_USER_NAME/email-service.git"
git checkout master
git add .
git commit -m "tfstate: $NOW [ci skip]"
git push upstream master
