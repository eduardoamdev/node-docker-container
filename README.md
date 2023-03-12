# Node Docker Container

<img src="./images/docker-hub.png" alt="docker hub image" />

## Descripción

En esta práctica, vamos a levantar un sencillo servidor de Express en un docker que vamos a exponer en el puerto 5000 de nuestro equipo.

## El archivo del servidor

El archivo del servidor es muy sencillo. Creamos un servidor de Express, una ruta que devuelva un JSON sencillo y levantamos el sevidor.

```js
const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.json({ message: "It works!!!" });
});

app.listen(3000, () => {
  console.log("Server runing");
});
```

## El Dockerfile

Un archivo Dockerfile es un documento de texto que contiene todos los comandos que un usuario podría ejecutar en la línea de comandos para crear una imagen de docker. El archivo Dockerfile te permite automatizar el proceso de construcción de una imagen de docker, especificando las instrucciones que se deben ejecutar en cada paso.

Nuestro Dockerfile tiene la siguiente composición.

```Dockerfile
# Usa una imagen base de node
FROM node:14

# Crea un directorio para la aplicación
WORKDIR /usr/src/app

# Copia los archivos de dependencias
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Ejecuta el servidor de node
CMD [ "node", "app.js" ]
```

## Generación de la imágen

Vamos a generar una nueva imágen llamada node-server. Para ello, nos ubicaremos en el directorio en el que se encuentra nuestro Dockerfile y ejecutaremso el comando

```sh
docker build -t node-server .
```

## Arranque del docker

Arrancamos el contenerdor indicando que queremos que el nombre sea node-container, que exponga el puerto 3000 del docker en el 5000 de nuesta máquina, que se ejecute en segundo plano con el comando -d y que trabaje a partir de la imágen llamada node-server.

```sh
docker run --name node-container -p 5000:3000 -d node-server
```

Ahora ya lo tenemos listo para llamar a localhost:5000 y recibir la respuesta que nos proporciona nuestro end point.

## Trabajar dentro del docker

Si quisiéramos trabajar directamente dentro del contenedor node-container ya arrancado ejecutaríamos el comando

```sh
docker exec -it node-container bash
```

Esto nos daría acceso al contenedor y nos permitiría recorrer los directorios consultar el contenido de los mismos y abrir los archivos para revisar su contenido.

## Modificar un archivo del docker

Vamos a ponernos en el caso de que queremos modificar el archivo app.js que se encuentra dentro de la carpeta /usr/src/app del contenedor node-container.

Como no tenemos un editor de texto instalado dentro de nuestro contenedor debemos copiar el archivo que queremos modificar fuera del docker. Para ello, desde fuera del contenedor, ejecutamos el siguiente comando:

```sh
docker cp node-container:/usr/src/app/app.js .
```

Este comando copiará el archivo app.js en el directorio en el que nos encontremos ubicados dentro de nuestro sistema operativo.

Una vez lo tengamos ahí, lo modificaremos con el editor de texto de nuestra preferencia.

Cuando hayamos editado el archivo app.js lo actualizaremos en el docker con el comando:

```sh
docker cp app.js node-container:/usr/src/app/app.js
```

Si echamos abajo el contenedor (en el caso de que esté levantado) cuando lo volvamos a arrancar ya estará funcionando con nuestro código actualizado.
