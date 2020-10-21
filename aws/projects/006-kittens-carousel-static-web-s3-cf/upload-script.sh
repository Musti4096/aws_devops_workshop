# set the path based on the first argument
path=$1
bucket_name=$2
# loop through the path and upload the files
aws s3 cp $path s3://"$bucket_name" --recursive