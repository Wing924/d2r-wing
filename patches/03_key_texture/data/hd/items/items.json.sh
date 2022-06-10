#!/bin/sh

sed \
  -e '/"pk1":/s/mephisto_key/countess_key/' \
  -e '/"pk2":/s/mephisto_key/summoner_key/' \
  -e '/"pk3":/s/mephisto_key/nihlathak_key/'
