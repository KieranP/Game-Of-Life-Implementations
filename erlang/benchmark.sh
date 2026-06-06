#!/bin/bash

source ../helpers.sh

echo -n "Erlang - "
erl -noshell -eval 'io:format("OTP ~s~n", [erlang:system_info(otp_release)]), halt().'

compile erlc -W cell.erl world.erl
benchmark escript play.erl
