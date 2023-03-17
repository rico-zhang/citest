# 这里的$1、$2对应上面传递过来的参数
user_name=$1
image_name=$2
PORT=$3
CONTAINS_PORT=$4
# 如果传入的参数有一个为空，我们就提示他输入参数，然后退出
if [ "$1" == "" ]  || [ "$2" == "" ] || [ "$3" == "" ] || [ "$4" == "" ] ; then 
  echo "请输入参数"
  exit
fi

# 删除容器,就是删除旧的容器
# docker ps -a 获取所有的容器
# ｜ grep ${image_name} 得到这个容器 awk '${print $1}' 根据空格分割，输出第一项
containerId=`docker ps -a | grep ${image_name} | awk '{print $1}'`
if [ "$containerId" != "" ] ; then
# 停止运行
docker stop $containerId
# 删除容器
docker rm $containerId
echo "Delete Container Success"
fi

# 删除镜像
# 获取所有的镜像，得到我们自己构建的镜像的id
imageId=`docker images | grep ${user_name}/${image_name} | awk '{print $3}'`
if [ "$imageId" != "" ] ; then
# 删除镜像
docker rmi -f $imageId
echo "Delete Image Success"
fi
# 登录docker
# docker login -u ricozhang000 -p ==
# 拉取docker上新的镜像
docker pull ${user_name}/${image_name}:latest
# 运行最新的镜像 
# -d 设置容器在后台运行
# -p 表示端口映射，把本机的 92 端口映射到 container 的 80 端口（这样外网就能通过本机的 92 端口访问了
# 如果服务器重启后，我们需要重新启动docker
# 执行 systemctl restart docker 重新启动docker
# 但docker启动了，里面的容器没有启动，所以我们添加--restart=always ，docker启动后，容器也可以启动
# dokcer ps -a 查看所有的容器
docker run -d -p $3:$4 --name $image_name --restart=always ${user_name}/${image_name}:latest
echo "Start Container Successs"
echo "$image_name"
