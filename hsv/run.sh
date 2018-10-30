#!/usr/bin/env bash

set -uex

killall hsv-exe || true
hsv-exe &

