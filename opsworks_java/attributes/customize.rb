### 
# Override for the default versions
#
###


# Use Java 8
normal['opsworks_java']['jvm_version'] = '8'
# Tomcat 8 too
normal['opsworks_java']['java_app_server_version'] = '8.0'

# Its not enough to just specify the version above, need to change the pkg name
case node[:platform_family]
when 'debian'
      normal['opsworks_java']['jvm_pkg']['name'] = "openjdk-#{node['opsworks_java']['jvm_version']}-jdk"
when 'rhel'
      normal['opsworks_java']['jvm_pkg']['name'] = "java-1.#{node['opsworks_java']['jvm_version']}.0-openjdk-devel"
end

# Set tomcat base version
normal['opsworks_java']['tomcat']['base_version'] = node['opsworks_java']['java_app_server_version'].to_i

# Set version specific tomcat stuff
unless rhel7?
  normal['opsworks_java']['tomcat']['service_name'] = "tomcat#{node['opsworks_java']['tomcat']['base_version']}"
  normal['opsworks_java']['tomcat']['catalina_base_dir'] = "/etc/tomcat#{node['opsworks_java']['tomcat']['base_version']}"
  normal['opsworks_java']['tomcat']['webapps_base_dir'] = "/var/lib/tomcat#{node['opsworks_java']['tomcat']['base_version']}/webapps"
  normal['opsworks_java']['tomcat']['lib_dir'] = "/usr/share/tomcat#{node['opsworks_java']['tomcat']['base_version']}/lib"

  # The following is common for rhel7 too, but needs change from default only for non-rhel7
  normal['opsworks_java']['tomcat']['context_dir'] = ::File.join(node['opsworks_java']['tomcat']['catalina_base_dir'], 'Catalina', 'localhost')
end

