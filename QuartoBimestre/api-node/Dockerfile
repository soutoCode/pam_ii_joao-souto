# Imagem base
FROM node:20-alpine

# Diretório de trabalho 
WORKDIR /usr/src/app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia todo o código
COPY . .

# Expõe a porta da API
EXPOSE 3000

# Comando de start
CMD ["npm", "start"]
