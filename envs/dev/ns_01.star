load("lib/deep_merge.star", "deep_merge")
load("envs/dev/dev.star", parent="config")

# Two release candidates have been deployed.
overrides = {
    "foo": {
        "image": {
            "tag": "v0.2.0-rc.0",
        },
    },
    "bar": {
        "image": {
            "tag": "v0.3.0-rc.0",
        },
    },
}

config = deep_merge(parent, overrides)
