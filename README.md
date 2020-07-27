# Starmie

A second experiment using [Starlark] for generating configuration files.

To generate the YAML config files from the Starlark files run:

```bash
make gen
```

This command will read the Starlark files for each environment from the `envs` directory and
write the resulting YAML files to the `gen` directory.

## Overview

This repo is an example of how to manage configuration files for different environment using
Starlark to reduce duplication across environments. Following the model of Kubernetes, an
environment is defined as a (cluster, namespace) tuple. An organization then may have multiple
clusters each of which may have multiple namespaces:

```text
┌──────────────────────────────────────────────────────────────────────────┐
│Organization                                                              │
│                                                                          │
│  ┌───────────────────────────┐   ┌───────────────────────────┐           │
│  │Cluster 01                 │   │Cluster 02                 │           │
│  │                           │   │                           │           │
│  │  ┌─────────────────────┐  │   │  ┌─────────────────────┐  │           │
│  │  │                     │  │   │  │                     │  │           │
│  │  │    Namespace 01     │  │   │  │    Namespace 01     │  │           │
│  │  │                     │  │   │  │                     │  │           │
│  │  └─────────────────────┘  │   │  └─────────────────────┘  │           │
│  │  ┌─────────────────────┐  │   │  ┌─────────────────────┐  │   ● ● ●   │
│  │  │                     │  │   │  │                     │  │           │
│  │  │    Namespace 02     │  │   │  │    Namespace 02     │  │           │
│  │  │                     │  │   │  │                     │  │           │
│  │  └─────────────────────┘  │   │  └─────────────────────┘  │           │
│  │            ●              │   │            ●              │           │
│  │            ●              │   │            ●              │           │
│  │            ●              │   │            ●              │           │
│  └───────────────────────────┘   └───────────────────────────┘           │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

To reduce the amount of configuration that needs to be copied from one environment to another,
the configuration for each environment inherits the configuration of its parent environment and can
selectively override part or all of that configuration. For example, a namespace inherits the
configuration for the cluster that it is in so any configuration that is common to all or most
namespaces in a cluster only needs to be defined once in the cluster configuration. Likewise, the
configuration for each cluster inherits the organization's global configuration Only the global
configuration doesn't have a parent. The hierarchy of the `envs` directory reflects the
hierarchy of the environments:

```text
envs
├── global.star      <--- global configuration
├── dev
│   ├── dev.star     <--- cluster configuration
│   ├── ns_01.star   <--- namespace configuration
│   └── ns_02.star   <--- namespace configuration
└── prod
    ├── ns_01.star
    ├── ns_02.star
    └── prod.star
```

The second feature of the Starlark files that allows us to reduce duplication is composition.
Self-contained blocks of configuration to, for instance, enable a feature, can be defined once and
then included in only those environments where the feature should be turned on. Composition is
useful when have common sets of configuration that we want to enable in environments that don't
have a clear hierarchical relationship to one another. For instance, if we wanted to enable the
same feature in the `(dev, ns_02)` and `(prod, ns_01)` environments, then we can define the
configuration to enable the feature in the `mixins` directory and include it in just those
specific environments.

Lastly, since Starlark is a dialect of Python, we can also define helper functions. By convention,
we keep them in the `lib` directory.

## Example Environment

To see how we use inheritance and composition to simplify our configuration in practice, we'll take
a look at the configuration for the `(dev, ns_02)` environment.:

```starlark
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
```

We begin by loading the objects that we'll need from other modules. First we load the `deep_merge`
function from the common library since we'll it later on to merge the environment's parent's
configuration and its overrides. Next, we load the `disable_bar` mixin that disables the bar
service for an environment. And, lastly, we load the environment's parent's configuration.

```starlark
load("lib/deep_merge.star", "deep_merge")
load("mixins/disable_bar.star", "disable_bar")
load("envs/dev/dev.star", parent="config")
```

Next we define the environment's overrides. In this example, we're deploying a release candidate
for the "foo" service.

```starlark
# We've deployed a second release candidate for the "foo" service and disabled the "bar" service.
overrides = {
    "foo": {
        "image": {
            "tag": "v0.2.0-rc.1",
        },
    },
}
```

Lastly, we merge the environment's parent's configuration, its overrides, and the mixin to disable
the bar service to create the configuration for the environment:

```starlark
Next we define the environment's overrides. In this example, we're deploying a release candidate
for the "foo" service.
```

[starlark]: https://github.com/google/starlark-go
