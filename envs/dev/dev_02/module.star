load("lib/deep_merge.star", "deep_merge")
load("mixins/disable_bar.star", disable_bar="output")

# We've deployed a second release candidate for the "foo" service and disabled the "bar" service.
cfg = {
    "foo": {
        "image": {
            "tag": "v0.2.0-rc.1",
        },
    },
}

output = deep_merge(cfg, disable_bar)
