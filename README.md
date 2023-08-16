# To Provision a Quick AKS Cluster using the above Script
* Install and configure Terraform - https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure
* Install Kubernetes Command-Line Tool (kubectl) - https://kubernetes.io/releases/download/
* Install Azure Command-Line Interphase - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
* Login to your Azure Portal
  ```bash
  az login
  ```
* Implement the Terraform code
  * Clone this repository and make it the current directory
```bash
git clone https://github.com/DinmaMerciBoi/Terraform_Azure.git
cd Terraform_Azure/AKS
```
  * Review the codes within each file and confirm it suits your use case
  * Edit the codes as necessary before applying
* Initialize Terraform
  You may pass the `-upgrade` parameter to upgrade the necessary provider plugins to the newest version that comlies with the configuration's version constraints.
```bash
terraform init -upgrade
```
* Run the format and validate commands to ensure codes are valid and formatted
```bash
terraform fmt
terraform validate
```
* Create a plan
  You may pass the `-out` parameter to specify an output file. This ensures that the plan you reviewed is exactly what is applied.
```bash
terraform plan -out main.tfplan
```
* Apply the execution plan
  You may pass the `-auto-approve` parameter to apply the plan without requiring your confirmation
  The plan output file `main.tfplan` has been added to instruct Terraform to apply only the plan specified in the file. If you used a different filename, ensure to pass itas specified
  If you didn't pass the `-out` parameter, then call `terraform apply` without any parameters.
```bash
terraform apply main.tfplan -auto-approve
```
* Verify the results
  ### 1. Get the Azure Resource group name
  ```bash
  resource_group_name=$(terraform output -raw resource_group_name)
  ```
  ### 2. Display the name of the new Kubernetes Cluster
  ```bash
  az aks list \
    --resource-group $resource_group_name \
    --query "[].{\"K8s cluster name\":name}" \
    --output table
  ```
  ### 3. Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read.
  The command below fetches the `kubeconfig` and saves it in the current working directory.
  If you desire a different directory, pass it as necessary.
  ```bash
  echo "$(terraform output kube_config)" > ./azurek8s
  ```
  ### 4. Verify the previous command didn't add an ASCII EOT character
  ```bash
  cat ./azurek8s
  ```
  `Note:` If you see `<< EOT` at the beginning and `EOT` at the end, remove these characters from the file. Otherwise, you could receive the following error message: `error: error loading config file "./azurek8s": yaml: line 2: mapping values are not allowed in this context`
  ### 5. Set an environment variable so that kubectl picks up the correct config.
  Run this command from your control node to be able to run `kubectl` commands on your cluster.
  You will also need to run the same command to re-establish connection to your cluster whenever you login to this control node.
  ```bash
  export KUBECONFIG=./azurek8s
  ```
  ### 6. Verify the health of the cluster.
  ```bash
  kubectl get nodes
  ```
  ### 7. Note
  When the AKS cluster was created, monitoring was enabled to capture health metrics for both the cluster nodes and pods. These health metrics are available in the Azure portal.

Your AKS Cluster is ready for your deployments!

# To Provision a Virtual Machine along with Necessary Resources
* Implement the Terraform code
  * Clone this repository and make it the current directory
  ```bash
  git clone https://github.com/DinmaMerciBoi/Terraform_Azure.git
  cd Terraform_Azure/Resources
  ```
  Or
  ```bash
  cd Terraform_Azure/minikube
  ```
  ### Note:
  Both directories contain nearly the same codes. However, there are 2 differences:
  * In `/Resources`, you generate the ssh key using the `ssh-keygen` command, and direct where the file is saved and what it's called. Then, pass the path to the `public key file` in `/Resources/vm.tf` at the `admin_ssh_key` parameter block, and keep the `private key file` as secret.
  * In `/minikube`, the ssh key in the `ssh.tf` is generated using `Azure API`, which provider configuration is already passed in the `terraform { required_providers { azapi = {` block. Then, the `private key` is made to output as a json file, which you can then copy and save as necessary. You can then use this key to ssh into your virtual machine.
  * The second difference is the installation scripts in the different directories, which you can definitely modify to suit your need. 
* Review the codes within each file and confirm it suits your use case
* Edit the codes as necessary before applying
* Then, you can run the Terraform workflow as described above.
* Your virtual machine is set for your use.

# To Provision an Azure Storage for your Terraform Remote Backend
* Implement the Terraform code
  * Clone this repository and make it the current directory
  ```bash
  git clone https://github.com/DinmaMerciBoi/Terraform_Azure.git
  cd Terraform_Azure/Storage
  ```
  * This code in `blob.tf` creates a `Resource Group`, `Storage Account`, and `Storage Container`
  * Review the codes within each file and confirm it suits your use case
  * Edit the codes as necessary before applying
  * Then, you can run the Terraform workflow as described above.
  * Your Azure Storage is set for your use as Terraform Remote Backend, which you can now configure to be used to store your Terraform state files.

## Hope these have been useful to you.

info@merciboi.com
