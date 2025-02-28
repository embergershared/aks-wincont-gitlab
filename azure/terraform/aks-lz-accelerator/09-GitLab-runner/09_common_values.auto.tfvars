# 09_common_values.auto.tfvars

location = "eastus2"
base_tags = {
  Repo = "embergershared/aks-wincont-gitlab"
}

rgHubName  = "rg-use2-391575-s3-akswincont-avm-hub"
rgLzName   = "rg-use2-391575-s3-akswincont-avm-lz"
vnetLzName = "vnet-lz"

acrName = "acrakslzaccel234"
akvName = "kvakslzaccel234"
aksName = "aks-lz-linz"

storage_account_name           = "st391575s3hwwpoc"
storage_account_fileshare_name = "poc-data"
