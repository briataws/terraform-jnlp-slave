#!/bin/bash -x

curl -sL https://api.github.com/repos/actions/runner/releases/latest -o release.json
latest_version=$(cat release.json | jq -r ".tag_name")
latest_version_number=$(echo "$latest_version" | cut -c2-)
download_file_name="actions-runner-linux-x64-${latest_version_number}.tar.gz"
download_file_url="https://github.com/actions/runner/releases/download/${latest_version}/${download_file_name}"
curl -sL ${download_file_url} -o ${download_file_name}
mkdir -p /home/ubuntu/action-runner
tar -zxvf $download_file_name -C /home/ubuntu/action-runner
