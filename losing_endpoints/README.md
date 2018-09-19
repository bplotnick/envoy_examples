# Locality strangeness
This is meant to reproduce strange behavior when adding localities and
moving endpoints around.

The behavior that you'll see is that Envoy loses track of an endpoint
when it is moved to a different locality.

## How to use
### Beginning state
```
$ docker-compose up
```

Verify that routing is succeeding and hitting the backend server:
* Curling the endpoint should succeed - `curl localhost:8000/status`
* You should also see the output in the docker-compose logs
* You can also verify that Envoy sees two endpoints with `curl localhost:8001/clusters`

The initial conditions are that two instances of a service (service1\_1
and service1\_2) are equally load balanced.

### Add locality aware routing
```
$ docker-compose exec front-envoy /bin/bash -c "/code/config_update_new.sh"
```

This will write out a new EDS configuration with the locality aware routing config.

Specifically, service1\_2 will get moved into priority 1 and
service1\_1 will stay in priority 0

You can verify that requests are being routed to priority 0 (service1\_1)

```
$ curl localhost:8000/status
```

### What happened to that endpoint?
If we check the Envoy stats endpoint, we see that it does not recognize the second instance anymore - `curl localhost:8001/clusters`. The endpoint has disappeared.

We can further prove this by showing how outlier detection does not failover as it should.

We have configured outlier detection for two 5xx and disabled panic threshold. We can make service1\_1 become unhealthy by triggering 500s from it's `/fail` endpoint.

```
$ curl localhost:8000/fail
$ curl localhost:8000/fail
$ curl localhost:8000/fail  # <--- bad!
```

Our expected behavior is that the third call would fail over to
priority 1 (service1\_2). However, what we see is that it fails.

