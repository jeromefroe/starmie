load("lib/deep_merge.star", "deep_merge")
load("mixins/disable_bar.star", "disable_bar")
load("envs/prod/module.star", parent="config")

# We've disabled the "bar" service in this namespace
config = deep_merge(parent, disable_bar)

print(config)
