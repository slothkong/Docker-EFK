
while ! curl  -H 'Content-Type: application/json' -XPUT 'elasticsearch:9200/_template/naver_crawled' -d '
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

curl -H 'Content-Type: application/json' -XPUT 'elasticsearch:9200/_snapshot/es_backup' -d '
{
	"index_patterns": ["ko-*"],
    "type": "fs",
    "settings": {
        "location": "/opt/elasticsearch/backup"
    }
}'

tini -- /bin/entrypoint.sh fluentd





# PUT /_template/naver_news
# {
#   "index_patterns": [“na*”],
# 	"settings": {
# 		"number_of_shards": "1",
# 		"number_of_replicas": "0"
# 	},
# 	"mappings": {
# 		“type”: {
# 			"naver_news": {
# 				"properties": {
# 					"title": {
# 						"type": "text",
# 						"term_vector": "with_positions_offsets_payloads",
# 						"store" : true,
# 	          			"analyzer": "openkoreantext-analyzer"
# 		        	},
# 	        		"text": {
#           			"type": "text",
#           			"term_vector": "with_positions_offsets_payloads",
#           			"store" : true,
# 	          		"analyzer": "openkoreantext-analyzer"
#         			}
#       			}
# 			}
# 	    }
#   	}
# }