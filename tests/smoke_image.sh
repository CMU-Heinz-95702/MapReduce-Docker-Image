#!/usr/bin/env bash
set -Eeuo pipefail

readonly image="${1:?usage: smoke_image.sh IMAGE}"
readonly container="lab9-hadoop-smoke-${GITHUB_RUN_ID:-local}"
readonly volume="${container}-data"
work_dir="$(mktemp -d)"

cleanup() {
  docker rm -f "$container" >/dev/null 2>&1 || true
  docker volume rm "$volume" >/dev/null 2>&1 || true
  rm -rf "$work_dir"
}
trap cleanup EXIT

mkdir -p "$work_dir/datasets" "$work_dir/workspace"
chmod 0777 "$work_dir/workspace"
touch \
  "$work_dir/datasets/words.txt" \
  "$work_dir/datasets/combinedYears.txt" \
  "$work_dir/datasets/P1V.txt" \
  "$work_dir/datasets/CrimeLatLonXYTabs.txt" \
  "$work_dir/checksums.sha256"

docker volume create "$volume" >/dev/null
docker run -d --name "$container" \
  -v "$work_dir/datasets:/home/public:ro" \
  -v "$work_dir/checksums.sha256:/opt/course/checksums.sha256:ro" \
  -v "$work_dir/workspace:/home/student/Project5:rw" \
  -v "$volume:/data/hadoop" \
  "$image" >/dev/null

for _ in {1..24}; do
  if docker exec "$container" hadoop-healthcheck; then
    docker exec "$container" id
    docker exec "$container" test -f \
      /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples.jar
    timeout 180 docker exec "$container" hadoop jar \
      /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples.jar \
      pi 2 100
    exit 0
  fi
  sleep 5
done

docker logs "$container"
exit 1
