# DCE - 01 - Loadbalancer

## Přehled
Tento projekt automatizuje nasazení dynamického load balanceru a backendových služeb na OpenNebule pomocí: **Terraform**, **Ansible** a **Docker**

Projekt disponuje těmito funkcemi:
- Load balancer běžící pomocí webového serveru NGINX.
- Backend servery s možností nastavení jejich počtu.
- Plná automatizace nasazení a konfigurace.

## Vlastnosti
- **Škálování**: Měníte počet serverů jedním parametrem v Terraformu.
- **Automatizace** pomocí Terraform a Ansible.
- **Kontejnery** pomocí Dockeru.

## Kroky ke spuštění
1. Klonujte repozitář:
   ```bash
   git clone https://github.com/JakubHomolka/DCE-ukol01.git
   cd DCE-ukol01
   ```

2. Spusťte vývojové prostředí:
    ```bash
    docker-compose up -d
    ``` 

3. Terraform inicializace a aplikace:
    ```bash
    terraform init
    terraform plan
    terraform apply -auto-approve
    ``` 

4. Konfigurujte s Ansible:
    ```bash
    ansible-playbook -i ansible/inventory ansible/playbook.yml
    ```