load("lib/deep_merge.star", "deep_merge")
load("envs/module.star", base="output")
load("envs/{{ .Env.CLUSTER }}/module.star", cluster="output")
load("envs/{{ .Env.CLUSTER }}/{{ .Env.NAMESPACE }}/module.star", namespace="output")

config = deep_merge(base, cluster, namespace)

print(config)
