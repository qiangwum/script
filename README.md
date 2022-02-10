# 这里放的是k8s部署的一些脚本~
## 常用的一些命名和介绍：
<font color="#00FFFF">深紫色文字</font><br /> 
1. kubectl run  --image=nginx nginx -o yaml --dry-run=client > nginx.yaml  使用命令生成yaml
2. kubectl get pod busybox -o yaml 同上
3. kubectl explain pod.spec.affinity   命令忘记了查询
4. kubectl get pod -l run=nginx     使用label过滤pod，查询或者删除
5. kubectl label pod/node nginx wq=qiang    给已经创建好的pod打label ，也可以给node打标签（搭配nodeSeletor使用）
6. kubectl get pod --show-labels   查询标签
7. kubectl taint NODE k8s-node01 checknode=node:NoSchedule  给你某个节点设置taint   
8. kubectl taint nodes node1 key1=value1:NoSchedule-        取消节点的taint
9. kubectl expose pod nginx --name nginxservice --port 8888 --target-port 80   用pod创建service
