export CATALINA_HOME='/usr/share/tomcat'
export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home
export MAVEN_HOME='/usr/share/maven'
export ANT_HOME='/usr/share/ant'

export PATH=$PATH:${MAVEN_HOME}/bin:${ANT_HOME}/bin:/usr/local/mysql/bin

export cl='/Users/ome/Projects/ccl'
export git="$cl/git"
export phoenix="$git/phoenix_240"

export cljenkins='/Users/ome/.m2/repository/com/connectloud'
export deployments='/usr/share/jboss/standalone/deployments/'

export PS1='\u \W >_< '
export PS1='\u \W >: '

export mampui='/Applications/MAMP/htdocs/ext-4.2.1.883/ui'

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/include:/tmp/clencrypt

export default_version='2.4.0'
export cl_home="/usr/share/.cl"
export controller_jar_dir="$cl_home/lib"

alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias install-apk='/Applications/BlueStacks.app/Contents/Runtime/uHD-Adb install'
alias myecho='echo $1 $2'

# ------------------------- Docker Stuff ---------------------------------------
alias setdockerhost='export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2376'

export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/ome/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

natboot2docker () {
	VBoxManage controlvm boot2docker-vm natpf1 "$1,tcp,127.0.0.1,$2,,$3" && ( echo -e "$1 $2 $3" >> /tmp/docker-containers )
}

removeDockerNat() {
	VBoxManage modifyvm boot2docker-vm --natpf1 delete $1;
}
# -----------------------------------------------------------------------------


function cssh() { 
	ssh cl@control01.connectloud.com
}

function getIpFromEth(){
	ifconfig $1 2>/dev/null | grep -o "inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"
}

function current_ip(){
	getIpFromEth utun1 || getIpFromEth utun2 || getIpFromEth utun0 ||getIpFromEth en0 || getIpFromEth en8 
}

function changesvcip() { 
	cfgdir=/usr/share/jboss/standalone/configuration
	/bin/mv -f $cfgdir/standalone.xml $cfgdir/standalone.xml.bk.`/bin/date "+%R-%m.%d.%y"` 
	/usr/bin/sed "s/REPLACE_ME_IP_ADDRESS/$1/" $cfgdir/standalone.xml.template > $cfgdir/standalone.xml ;
}


function config() {

	case $1 in
	  jboss)
		case $2 in
		  ip)
			changesvcip `current_ip`
		  ;;
	  	  *)
			echo 'Invalid input: ' $2
		  ;;
		esac
	  ;;
	  etl)
		case $2 in
		  ip)
			changesvcip `current_ip`
		  ;;
	  	  *)
			echo 'Invalid input: ' $2
		  ;;
		esac
	  ;;
	  mysql)
		case $2 in
		  callback)
			echo "UPDATE Connectloud.cl_configuration set value = 'http://`current_ip`:8080/api/admin/Update' where name = 'DevControllerCallback'" | mysql -uroot
		  ;;
		  queue)  
			case $3 in
			  local)
				QUEUE='Omar_DC1_7b1dfcea-7aae-4517-9905-1a4a637fa226'
			  ;;
			  dev)
				QUEUE='GEO_DC1_7b1dfcea-7aae-4517-9905-1a4a637fa226'
			  ;;
			  qa)
				QUEUE='Dollar_DC East_f6745efe-f916-4a15-bc9c-2e0f46db3a27'
			  ;;
		  	  *)
				QUEUE=$3
			  ;;
			esac
			echo "UPDATE Connectloud.tenant_queue set queue_name = '$QUEUE'" | mysql -uroot
		  ;;
		  log)
			echo "UPDATE Connectloud.cl_configuration set value = '$3' where name = 'JBPM.Job.Flag'" | mysql -uroot
		  ;;
		  env)
			echo "UPDATE Connectloud.cl_configuration set value = '$3' where name = 'env'" | mysql -uroot;
		  ;;
	  	  *)
			echo 'Invalid input: ' $2
		  ;;
		esac
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}


function fetch() {

	case $1 in
	  mysql)
		scp root@${2}sql01:/tmp/latestdump.sql ~/Desktop/
		deploy mysql ~/Desktop/latestdump.sql
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}

function remotedeploy() {
 	
	case $2 in
	  [0-9].*)
		echo 'Using supplied version: ' $2
		version=$2
	  ;;
  	  *)
		echo 'Using default version: ' $default_version
		version=$default_version
	  ;;
	esac

	case $1 in
	  devcontroller)
		scp ~/.m2/repository/com/connectloud/Enterprise/XENControllerV62/$version/XENControllerV62-$version-jar-with-dependencies.jar root@dev-geo-controller-01:/usr/share/.cl/lib/
		scp ~/.m2/repository/com/connectloud/Enterprise/tElasticController/$version/tElasticController-$version-jar-with-dependencies.jar root@dev-geo-controller-01:/usr/share/.cl/lib/
	  ;;
	  qacontroller)
		scp ~/.m2/repository/com/connectloud/Enterprise/XENControllerV62/$version/XENControllerV62-$version-jar-with-dependencies.jar root@qa-bonefish-controller-01:/usr/share/.cl/lib/
		scp ~/.m2/repository/com/connectloud/Enterprise/tElasticController/$version/tElasticController-$version-jar-with-dependencies.jar root@qa-bonefish-controller-01:/usr/share/.cl/lib/
		scp ~/.m2/repository/com/connectloud/Enterprise/LdapController/$version/LdapController-$version-jar-with-dependencies.jar root@qa-bonefish-controller-01:/usr/share/.cl/lib/

