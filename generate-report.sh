#!/bin/sh

set -eu;

# Set up dart pub environment
export PATH="$PATH":"$HOME/.pub-cache/bin";

(
	cd "benchmark";
	dart pub get;
)

cd "$(dirname "$0")";

TEST_BACKENDS=$(ls backends);
if [ "$#" -gt 0 ]; then
	TEST_BACKENDS="$*";
fi

for backend in ${TEST_BACKENDS}; do
	if [ "${backend}" = "dart_conduit" ]; then
		echo "skipping ${backend} due to issues";
		continue;
	fi

	echo "testing ${backend}";

	(
		cd "backends/${backend}";
		chmod +x ./run.sh;
		./run.sh;
	) | sed "s/^/  /" &

	# wait for server to start
	while ! curl -q "http://127.0.0.1:8080" > /dev/null 2>&1; do
		sleep 3;
	done

	# run tests
	echo "running tests - ${backend}";
	(
		cd "benchmark";
		dart run benchmark ${backend};
	)

	# kill children processes
	echo "killing ${backend} process";
	children_pids="";
	for pid in /proc/*; do
		case "${pid}" in
			/proc/*[!0-9]* | "/proc/$$")
				continue;
				;;
			*)
				if grep -P "^\d+ \(.*\) [RSDZTW] \d+ $$ " "${pid}/stat" > /dev/null; then
					children_pids="${children_pids} ${pid#/proc/}";
				fi
				;;
		esac
	done

	children_running="true";
	while [ "${children_running}" = "true" ]; do
		children_running="false";
		for pid in ${children_pids}; do
			if ps -p "${pid}" > /dev/null; then
				children_running="true";
				echo "killing ${backend} with pid ${pid}";
				kill "${pid}";
			fi
		done

		sleep 1;
	done

	# wait for server to stop
	# while curl -q "http://127.0.0.1:8080" > /dev/null 2>&1; do
	# 	sleep 3;
	# done
	echo;
done
