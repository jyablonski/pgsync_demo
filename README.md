# Postgres ElasticSearch Sync

Example Repo working with [pgsync](https://github.com/toluaina/pgsync) to sync data in real time from Postgres to Elasticsearch or Opensearch.

Run `make up` which will spin up 6 Containers and serve a Kibana instance avaialble at `http://localhost:5601`.

- Postgres Database
- Redis Database
- Event Producer Python Script
- Opensearch Database
- Kibana Instance
- pgsync Container

Events are continuously produced by the Python Script, stored to Postgres, and then streamed over from Postgres to Opensearch. To view the data in Kibana, you'll have to manually edit the Indicies created in Opensearch to set Replicas -> 0, and then create some Index Patterns to search on (`bookings*`, `events*`, `venues*`).

When finished run `make down` to spin resources down.

## How It Works

pgsync streams data in real time from Postgres to Elasticsearch or Opensearch. It requires the following components:

- Postgres Database
  - Logical Replication must be Enabled and the pgsync user must have replication permission
- Elasticsearch Cluster
- Redis Database

From there, all you have to do is manually create a `schema.json` File to tell the tool how to map your Postgres Tables into Elasticsearch or Opensearch. This was a pain to create, but I think it makes sense after some troubleshooting.

You can declare multiple schemas in the same config. This can be useful for syncing multiple tables into different Elasticsearch/OpenSearch indices.

``` json
[
    {
        "database": "book",
        "index": "book_index",
        "nodes": {
            "table": "book"
        }
    },
    {
        "database": "book",
        "index": "author_index",
        "nodes": {
            "table": "author"
        }
    }
]
```

- `database` is the Postgres Database. `index` is the name of the Index that will be created in Elasticsearch or Opensearch. `nodes` references the tables in Postgres.
- This example will create 2 Indicies in Elasticsearch, 1 for the book table and 1 for the author table.
- My JSON File is available in `pg_sync/schema.json`

You can also:

- Define relationships between Postgres tables so that the data for them is joined together in Elasticsearch or Opensearch.
- Rename columns as they're streamed over

## pgsync Alternatives 

The other primary CDC solution alternative to `pgsync` is a Debezium setup to track data changes in your Postgres Database, which sends them off to Apache Kafka and stores the messages into Topics for each Database Table you're capturing. From there, you could use a Sink to unload data from the Kafka Topics into Elasticsearch or Opensearch, or build an in-house tool to read from the Topics and manage inserting data into Elasticsearch or Opensearch yourself.

- The difference is in architecture. `pgsync` requires a Redis Database and a Python Instance to run, which is less computationally intensive than rolling out your own Debezium + Kafka Architecture.
- But, the Debezium + Kafka Architecture is probably better for large orgs who have the engineering talent capable of supporting it. This also enables you to stream data changes from the Postgres database to other sources besides Elasticsearch or Opensearch, such as a Data Warehouse or any other supported Sink connector.

## Opensearch Examples

![image](https://github.com/user-attachments/assets/ba8b8570-0c85-4d94-8885-4e7b70634690)
![image](https://github.com/user-attachments/assets/5027cb6f-8755-4373-84c1-1345f896ecd8)
![image](https://github.com/user-attachments/assets/b00b5e0b-34b7-465f-976e-71fe608fcaac)
