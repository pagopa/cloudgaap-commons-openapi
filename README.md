# CloudGaaP Commons OpenAPI

Commons OpenAPI stuff used in all the CloudGaaP subprojects.

## Create a new release

To create a new release use the provided `scripts/release.sh` script.

```sh
release.sh -v patch
```

You must specify a version type using the `-v` flag and choose one of `[major, minor, patch]`.

To test the script in dry mode use the `-d` flag.

You can also call the release script using yarn directly.

```sh
yarn release -v patch
```
