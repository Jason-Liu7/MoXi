az --help #


az group create -n zhihutest -l southeastasia

az gourp list # 检查已有的资源组


az vm create --resource-group zhihutest --name myVMUbuntu --image UbuntuLTS --admin-username azureuser --admin-password 123456TestVM

az group delete --name zhihutest --yes


#list多个条件
az group list | grep -E "name|location"


VM资源创建
az vm create
https://docs.microsoft.com/zh-cn/cli/azure/vm?view=azure-cli-latest#az_vm_create


-n MyVm -g MyResourceGroup

--zone 1
--image  Win2012R2Datacenter
--custom-data MyCloudInitScript.yml

可以对映像进行分布查找:
az vm image list-publishers --location SoutheastAsia --output table


az vm list --location southeastasia --all



az vm image list-skus --location SoutheastAsia --publisher Canonical --offer UbuntuServer --output table


 az vm image list-offers --location westus --publisher MicrosoftWindowsServer --output table


az vm create \
    --resource-group ACN-INFRA-PROD-RG \
    --name myVM \
    --image Win2019Datacenter \
    --admin-username azureuser \
	--admin-password 'ComplexPassword' \
	--size 'Standard_B1ms' \
	
	
az vm create  --name 'dWeb02-vm' --resource-group 'dev-rg' --admin-password 'ComplexPassword' --admin-username 'dwebadm' 
--availability-set 'dev-as' --image 'Win2016Datacenter' --location 'northeurope' --nics 'dev-nic' --size 'Standard_B1ms' 
--os-disk-size-gb '32' --storage-sku 'StandardSSD_LRS'


az vm create  --resource-group ACN-INFRA-PROD-RG --name myVM --image Win2019Datacenter --admin-username azureuser --admin-password 'Complex@Password' --size 'Standard_B1ms'
-AsJob 参数以后台任务的方式创建 VM，因此 PowerShell 提示符会返回到你所在的位置。 可以通过 Get-Job cmdlet 查看后台作业的详细信息。

要创建的虚拟机数。 值范围为 [2，250] 
--count


了解 VM 大小
https://docs.microsoft.com/zh-cn/azure/virtual-machines/windows/tutorial-manage-vm#understand-vm-sizes

静态分配
使用 az vm create 命令创建虚拟机时，包含 --public-ip-address-allocation static 参数可以分配静态公共 IP 地址。 
本教程不会演示此操作，但是，下一部分介绍了如何将动态分配的 IP 地址更改为静态分配的地址。


无公共 IP 地址
通常，不需要通过 Internet 访问 VM。 若要创建一个不带公共 IP 地址的 VM，请使用 --public-ip-address "" 参数和一组空双引号。 本教程稍后将演示此配置


----------------了解市场映像------------------------
Get-AzVMImageSku -Location eastus -PublisherName MicrosoftWindowsServer -Offer WindowsServer
az vm image list --publisher Canonical --sku gen2 --output table --all
az vm image list --all --output table

UbuntuLTS
------------------创建VM服务器--------------------------------------------------------
az vm create `
--name myVM8 `
--image "MicrosoftWindowsServer:WindowsServer:2019-datacenter-gs:latest" `
--resource-group ACN-INFRA-PROD-RG `
--data-disk-sizes-gb 30 `
--admin-username azureuser `
--admin-password 'Complex@Password' `
--size 'Standard_B1s' `
--storage-sku 'StandardSSD_LRS' `
--vnet-name "ACN-Infra-Prod-Vnet" `
--subnet "default" `
--public-ip-address '""' `
--nsg "ACN-INFRA-PROD-NSG" `
--zone 1
--------------END----------------------------------------------------------------------------


az vm image list-offers --location SoutheastAsia --publisher Canonical --output table
MicrosoftWindowsServer:WindowsServer:2019-datacenter-core-g2：latest

查找
az vm image list --offer windowsserver --sku 2019-datacenter-core-g2 --all --output table |more
 
 MicrosoftWindowsServer:WindowsServer:2019-datacenter-gs
 
-------------------------创建资源组 -------------------------
$rg “myresourcegroup”
az group create --location eastus --resource-group $rg
az group list --output table
az group show --name $rg --output table
az group delete --name $rg --output table

 -----------------------END-----------------------------------
 
 -------------------------创建资源组 -------------------------
 
-------------------------nsg管理 -------------------------
 
eastus
ACN-Infra-Prod-RG

#list NSG
az network nsg list --output table
#List Rule
az network nsg rule list  --resource-group ACN-Infra-Prod-RG  --nsg-name ACN-INFRA-PROD-NSG --output table
	
#创建NSG的rule	
az network nsg rule create `
--resource-group ACN-Infra-Prod-RG `
--nsg-name ACN-INFRA-PROD-NSG `
--name http7890 `
--access allow `
--protocol Tcp `
--direction Inbound `
--priority 202 `
--source-address-prefix "*" `
--source-port-range "*" `
--destination-address-prefix "*" `
--destination-port-range 78 90

az network nsg rule create `
--resource-group ACN-Infra-Prod-RG `
--nsg-name ACN-INFRA-PROD-NSG `
--name http `
--access allow `
--protocol Tcp `
--direction Inbound `
--priority 201 `
--source-address-prefix "*" `
--source-port-range "*" `
--destination-address-prefix "*" `
--destination-port-range 78

----------------------END-----------------------------

https://www.cnblogs.com/zangdalei/p/7845270.html


---------------创建VNET和子网-----------------------------
az network vnet create `
--resource-group myResourceGroup `
--name myVnet --address-prefix 10.0.0.0/16 `
--subnet-name mySubnetFrontEnd `
--subnet-prefix 10.0.1.0/24

创建子网
az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd1 `
--address-prefix 192.168.0.0/24

az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd2 `
--address-prefix 192.168.1.0/24

az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd3 `
--address-prefix 192.168.2.0/24

az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd4 `
--address-prefix 192.168.3.0/24

az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd5 `
--address-prefix 192.168.4.0/24

az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd6 `
--address-prefix 192.168.5.0/24

az network vnet subnet create `
--resource-group ACN-Infra-Prod-RG `
--vnet-name ACN-Infra-Prod-Vnet1 `
--name mySubnetBackEnd7 `
--address-prefix 192.168.6.0/24 `
--output table

----------------------END-----------------------------
---------------删除子网-----------------------------
az network vnet subnet delete -g ACN-Infra-Prod-RG -n mySubnetBackEnd3

az network vnet subnet list  --resource-group ACN-Infra-Prod-RG  --vnet-name ACN-Infra-Prod-Vnet1 --output table

---------------更新子网NSG配置-----------------------------
az network vnet subnet update `
--resource-group ACN-Infra-Prod-RG `
--name mySubnetBackEnd4 `
--vnet-name ACN-Infra-Prod-Vnet1 `
--network-security-group ACN-INFRA-PROD-NSG `
--output table
----------------------END-----------------------------
