function NIFI() {
  NARS=~/git/cognitivescale/triton/components/dataflow/nifi-nar-bundles/
  docker run -itd --name nifi -p 8080 -v ${NARS}:/code nifi:0.3.1 bash
}

function NEO() {
  # What does `--cap-add=SYS_RESOURCE` do?
  # docker run -itdP --name neo c12e/neo4j:2.2.0 bash
  # docker run -p 7474:7474 -d -e NEO4J_AUTH=none neo4j:2.3.1
  docker run -itd --name neo4j -p 7474:7474 -e NEO4J_AUTH=none  tpires/neo4j
}

function MONGO(){
  # docker run -itd --name mongo -P c12e/mongodb bash
  docker run -itd --name mongo -p 27017:27017 mongo bash
}

function INFLUX(){
  docker run -itd -p 8086:8086 --name influx influxdb bash
}

function RUN_INFLUX(){
  # Make sure influx is created
  docker ps -a | grep influx || INFLUX
  # Make sure influx is running
  docker ps -a | grep influx | grep Up || docker start influx
  # Start influx
  docker -it exec influx \
    bash -c "/opt/influxdb/init.sh status | grep Ok || /opt/influxdb/init.sh start"
}

function BUILD_NIFI(){
  docker exec -it nifi bash -c 'cd /code/nifi-pdfreader/ && mvn clean install'
  docker exec -it nifi \
    cp /code/nifi-pdfreader/target/nifi-pdfreader-1.0.0-SNAPSHOT.nar \
       /opt/nifi-0.3.1-SNAPSHOT/lib/
  docker exec -it nifi service nifi restart
}
