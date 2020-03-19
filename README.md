mc-mongodb-tools
================

# MinIO Client Mongo DB Tools

This image use [MinIO Client](https://docs.min.io/docs/minio-client-complete-guide.html) and
[mongodb-tools](https://pkgs.alpinelinux.org/contents?branch=edge&name=mongodb-tools&arch=x86&repo=community) and have some uses:

* `list`: List the files in Amazon S3 compatible cloud storage service (AWS Signature v2 and v4) like [Digitalocean Space](https://www.digitalocean.com/docs/spaces/) or [Google Storage](https://cloud.google.com/storage)
* `restore`: Get a mongoDB backup file from Amazon S3 compatible cloud storage service and restore to mongoDB server.

## Usage

```
docker run -d \
  --env AWS_ACCESS_KEY_ID=awsaccesskeyid \
  --env AWS_SECRET_ACCESS_KEY=awssecretaccesskey \
  --env S3_ENDPOINT=https://nyc3.digitaloceanspaces.com
  --env S3_BUCKET_PATH=mybucket/backup \
  --link my_mongo_db:mongo \
  amaceog/mc-mongodb-tools list
```

List the files in the bucket `mybucket` and folder `/backup`.

```
docker run -d \
  --env AWS_ACCESS_KEY_ID=awsaccesskeyid \
  --env AWS_SECRET_ACCESS_KEY=awssecretaccesskey \
  --env S3_ENDPOINT=https://nyc3.digitaloceanspaces.com
  --env S3_BUCKET_PATH=mybucket/backup \
  --link my_mongo_db:mongo \
  amaceog/mc-mongodb-tools restore
```
Restore the `latest.gz` mongoDB backup file in bucket `mybucket` and folder `/backup` to `my_mongo_db` container.

## Environment Variables

This image uses several environment variables and some are required.

### `AWS_ACCESS_KEY_ID`

This environment variable `is required` for you to use this image. This environment variable specifies an AWS access key with permission to Amazon S3 compatible cloud storage service.
### `AWS_SECRET_ACCESS_KEY`

This environment variable `is required` for you to use this image. This environment variable specifies the secret key associated with the access key.
### `API_SIGNATURE`

This environment variable `is optional` for you to use this image. By default, it is set to "S3v4". Valid options are '[S3v4, S3v2]'

### `S3_ENDPOINT`

This environment variable `is required` for you to use this image and specifies MinIO server displays URL.

* By default, it is set to `https://s3.amazonaws.com` for Amazon S3.
* For Google Cloud Storage use: `https://storage.googleapis.com`
* For Digitalocean Space in `nyc3` region use `http://nyc3.digitaloceanspaces.com`

### `S3_BUCKET_PATH`

This environment variable `is required` for you to use this image. This environment variable specifies the bucket name and path.

### `MONGO_HOST`

This environment variable `is required` in restore mode. This environment variable specifies the mongo host. By default, it is set to `mongo`

### `MONGO_DATABASE`

This environment variable `is optional` for you to use this image.
This environment variable specifies the mongoDB database name.

### `FILE`

This environment variable `is optional` for you to use this image.
This environment variable specifies the backup file to restore. By default, it is set to `latest.gz`