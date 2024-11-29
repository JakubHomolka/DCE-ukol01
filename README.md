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

## Kroky ke spuštění v příkazové řádce
1. Klonujte repozitář:
   ```bash
   git clone https://github.com/JakubHomolka/DCE-ukol01.git
   cd DCE-ukol01
   ```

2. Spusťte aplikaci Docker Desktop.

3. Spusťte vývojové prostředí, kde necháte buildnout Docker kontejner.

4. Terraform inicializace a aplikace (v terminálu vývojového prostředí nebo příkazové řádce):
    ```bash
    terraform init
    terraform plan
    terraform apply -auto-approve
    ``` 

5. Konfigurujte s Ansible:
    ```bash
    ansible-playbook -i ansible/inventory ansible/playbook.yml
    ```
