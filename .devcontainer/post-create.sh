#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="/workspaces/hadoop-example"
CURRENT_USER=$(whoami)

sudo mkdir -p ${TARGET_DIR}

sudo chown ${CURRENT_USER}:root ${TARGET_DIR}

git clone https://github.com/hibuz/hadoop-example.git ${TARGET_DIR}

sudo chown -R ${CURRENT_USER}:root ${TARGET_DIR}

sudo chmod -R 755 ${TARGET_DIR}