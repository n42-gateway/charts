# N42 Gateway Charts

This is the home of N42 Gateway Charts for [Helm](https://helm.sh) package manager.

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/n42-gateway)](https://artifacthub.io/packages/search?repo=n42-gateway)

Add N42 Gateway as a new repository:

```console
$ helm repo add n42 https://n42-gateway.github.io/charts
```

List current charts:

```console
## Latest version
$ helm search repo n42

## All stable versions
$ helm search repo n42 -l

## All stable and non stable versions
$ helm search repo n42 -l --devel
```

See installation options in the chart directory:

* [N42 Gateway](/n42-gateway)
