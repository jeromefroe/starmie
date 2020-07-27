load("envs/prod/prod.star", parent="config")

# This namespace doesn't have any overrides so it outputs its parent unchanged.
config = parent
