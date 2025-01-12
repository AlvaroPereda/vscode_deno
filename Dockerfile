FROM denoland/deno:2.1.4

WORKDIR /app

# Instalar git, wget y las dependencias de code-server
RUN apt-get update && \
    apt-get install -y git wget curl build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar code-server
RUN wget https://github.com/coder/code-server/releases/download/v4.96.2/code-server-4.96.2-linux-amd64.tar.gz && \
    tar -xzf code-server-4.96.2-linux-amd64.tar.gz && \
    mv code-server-4.96.2-linux-amd64 /usr/lib/code-server && \
    ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server && \
    rm code-server-4.96.2-linux-amd64.tar.gz

# Crear directorio de configuración para extensiones
RUN mkdir -p ~/.local/share/code-server/extensions

# Instalar extensiones de VS Code
RUN code-server --install-extension denoland.vscode-deno && \
    code-server --install-extension GraphQL.vscode-graphql

# Configuración de puerto para code-server
EXPOSE 443

# Puerto que expondrá la aplicación
EXPOSE 4000

# Comando por defecto
CMD ["code-server", "--bind-addr", "0.0.0.0:443", "--auth", "none", "/app"]
