#!/bin/bash
reg_token_url="https://api.github.com/orgs/${repo_owner}/actions/runners/registration-token"
echo "Registration URL: $reg_token_url"
reg_token=$(curl -sL -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${auth_token}" -H "X-GitHub-Api-Version: 2022-11-28" $reg_token_url | jq -r '.token')
echo "Retrieved registration token reg_token=$reg_token"
cd /home/ubuntu/action-runner/
sudo -u ubuntu ./config.sh --unattended --labels $labels --url https://github.com/${repo_owner} --token $reg_token --name ${runner_name} --disableupdate --ephemeral
/home/ubuntu/action-runner/bin/runsvc.sh
