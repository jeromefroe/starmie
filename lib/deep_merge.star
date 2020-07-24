def deep_merge(base, *args):
    '''
    deep_merge performs a deep merge of dictionaries. Values in the righter dictionaries take
    precedence over those to the left of them.
    '''

    # Values from a different context are immutable so we need to make a copy of
    # base in order to mutate it.
    copy = dict(base)

    for arg in args:
        for key, value in arg.items():
            if type(value) == "dict":
                copy[key] = deep_merge(copy.get(key, {}), value)
            else:
                copy[key] = value

    return copy
