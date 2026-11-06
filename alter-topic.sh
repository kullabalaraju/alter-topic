#!/bin/bash
set -e

TOPIC_FILE="alter-topic-definition.yaml"

# Check for yq
command -v yq >/dev/null || { echo "yq is required to parse YAML"; exit 1; }

# Loop through topics
yq -e '.topics[] | [.name, .partitions] | @tsv' "$TOPIC_FILE" | while IFS=$'\t' read -r NAME PARTITIONS; do
    echo "Alter topic: $NAME"
    /usr/bin/kafka-topics --alter --bootstrap-server 192.168.137.140:9092 \
    --topic "$NAME" \
    --partitions "$PARTITIONS"
done
