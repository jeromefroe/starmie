# In the "dev" cluster, we only have 1 replica per deployment.
output = {
    "foo": {
        "replicas": 1,
    },
    "bar": {
        "replicas": 1,
    },
}
