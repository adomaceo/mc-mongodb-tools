#!/bin/sh
set -e

cd /tmp

#
# Function check_mc_configs
#
function check_mc_configs {
    if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "AWS_ACCESS_KEY_ID must be set"
    exit 1
    fi

    if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "AWS_SECRET_ACCESS_KEY must be set"
    exit 1
    fi

    if [ -z "$API_SIGNATURE" ] ; then
        API_SIGNATURE="--api S3v4"
    else
        API_SIGNATURE="--api $API_SIGNATURE"
    fi

    if [ -z "$S3_BUCKET_PATH" ]; then
    echo "S3_BUCKET_PATH must be set"
    exit 1
    fi
}

#
# Function check_mongodb_configs
#
function check_mongodb_configs {
    if [ -z "$MONGO_HOST" ]; then
    # default to a linked container with name "mongo"
    MONGO_HOST="mongo"
    fi

    if [[ "$MONGO_DATABASE" ]]; then
    MONGO_HOST+=" --db $MONGO_DATABASE"
    fi
}

function config_mc {
    mc config host add do "${S3_ENDPOINT:-https://s3.amazonaws.com}" "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" $API_SIGNATURE -q
}

#
# Function restore
#
function restore {
    config_mc && \
    mc stat -q do/$S3_BUCKET_PATH/${FILE:-latest.gz} && \
    mc cp -q do/$S3_BUCKET_PATH/${FILE:-latest.gz} . && \
    mongorestore --gzip --archive=${FILE:-latest.gz} -h $MONGO_HOST
}

#
# Function list files in bucket_path
#
function list {
    config_mc && \
    mc ls -q do/$S3_BUCKET_PATH/
}

case $1 in
    restore)
        check_mc_configs
        check_mongodb_configs
        restore
        ;;
    list | *)
        check_mc_configs
        list
        ;;
esac

#exec "$@"