# Healthcheck config updating
This example demonstrates that adding an [Endpoint health_check_config](https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/endpoint/endpoint.proto.html#envoy-api-msg-endpoint-endpoint-healthcheckconfig) does not take effect until a restart of Envoy.

The example is a "front" Envoy that routes directly to a single backend python server. It uses file-based dynamic xDS (except for route, which is static).

## How to use
### Beginning state
```
$ docker-compose up
```

Verify that healthchecking is succeeding and hitting the backend server:
* The docker-compose logs for the service should show requests to `/status`
* Checking `curl -s localhost:8001/stats | grep health_check` should show health check successes

### Add health_check_config
```
$ docker-compose exec front-envoy /bin/bash -c "/code/eds_update.sh /etc/envoy/endpoints/service1_healthchecking.yaml.tmpl service1"
```

This will write out a new EDS configuration with the health_check_config sending healthchecks to a different port

You can now verify (in the same way as before) that the healthchecks are still hitting the service

### Restart Envoy with new config
Now we want to see Envoy correctly load the config. To do this, we'll start up Envoy with the healthchecking config.

There's a few ways to do this. I simply applied this diff and did a `docker-compose build` and `docker-compose up`

```diff
diff --git a/healthcheck_updates/start_envoy.sh b/healthcheck_updates/start_envoy.sh
index a3fe65f..6839709 100755
--- a/healthcheck_updates/start_envoy.sh
+++ b/healthcheck_updates/start_envoy.sh
@@ -1,5 +1,5 @@
 #!/bin/bash

-/code/eds_update.sh /etc/envoy/endpoints/service1_start.yaml.tmpl service1
+/code/eds_update.sh /etc/envoy/endpoints/service1_healthchecking.yaml.tmpl service1

 /usr/local/bin/envoy -c /etc/envoy/front-envoy.yaml --service-cluster front-proxy
  ```

You should now see healthcheck failures as expected.


Reversing the previous instructions, you'll see that it doesn't pick up the change in the other direction either (removing the `health_check_config`)