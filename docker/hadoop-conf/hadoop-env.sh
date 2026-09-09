if [ -z "${JAVA_HOME:-}" ]; then
  JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
  export JAVA_HOME
fi
export HADOOP_LOG_DIR="${HADOOP_LOG_DIR:-/var/log/hadoop}"
export HADOOP_PID_DIR="${HADOOP_PID_DIR:-/var/run/hadoop}"
