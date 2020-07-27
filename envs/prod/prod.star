load("envs/global.star", parent="config")

# The "prod" cluster doesn't have any overrides so it outputs its parent unchanged.
config = parent
