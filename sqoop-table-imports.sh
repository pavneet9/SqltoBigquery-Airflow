bucket="gs://airflow12"

pwd_file=$bucket/passwords/password.txt

table_name="sales"

target_dir=$bucket/sqoop_output

# Simple table import - Text Format : 

gcloud dataproc jobs submit hadoop \
--cluster=$1 --region=us-central1 \
--class=org.apache.sqoop.Sqoop \
--jars=$bucket/sqoop_jars/sqoop_sqoop-1.4.7.jar,$bucket/sqoop_jars/sqoop_avro-tools-1.8.2.jar,file:///usr/share/java/mysql-connector-java-5.1.42.jar \
-- import \
-Dmapreduce.job.user.classpath.first=true \
-Dmapreduce.output.basename="sales" \
--driver com.mysql.jdbc.Driver \
--connect="jdbc:mysql://localhost:3307/Sales" \
--username=root --password-file=$pwd_file\
--split-by id \
--table $table_name \
-m 4 \
--target-dir $target_dir \
--as-avrodatafile
