#!/bin/bash

apk add jq

distribution='[
            {"size": "small", "label": "cpu_stressor=1cpu", "percentage": "50"},
            {"size": "small", "label": "cpu_stressor=2cpu", "percentage": "19"},
            {"size": "small", "label": "cpu_stressor=5cpu", "percentage": "7"},
            {"size": "small", "label": "cpu_stressor=10cpu", "percentage": "3"},
            {"size": "small", "label": "cpu_stressor=25cpu", "percentage": "4"},
            {"size": "small", "label": "cpu_stressor=50cpu", "percentage": "13"},
            {"size": "small", "label": "cpu_stressor=75cpu", "percentage": "4"},
            {"size": "medium", "label": "cpu_stressor=1cpu", "percentage": "59"},
            {"size": "medium", "label": "cpu_stressor=2cpu", "percentage": "5"},
            {"size": "medium", "label": "cpu_stressor=5cpu", "percentage": "5"},
            {"size": "medium", "label": "cpu_stressor=10cpu", "percentage": "5"},
            {"size": "medium", "label": "cpu_stressor=25cpu", "percentage": "5"},
            {"size": "medium", "label": "cpu_stressor=50cpu", "percentage": "5"},
            {"size": "medium", "label": "cpu_stressor=75cpu", "percentage": "11"},
            {"size": "medium", "label": "cpu_stressor=100cpu", "percentage": "5"},
            {"size": "large", "label": "cpu_stressor=1cpu", "percentage": "81"},
            {"size": "large", "label": "cpu_stressor=2cpu", "percentage": "3"},
            {"size": "large", "label": "cpu_stressor=5cpu", "percentage": "5"},
            {"size": "large", "label": "cpu_stressor=10cpu", "percentage": "3"},
            {"size": "large", "label": "cpu_stressor=25cpu", "percentage": "2"},
            {"size": "large", "label": "cpu_stressor=50cpu", "percentage": "3"},
            {"size": "large", "label": "cpu_stressor=75cpu", "percentage": "2"},
            {"size": "large", "label": "cpu_stressor=100cpu", "percentage": "1"},
            {"size": "x-large", "label": "cpu_stressor=1cpu", "percentage": "57"},
            {"size": "x-large", "label": "cpu_stressor=2cpu", "percentage": "7"},
            {"size": "x-large", "label": "cpu_stressor=5cpu", "percentage": "6"},
            {"size": "x-large", "label": "cpu_stressor=10cpu", "percentage": "7"},
            {"size": "x-large", "label": "cpu_stressor=25cpu", "percentage": "6"},
            {"size": "x-large", "label": "cpu_stressor=50cpu", "percentage": "6"},
            {"size": "x-large", "label": "cpu_stressor=75cpu", "percentage": "5"},
            {"size": "x-large", "label": "cpu_stressor=100cpu", "percentage": "6"},
            {"size": "xx-large", "label": "cpu_stressor=1cpu", "percentage": "86"},
            {"size": "xx-large", "label": "cpu_stressor=2cpu", "percentage": "2"},
            {"size": "xx-large", "label": "cpu_stressor=5cpu", "percentage": "2"},
            {"size": "xx-large", "label": "cpu_stressor=10cpu", "percentage": "2"},
            {"size": "xx-large", "label": "cpu_stressor=25cpu", "percentage": "2"},
            {"size": "xx-large", "label": "cpu_stressor=50cpu", "percentage": "2"},
            {"size": "xx-large", "label": "cpu_stressor=75cpu", "percentage": "2"},
            {"size": "xx-large", "label": "cpu_stressor=100cpu", "percentage": "2"}
]'

sizes=($(echo $distribution | jq -c '.[] | .size' | sort | uniq))
for size in ${sizes[@]}; do

    echo "Size $size"

    for pod in $(kubectl get pods -o name -l size=$size  -n scenario-ns --field-selector status.phase=Running); do
        echo "pod name $pod"

        echo "size again $size"


        probability=($(echo $distribution | jq -c '.[] | select(.workload_id == '$workload_id') | "\(.percentage)"'))
        labels=($(echo $distribution | jq -r '.[] | select(.workload_id == '$workload_id') | " \(.label)"'))

        random_number=$((RANDOM % 100))
        count=0

        echo "Random number: $random_number"
        index=0
        for i in ${probability[@]}; do

            i=${i//\"}
            echo "current probability $i"
            count=$((count + i))
            echo "counter $count"

            if [[ $random_number -le $count ]]; then
            echo ${labels[index]}
                kubectl label $pod ${labels[index]} -n scenario-ns --overwrite
                break
            fi
            index=$((index + 1))
        done
done
done