#		scp ~/.m2/repository/com/connectloud/Enterprise/XENControllerV62/$version/XENControllerV62-$version-jar-with-dependencies.jar root@qa-bonefish-controller-02:/usr/share/.cl/lib/
#		scp ~/.m2/repository/com/connectloud/Enterprise/tElasticController/$version/tElasticController-$version-jar-with-dependencies.jar root@qa-bonefish-controller-02:/usr/share/.cl/lib/
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}


function deploy() {
 	
	case $2 in
	  [0-9].*)
		echo 'Using supplied version: ' $2
		version=$2
	  ;;
  	  *)
		echo 'Using default version: ' $default_version
		version=$default_version
	  ;;
	esac

	case $1 in
	  jboss)
		stop jboss
		ip=`current_ip | tr -d '\n'`; sudo sed -i .bak "s/^.*current-ip.*/$ip  current-ip/g" /etc/hosts
#		mvn --file=$phoenix/uplatform/pom.xml clean install
		sleep 2
		rm -f $deployments/*.war*
		cp /Users/ome/.m2/repository/com/connectloud/RestAPI/$version/RestAPI-$version.war $deployments
		config jboss ip
		config mysql callback
		start jboss
	  ;;
	  etl)
		stop jboss
		rm -f $deployments/*.war*
		cp /Users/ome/.m2/repository/com/connectloud/etl/ETLAPI/2.2.0/ETLAPI-2.2.0.war $deployments
		config etl ip
		start jboss
	  ;;
	  controller)
		stop controller
		mvn --file=$phoenix/ent/pom.xml clean install
		rm -f $controller_jar_dir/*.jar*
		deploy jar_for_controller $version tElasticController
		deploy jar_for_controller $version LdapController
		deploy jar_for_controller $version XENControllerV62
		deploy jar_for_controller $version VMWareControllerV55
		start controller
	  ;;
	  jar_for_controller)
		jar_name=$3
		cp /Users/ome/.m2/repository/com/connectloud/Enterprise/${jar_name}/${version}/${jar_name}-${version}-jar-with-dependencies.jar $controller_jar_dir
	  ;;
	  mysql)
		stop mysql
		start mysql
		test -f $2 || ( echo "Failed to find file $2" && exit 1 )
		echo 'drop database Connectloud;' | mysql -uroot
		echo 'create database Connectloud;' | mysql -uroot
		cat $2 | sed 's/ndbcluster/MyISAM/g' > /tmp/latestsql.sql
		mysql -uroot Connectloud < /tmp/latestsql.sql
		config mysql callback 
		config mysql env 'dev'
		config mysql log '2'
		config mysql queue local
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}


function update() {

	case $1 in
	  docker)
		boot2docker stop
		boot2docker download
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}


function stop() {

	case $1 in
	  docker)
		boot2docker stop
		cat /tmp/docker-containers 2>/dev/null | xargs echo Removing
		cat /tmp/docker-containers 2>/dev/null | cut -f1 | xargs -I {} VBoxManage modifyvm boot2docker-vm --natpf1 delete {} && rm /tmp/docker-containers
	  ;;
	  jboss)
		ps -aef | grep jboss | grep -v grep | awk "{print \$2}" | xargs -I {} kill -15 {}
	  ;;
	  controller)
		ps -aef | grep tElasticController | grep -v grep | awk "{print \$2}" | xargs -I {} kill -15 {}
	  ;;
	  mysql)
		sudo /usr/local/mysql/support-files/mysql.server stop
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}

function start() {

	case $1 in
	  docker)
		boot2docker start
		setdockerhost
	  ;;
	  jboss)
		/usr/share/jboss/bin/standalone.sh 1>/dev/null 2>/dev/null &
	  ;;
	  controller)
		jars=`ls $controller_jar_dir/*.jar | xargs -I {} echo -n {}: | sed 's/:$//g'`
		stdout=$cl_home/logs/console.log
		stderr=$cl_home/logs/error.log
		java -cp $jars com.connectloud.ent.telasticcontroller.TElasticController 1>$stdout 2>$stderr &
	  ;;
	  mysql)
		sudo /usr/local/mysql/support-files/mysql.server start
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}

function restart() {

	case $1 in
	  jboss)
		stop jboss
		start jboss
	  ;;
	  controller)
		stop controller
		start controller
	  ;;
	  mysql)
		stop mysql
		start mysql
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}

function status() {

	case $1 in
	  docker)
		boot2docker status
	  ;;
	  jboss)
		ps -aef | grep jboss | grep -v grep || echo JBOSS not running
	  ;;
	  controller)
		ps -aef | grep tElasticController| grep -v grep || echo tElasticController not running
	  ;;
	  mysql)
		sudo /usr/local/mysql/support-files/mysql.server status
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}

function log() {

	case $1 in
	  jboss)
		tail -f /usr/share/jboss/standalone/log/server.log
	  ;;
	  controller)
		tail -f $cl_home/logs/rootLogger.log
	  ;;
  	  *)
		echo 'Invalid input: ' $1
	  ;;
	esac

}


