# Ejercicio - Terraform - AWS - Apache - Nginx
Para empezar, cree una vpc, un security group, el gateway, las subnet publicas y privadas y después el Application Load Balancer. Luego, cree una un NAT-Gateway para las instancias de APACHE y NGINX. 
El load balancer corre en las subnet publicas.
Comandos para instalar Apache : 

sudo apt update -y
  sudo apt install apache2 -y

Luego, cree la instancia EC2 donde iba a instalar NGINX y se crearon los recursos de red necesarios.

### Comandos para instalar NGINX 
```sh
      "sudo amazon-linux-extras enable nginx"
      "sudo yum -y install nginx"
      "sudo systemctl start nginx"
```
### Comandos para instalar NGINX 
```sh
"sudo amazon-linux-extras enable nginx1.12",
        "sudo yum -y install nginx",
        "sudo systemctl start nginx",


Se dejaron los puertos 80 y 22 abiertos para la conexion http y ssh  

Hay algunos errores, me gustaría seguir aprendiendo !  y saber algún otro error que seguramente tuve.