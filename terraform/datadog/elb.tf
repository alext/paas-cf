resource "datadog_monitor" "abnormal_api_latency_cc" {
  name    = "${format("%s Abnormal API Latency - CC", var.env)}"
  type    = "query alert"
  message = "${format("{{#is_alert}}We're experiencing >= {{threshold}} change in ELB Latency.{{/is_alert}} \n{{#is_warning}}We're experiencing >= {{warn_threshold}} change in ELB Latency.{{/is_warning}} \n\nVisit the [Team Manual > Responding to alerts > API Latency](%s#api-latency) for more info.", var.datadog_documentation_url)}"

  query = "${format("max(last_1h):avg:aws.elb.latency{name:%s-cf-cc} > 2", var.env)}"

  thresholds {
    warning  = 1
    critical = 2
  }

  require_full_window = true

  tags = ["deployment:${var.env}", "service:${var.env}_monitors", "job:cc"]
}

resource "datadog_monitor" "abnormal_api_latency_doppler" {
  name    = "${format("%s Abnormal API Latency - Doppler", var.env)}"
  type    = "query alert"
  message = "${format("{{#is_alert}}We're experiencing >= {{threshold}} change in ELB Latency.{{/is_alert}} \n{{#is_warning}}We're experiencing >= {{warn_threshold}} change in ELB Latency.{{/is_warning}} \n\nVisit the [Team Manual > Responding to alerts > API Latency](%s#api-latency) for more info.", var.datadog_documentation_url)}"

  query = "${format("avg(last_1h):anomalies(avg:aws.elb.latency{name:%s-cf-doppler}, 'basic', 2, direction='above') > 0.3", var.env)}"

  require_full_window = true

  thresholds {
    warning  = 0.15
    critical = 0.3
  }

  tags = ["deployment:${var.env}", "service:${var.env}_monitors", "job:doppler"]
}

resource "datadog_monitor" "abnormal_api_latency_uaa" {
  name    = "${format("%s Abnormal API Latency - UAA", var.env)}"
  type    = "query alert"
  message = "${format("{{#is_alert}}We're experiencing >= {{threshold}} change in ELB Latency.{{/is_alert}} \n{{#is_warning}}We're experiencing >= {{warn_threshold}} change in ELB Latency.{{/is_warning}} \n\nVisit the [Team Manual > Responding to alerts > API Latency](%s#api-latency) for more info.", var.datadog_documentation_url)}"

  query = "${format("avg(last_1h):anomalies(avg:aws.elb.latency{name:%s-cf-uaa}, 'basic', 2, direction='above') > 0.3", var.env)}"

  require_full_window = true

  thresholds {
    warning  = 0.15
    critical = 0.3
  }

  tags = ["deployment:${var.env}", "service:${var.env}_monitors", "job:uaa"]
}

resource "datadog_monitor" "unhealthy_elb_node" {
  name           = "${format("%s At least one ELB node is not responding", var.env)}"
  type           = "metric alert"
  message        = "${format("Requests to the healthcheck app via {{value}} of the ELB IP addresses failed.\n\nSee [Team Manual > Responding to alerts > Intermittent ELB failures](%s#intermittent-elb-failures) for more info.", var.datadog_documentation_url)}"
  notify_no_data = true

  query = "${format("min(last_1m):max:aws.elb.unhealthy_node_count{deploy_env:%s} > 0", var.env)}"

  require_full_window = true

  thresholds {
    critical = 0
  }

  tags = ["deployment:${var.env}", "service:${var.env}_monitors"]
}
