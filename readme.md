# ast

Research repo for Ruby AST work.

## Submodules

| path | upstream |
| --- | --- |
| `prism` | https://github.com/ruby/prism |
| `decode` | https://github.com/socketry/decode |

```sh
git clone --recurse-submodules <this repo>
# or, in an existing clone:
git submodule update --init --recursive
```

## Notebook

`notebooks/ast-research.ipynb` drives both submodules from a Python kernel via subprocesses.
The Jupyter server root is `$HOME`, so the notebook path on the server is
`usb/ast/notebooks/ast-research.ipynb`.
