load("envs/prod/module.star", parent="config")

# This namespace doesn't have any overrides so it outputs its parent unchanged.
config = parent

print(config)
