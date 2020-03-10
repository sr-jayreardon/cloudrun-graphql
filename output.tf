output "current_location_id" {
  value = "${google_redis_instance.memoryStore.current_location_id}"
}
output "host" {
  value = "${google_redis_instance.memoryStore.host}"
}
output "port" {
  value = "${google_redis_instance.memoryStore.port}"
}
output "alternative_location_id" {
  value = "${google_redis_instance.memoryStore.alternative_location_id}"
}