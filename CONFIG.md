# PROCESO DE CONFIGURACION
Antes de iniciar el entorno con Terraform, procedemos la creacion de la imagen que usaremos en Docker con el Dockerfile.

Para esto, usamos el siguiente comando:
`docker build . -t staticpages:1.0`
Luego de comprobar su creacion con `docker images -a` procedemos a subir la imagen a **Dockerhub**, seria de la siguiente manera:
`docker tag staticpages usuario/staticpages:1.0` --> Etiquetamos la imagen creada
`docker push usuario/staticpages:1.0` --> Subimos la imagen a Dockerhub

Ya hecho esto, procedemos a crear el entorno en AWS con Terraform.
`terraform init` --> Inicializamos terraform
`terraform validate` --> Validacion de los templates

Creacion del entorno.
`terraform plan`
`terraform apply`

Terminado el proceso verificamos en AWS EC2, las instancias, grupo de seguridad y load balancing.

## INICIALIZACION DE EC2
Luego de la creacion de la Instancia de EC2, accedemos al entorno y verificamos que el contenedor de Docker este en funcionamiento, luego verificamos la IP de Elastic Load Balancing para comprobar la pagina web este en funcionamiento.

Ya comprobado esto detenemos las instancias, eliminamos el entorno creado con Terraform.