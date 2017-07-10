bash "chown_mongodb" do
  user 'root'
  code <<-EOH
  chown --recursive mongodb:mongodb /mnt/mongodb/
  EOH
end