#!/bin/bash

echo "Waiting for elasticsearch bootup..."
sleep 10

echo "Running elasticseach instance's healthcheck..."
curl http://elasticsearch:9200/_cat/health

echo "Starting main operation loop..."
while ! curl  -H 'Content-Type: application/json' -XPUT 'http://elasticsearch:9200/_template/naver_crawled' -d '
{
	"index_patterns": ["ko-*"],
	"settings": {
		"number_of_shards": 1,
		"number_of_replicas": 0
	},
	"mappings": {
		"doc":{
			"properties": {
				"title": {
					"type": "text",
					"term_vector": "with_positions_offsets_payloads",
					"store" : true,
	          		"analyzer": "nori"
		        },
	        	"text": {
	          		"type": "text",
	          		"term_vector": "with_positions_offsets_payloads",
	          		"store" : true,
		        	"analyzer": "nori"
	        	}
			}
		}
  	}
}'; do
	sleep 5
done

curl -H 'Content-Type: application/json' -XPUT 'http://elasticsearch:9200/_snapshot/es_backup' -d '{
    "type": "fs",
    "settings": {
        "location": "/opt/elasticsearch/backup"
    }
}'

tini -- /bin/entrypoint.sh fluentd
