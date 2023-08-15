# Switch to this if using Docker Compose
Elasticsearch::Model.client = Elasticsearch::Client.new(host: 'elasticsearch', log: true)

# Switch to this if running services independently
# Elasticsearch::Model.client = Elasticsearch::Client.new(host: 'localhost', log: true)
