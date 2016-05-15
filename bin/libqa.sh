#!/bin/bash
LIBQA_HOME=$HOME/libqa
LIBQA_GIT_REPOSITORY=$LIBQA_HOME/git-repository
LIBQA_WAR=$LIBQA_GIT_REPOSITORY/build/libs/ROOT.war
TOMCAT_HOME=/opt/tomcat

usage() { 
  echo Usage: ./libqa.sh \(build \| deploy\)
  exit
}

build() {
  echo "> pulling from github..."
  git --work-tree=$LIBQA_GIT_REPOSITORY --git-dir=$LIBQA_GIT_REPOSITORY/.git pull -q origin master

  echo -e "> completed."
  echo -e "> building source files by gradlew....\n"
  $LIBQA_GIT_REPOSITORY/gradlew -q -b $LIBQA_GIT_REPOSITORY/build.gradle clean build			
  mv $LIBQA_GIT_REPOSITORY/build/libs/*.war $LIBQA_GIT_REPOSITORY/build/libs/ROOT.war

  echo -e "\n> build successfully completed. :)"
}

checkWar() {
  if [ ! -f "${LIBQA_WAR}" ]; then
    echo "cannot found war file. you must be build first. [${LIBQA_WAR}]"
    exit 1
  fi
}

deploy() {
  checkWar
  sudo $TOMCAT_HOME/bin/catalina.sh stop
  sleep 3
  echo "> tomcat stopped."

  echo "> copy war.."
  chmod 644 $LIBQA_WAR
  sudo rm -rf $TOMCAT_HOME/webapps/*
  sudo cp -p $LIBQA_WAR $TOMCAT_HOME/webapps/
  echo "> war file copied successfully."

  sudo $TOMCAT_HOME/bin/catalina.sh start 
}

if [ "$#" -ne 1 ]; then
  usage
fi

"$1"
