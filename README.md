# McSQL

Small sidecar container based on minio command line image with mysql-client package to create backup for s3 buckets.

## Usage

```
docker run \
    --env PREFIX=myprefix \
    --env RM_OLDER_THAN=10 \
    --env MYSQL_HOST=mysql \
    --env MYSQL_PASSWORD=password \
    --env S3_HOST= https://... \
    --env S3_KEY= ...\
    --env S3_SECRET= ...\
    --env S3_BUCKET=mybucket/backups/mysql \
    kuhdo/mcsql
```

### Result:

s3:
```
mybucket
└─ backups
   └─ mysql
      └─ myprefix-2021-02-03T21:06:42+0000.gz
```

container:
```
/data
└─ myprefix-2021-02-03T21:06:42+0000.gz
```

## Environment Variables

`PREFIX` (optional) 

String that will be prefixed to name of created file.

`RM_OLDER_THAN` (optional) 

Remove files older than `${days} ${hours} ${minutes}`.

eg: `0 0 2` => older than 2 minutes.

`MYSQL_HOST`

Address of target host

`MYSQL_PORT` (default: 3306)

Port of target host

`MYSQL_USER` (default: root) 

User that connects to the mysql instance. 

`MYSQL_PASSWORD`

Password of connecting user.

`S3_HOST`

Address of s3 endpoint.

`S3_KEY`

Access key of s3.

`S3_SECRET`

Secret Key of s3.

`S3_BUCKET`

Path of s3 bucket.