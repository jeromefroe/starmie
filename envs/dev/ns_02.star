load("lib/deep_merge.star", "deep_merge")
load("mixins/disable_bar.star", "disable_bar")
load("envs/dev/dev.star", parent="config")

# We've deployed a second release candidate for the "foo" service and disabled the "bar" service.
overrides = {
    "foo": {
        "image": {
            "tag": "v0.2.0-rc.1",
        },
    },
}

config = deep_merge(parent, overrides, disable_bar)
