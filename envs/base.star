# This is the base module and serves as the default for all environments.
config = {
    # Configuration for the service "foo".
    "foo": {
        "image": {
            "tag": "v0.1.0",
        },
        "replicas": 2,
    },

    # Configuration for the service "bar".
    "bar": {
        "image": {
            "tag": "v0.2.0",
        },
        "replicas": 3,
    },
}
