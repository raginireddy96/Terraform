#Create subnet groups for Redis
resource "aws_elasticache_subnet_group" "redis-subnet-group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.pp-private-subnet[0].id, aws_subnet.pp-private-subnet[1].id]
}

#Redis instance for pp-filesystem-cache
resource "aws_elasticache_cluster" "pp-filesystem-cache" {
  cluster_id           = "pp-filesystem-cache"
  availability_zone = var.azs[1]
  engine               = "redis"
  node_type            = var.pp-filesystem-cache-node-type
  num_cache_nodes      = var.pp-filesystem-cache-nodes
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name = "redis-subnet-group"
  security_group_ids = [aws_security_group.Redis-security-group.id]
  maintenance_window = "sun:10:00-sun:11:00"
  snapshot_window = "07:30-08:30"
  snapshot_retention_limit = "1"
}

resource "aws_elasticache_replication_group" "queue-broker-pp" {
  automatic_failover_enabled    = true
  availability_zones            = [var.azs[0],var.azs[1]]
  replication_group_id          = "queue-broker-pp"
  replication_group_description = "test description"
  number_cache_clusters         = 2
  engine               = "redis"
  engine_version       = "5.0.4"
  node_type                     = var.queue-broker-pp_node-type
  port                          = 6379
  subnet_group_name = "redis-subnet-group"
  security_group_ids = [aws_security_group.Redis-security-group.id]
  maintenance_window = "sun:10:00-sun:11:00"
  snapshot_window = "07:30-08:30"
  snapshot_retention_limit = "1"

  #cluster_mode {
   # replicas_per_node_group = 1
    #num_node_groups         = 1
  #}
}

