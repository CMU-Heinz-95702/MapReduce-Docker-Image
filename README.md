# 95-702 Hadoop course image

This repository owns the Docker image used by the Lab 9 / Project 5 student
repository. It packages Hadoop 3.5.0, the pseudo-distributed configuration,
health checks, and course helper commands.

## Local build

```console
docker build -f docker/Dockerfile -t lab9-hadoop:dev .
```

## Publishing

Pull requests and pushes to `main` build and smoke-test the amd64 image. To
publish a release, create an immutable tag in this form:

```console
git tag image-v3.5.0-course.1
git push origin image-v3.5.0-course.1
```

GitHub Actions publishes `ghcr.io/cmu-heinz-95702/mapreduce-docker-image:3.5.0-course.1`
for both `linux/amd64` and `linux/arm64`. The workflow uses the repository's
built-in `GITHUB_TOKEN`; configure Actions workflow permissions to allow
package writes and make the resulting GHCR package public before students use
it.

Never move or overwrite a released tag. Publish a new `course.N` tag instead.
