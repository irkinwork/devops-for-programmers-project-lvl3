resource "datadog_monitor" "networkmonitor" {
  name    = "project3 monitor"
  type    = "service check"
  message = "@irin.work42@gmail.com"
  query   = "\"http.can_connect\".over(\"instance:application_health_check_status\",\"url:http://localhost:5000\").by(\"host\",\"instance\",\"url\").last(2).count_by_status()"
}
