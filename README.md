# Docker-EFK

Containerized `Elasticsearch`-`Fluentd`-`Kibana` stack for web scrapping. In a 
nutshell, `fluentd` runs `naver_crawler.py` and pushes crawled data to `elasticsearch`.

## Usage

Build all images (if not already existing) and spin the container:
```bash
cd mrc-crawler && docker-compose up
```
**Note**: Data volumes (`es-data` and `es-backup`) will persist, so it’s possible to start the cluster again with the 
same data using `docker-compose up`. To destroy containers and volumes, just type 
`docker-compose down -v`.

**Important**: Elasticsearch uses a hybrid mmapfs / niofs directory by default to 
store its indices. The default operating system limits on mmap counts is likely to be too 
low, which may result in out of memory exceptions. On Linux, increase the limits by 
running:

```bash
sudo sysctl -w vm.max_map_count=262144
```

 