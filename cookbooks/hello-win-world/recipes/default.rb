template "c:/tmp/hello-world.txt" do
  source "hello-file.erb"
  mode "0644"
  action :create
end
