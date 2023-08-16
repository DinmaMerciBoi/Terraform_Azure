# To Provision a Quick AKS Cluster using the above Script
* Install and configure Terraform - https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure
* Install Kubernetes Command-Line Tool (kubectl) - https://kubernetes.io/releases/download/
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








