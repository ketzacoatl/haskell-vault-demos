#!/usr/bin/env bash

set -uex

killall vault-demo || true
vault-demo &
