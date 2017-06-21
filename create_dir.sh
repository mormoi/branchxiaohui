#!/bin/bash
export PATH=/usr/local/hive/bin:/usr/local/hadoop-2.5.1/bin:/usr/local/hadoop-2.5.1/sbin:/usr/local/hbase-1.1.2/bin:/usr/local/jdk1.7.0_67/bin:/usr/local/jdk1.7.0_67/jre/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
mkdir -p /data1/hadoop/journal		
mkdir -p /data2/hadoop/journal		
mkdir -p /data3/hadoop/journal		
mkdir -p /data4/hadoop/journal		
chown hdfs:hdfs /data1/hadoop/journal/		
chown hdfs:hdfs /data2/hadoop/journal/		
chown hdfs:hdfs /data3/hadoop/journal/		
chown hdfs:hdfs /data4/hadoop/journal/		
		
mkdir -p /data1/hadoop/dfs/name		
mkdir -p /data2/hadoop/dfs/name		
mkdir -p /data3/hadoop/dfs/name		
mkdir -p /data4/hadoop/dfs/name		
chown hdfs:hdfs /data1/hadoop/dfs/name		
chown hdfs:hdfs /data2/hadoop/dfs/name		
chown hdfs:hdfs /data3/hadoop/dfs/name		
chown hdfs:hdfs /data4/hadoop/dfs/name		
		
mkdir -p /data1/hadoop/dfs/data		
mkdir -p /data2/hadoop/dfs/data		
mkdir -p /data3/hadoop/dfs/data		
mkdir -p /data4/hadoop/dfs/data		
chown hdfs:hdfs /data1/hadoop/dfs/data		
chown hdfs:hdfs /data2/hadoop/dfs/data		
chown hdfs:hdfs /data3/hadoop/dfs/data		
chown hdfs:hdfs /data4/hadoop/dfs/data		
		
mkdir /data1/hadoop/zookeeper/		
mkdir /data2/hadoop/zookeeper/		
mkdir /data3/hadoop/zookeeper/		
mkdir /data4/hadoop/zookeeper/		
chown hdfs:hdfs /data1/hadoop/zookeeper/		
chown hdfs:hdfs /data2/hadoop/zookeeper/		
chown hdfs:hdfs /data3/hadoop/zookeeper/		
chown hdfs:hdfs /data4/hadoop/zookeeper/		
		
mkdir -p /data1/hadoop/hbase/		
mkdir -p /data2/hadoop/hbase/		
mkdir -p /data3/hadoop/hbase/		
mkdir -p /data4/hadoop/hbase/		
chown -R hdfs:hdfs  /data1/hadoop/hbase		
chown -R hdfs:hdfs  /data2/hadoop/hbase		
chown -R hdfs:hdfs  /data3/hadoop/hbase		
chown -R hdfs:hdfs  /data4/hadoop/hbase		
		
mkdir -p /data1/hadoop/log/yarn		
mkdir -p /data1/hadoop/log/hadoop		
mkdir -p /data1/hadoop/pid/yarn		
mkdir -p /data1/hadoop/pid/hadoop		
mkdir -p /data1/hadoop/metrics		
mkdir -p /data1/hadoop/gclog		
mkdir -p /data1/hadoop/dfs/data		
mkdir -p /data1/hadoop/local		
mkdir -p /data1/hadoop/log/yarn		
mkdir -p /data1/hadoop/socket/		
chown -R hdfs:hdfs /data1/hadoop		
chown -R hdfs:hdfs /data1/hadoop/local		
chown -R hdfs:hdfs /data1/hadoop/pid/yarn		
chown -R hdfs:hdfs /data1/hadoop/log/yarn		
chmod 755 /data1/hadoop/socket/		
chmod 777 /data1/hadoop/gclog		

chown -R hdfs.hdfs /usr/local/hadoop-2.5.1
chown -R hdfs.hdfs /usr/local/hbase-1.1.2

mkdir /var/run/redis
mkdir /var/log/redis
mkdir /data4/redis
chown -R redis.redis /var/run/redis /var/log/redis /data4/redis

python /data3/supervisor-3.2.0/setup.py install
