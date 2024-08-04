#!/bin/bash

sudo cp intel-no-turbo.service /etc/systemd/system/intel-no-turbo.service

chmod +x intel-no-turbo.sh

sudo cp intel-no-turbo.sh /etc/systemd/system/intel-no-turbo.sh

systemctl daemon-reload

systemctl enable intel-no-turbo.service
