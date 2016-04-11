alias NIFI='docker run -it -v /Users/oeid/bitbucket/cognitivescale/triton/components/dataflow/nifi-nar-bundles/:/code -p 8080 --name nifi nifi:0.3.1 bash'

alias NEO='docker run -d --p 7474:7474 --env=NEO4J_AUTH=none neo4j:2.3.1'
# alias NEO='docker run -itdP --name neo c12e/neo4j:2.2.0 bash'
# alias NEO='docker run -i -t -d -e NEO4J_AUTH=none --name neo4j --cap-add=SYS_RESOURCE -p 7474:7474 tpires/neo4j'

alias MONGO='docker run -itd -p 27017:27017 --name mongo mongo bash'
# alias MONGO='docker run -itdP --name mongo c12e/mongodb bash'

alias INFLUX='docker run -itd -p 8086:8086 --name influx influxdb bash'

function RUN_INFLUX(){
  # Make sure influx is created:
  docker ps -a | grep influx || INFLUX
  # Make sure influx is running
  docker ps -a | grep influx | grep Up || docker start influx
  # Start influx
  docker exec influx bash -c "/opt/influxdb/init.sh status | grep Ok || /opt/influxdb/init.sh start"
}

function BUILD_NIFI(){
  docker exec nifi bash -c 'cd /code/nifi-pdfreader/ && mvn clean install'
  sleep 15
  docker exec nifi cp /code/nifi-pdfreader/target/nifi-pdfreader-1.0.0-SNAPSHOT.nar /opt/nifi-0.3.1-SNAPSHOT/lib/
  sleep 1
  docker exec nifi service nifi restart
}
