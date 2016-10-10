package 'java-1.7.0-openjdk-devel'

group 'tomcat'

user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

remote_file 'apache-tomcat-8.5.5.tar.gz' do
  source 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz'
end

directory '/opt/tomcat' do
  group 'tomcat'
  owner 'tomcat'
end

execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

execute 'chown -R tomcat /opt/tomcat'
execute 'chgrp -R tomcat /opt/tomcat'

directory '/opt/tomcat/conf' do
  mode 70
end

execute 'chmod g+r /opt/tomcat/conf/*'

template '/etc/systemd/system/tomcat.service' do 
  source 'tomcat.service.erb'
  not_if do
    File.exist?('/etc/systemd/system/tomcat.service')
  end
end

execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end