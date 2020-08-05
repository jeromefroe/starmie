load("lib/deep_merge.star", "deep_merge")
load("envs/module.star", parent="config")

# In the "dev" cluster, we only have 1 replica per deployment.
overrides = {
    "foo": {
        "replicas": 1,
    },
    "bar": {
        "replicas": 1,
    },
}

config = deep_merge(parent, overrides)
