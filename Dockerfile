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
