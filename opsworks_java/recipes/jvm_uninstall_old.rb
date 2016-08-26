###
# New version of Amazon Linux has Java 1.7. It needs to be uninstalled for the default java to be 1.8
#

pkg_name_jav_17 = value_for_platform_family(
  'debian' => '',
  'rhel' => 'java-1.7.0-openjdk'
)

package "Remove openjdk 1.7 #{pkg_name_jav_17}" do
  package_name pkg_name_jav_17
  action :remove
  only_if { node['opsworks_java']['jvm_version'].to_i != 7 }
end
