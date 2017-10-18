#!/bin/bash
inotifywait -m /opt/deployer/deploy/webapp -e create -e moved_to |
    while read path action file; do
        echo "[`date`] The file '$file' appeared in directory '$path' via '$action'" >> /opt/deployer/logs/webapp.log
        # stop tomcat
        echo "[`date`] stopping tomcat..." >> /opt/deployer/logs/webapp.log
        sudo /usr/sbin/service tomcat stop
        # remove exiting file<.war> and directory with name of this new file
        echo "[`date`] removing exiting file" >> /opt/deployer/logs/webapp.log
        rm -f /opt/tomcat/latest/webapps/$file
        echo "[`date`] removing existing directory" >> /opt/deployer/logs/webapp.log
        rm -rf /opt/tomcat/latest/webapps/${file::-4}
        # move the file
        echo "[`date`] installing new file" >> /opt/deployer/logs/webapp.log
        mv /opt/deployer/deploy/webapp/$file /opt/tomcat/latest/webapps/$file
        # start tomcat
        echo "[`date`] starting tomcat..." >> /opt/deployer/logs/webapp.log
        sudo /usr/sbin/service tomcat start
        echo "[`date`] installation complete." >> /opt/deployer/logs/webapp.log
    done

