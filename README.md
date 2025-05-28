# Taller de Pipelines y Contenerización con GitHub Actions

Este taller te guiará a través de la implementación de pipelines de CI/CD usando GitHub Actions para desplegar y gestionar una base de datos PostgreSQL en una instancia EC2 de AWS.

## 📋 Tabla de Contenidos

- [Descripción del Taller](#descripción-del-taller)
- [Prerrequisitos](#prerrequisitos)
- [Configuración de Secrets](#configuración-de-secrets)
- [Parte 1: Despliegue de PostgreSQL](#parte-1-despliegue-de-postgresql)
- [Parte 2: Carga de Datos SQL](#parte-2-carga-de-datos-sql)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Uso de los Workflows](#uso-de-los-workflows)
- [Troubleshooting](#troubleshooting)

## 🎯 Descripción del Taller

El taller se divide en dos partes principales:

### Parte 1: Despliegue Automatizado de PostgreSQL en EC2
- Pipeline que se activa manualmente
- Conexión SSH a instancia EC2
- Despliegue de contenedor PostgreSQL usando Docker
- Configuración de variables de entorno y exposición de puertos

### Parte 2: Carga de Datos desde Archivos SQL
- Pipeline que se activa manualmente o por push a main
- Copia de archivos SQL al contenedor PostgreSQL
- Ejecución de scripts SQL para crear esquemas e insertar datos
- Verificación de la carga de datos

## 🔧 Prerrequisitos

### Instancia EC2
Tu instancia EC2 debe tener:

1. **Docker instalado y funcionando**:
   ```bash
   # Instalar Docker en Amazon Linux 2
   sudo yum update -y
   sudo yum install -y docker
   sudo service docker start
   sudo usermod -a -G docker ec2-user
   
   # Verificar instalación
   docker --version
   ```

2. **Acceso SSH configurado**:
   - Par de claves SSH generado
   - Puerto 22 abierto en el Security Group
   - Usuario con permisos para ejecutar Docker

3. **Puertos abiertos en Security Group**:
   - Puerto 22 (SSH)
   - Puerto 5432 (PostgreSQL) - opcional, solo si necesitas acceso externo

### Repositorio GitHub
- Repositorio con los workflows y archivos SQL
- Permisos para configurar secrets
- Actions habilitadas

## 🔐 Configuración de Secrets

Ve a tu repositorio GitHub → Settings → Secrets and variables → Actions → New repository secret

Configura los siguientes secrets:

| Secret | Descripción | Ejemplo |
|--------|-------------|---------|
| `EC2_HOST` | Dirección IP pública o DNS de tu instancia EC2 | `ec2-xx-xx-xx-xx.compute-1.amazonaws.com` |
| `EC2_USER` | Usuario para conexión SSH | `ec2-user` (Amazon Linux) o `ubuntu` (Ubuntu) |
| `EC2_SSH_KEY` | Clave privada SSH (contenido completo del archivo .pem) | `-----BEGIN RSA PRIVATE KEY-----\n...` |
| `POSTGRES_USER` | Usuario de PostgreSQL | `postgres` |
| `POSTGRES_PASSWORD` | Contraseña de PostgreSQL | `mi_password_seguro` |
| `POSTGRES_DB` | Nombre de la base de datos | `taller_db` |

### ⚠️ Importante para EC2_SSH_KEY
- Copia todo el contenido del archivo `.pem` incluyendo las líneas BEGIN y END
- Asegúrate de que no haya espacios extra al inicio o final
- El formato debe ser exactamente como está en el archivo

## 🚀 Parte 1: Despliegue de PostgreSQL

### Archivo: `.github/workflows/deploy-postgresql.yml`

Este workflow:
1. Se conecta a la instancia EC2 via SSH
2. Detiene y elimina cualquier contenedor PostgreSQL existente
3. Ejecuta un nuevo contenedor PostgreSQL con la configuración especificada
4. Verifica que el contenedor esté funcionando correctamente

### Comando Docker ejecutado:
```bash
docker run -d \
  --name postgresql-dev \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -p 5432:5432 \
  postgres:15
```

## 📊 Parte 2: Carga de Datos SQL

### Archivo: `.github/workflows/load-sql-data.yml`

Este workflow:
1. Verifica que el contenedor PostgreSQL esté ejecutándose
2. Copia archivos SQL del repositorio a la instancia EC2
3. Transfiere los archivos al contenedor PostgreSQL
4. Ejecuta los scripts SQL en orden
5. Verifica que los datos se hayan cargado correctamente

### Archivos SQL incluidos:

#### `sql/schema.sql`
- Crea las tablas: `estudiantes`, `cursos`, `inscripciones`
- Define índices para optimización
- Crea una vista para consultas frecuentes
- Incluye comentarios y documentación

#### `sql/data.sql`
- Inserta datos de ejemplo en todas las tablas
- 10 estudiantes con diferentes notas
- 8 cursos con códigos únicos
- Múltiples inscripciones con diferentes estados

## 📁 Estructura del Proyecto

```
taller2/
├── .github/
│   └── workflows/
│       ├── deploy-postgresql.yml    # Parte 1: Despliegue de PostgreSQL
│       └── load-sql-data.yml        # Parte 2: Carga de datos SQL
├── sql/
│   ├── schema.sql                   # Estructura de la base de datos
│   └── data.sql                     # Datos de ejemplo
└── README.md                        # Esta documentación
```

## 🎮 Uso de los Workflows

### 1. Ejecutar Despliegue de PostgreSQL
1. Ve a tu repositorio en GitHub
2. Click en "Actions"
3. Selecciona "Deploy PostgreSQL to EC2"
4. Click en "Run workflow"
5. Selecciona el environment (dev/staging)
6. Click en "Run workflow"

### 2. Cargar Datos SQL
1. Ve a "Actions" en tu repositorio
2. Selecciona "Load SQL Data to PostgreSQL"
3. Click en "Run workflow"
4. Selecciona qué archivos ejecutar:
   - `schema`: Solo estructura de tablas
   - `data`: Solo datos
   - `all`: Ambos (recomendado)
5. Click en "Run workflow"

### 3. Activación Automática
El workflow de carga de datos también se ejecuta automáticamente cuando:
- Haces push a la rama `main`
- Modificas archivos en la carpeta `sql/`

## 🔍 Verificación Manual

Puedes conectarte a tu instancia EC2 y verificar manualmente:

```bash
# Conectar a EC2
ssh -i tu-clave.pem ec2-user@tu-instancia-ec2.amazonaws.com

# Verificar contenedor
docker ps | grep postgresql-dev

# Conectar a PostgreSQL
docker exec -it postgresql-dev psql -U postgres -d taller_db

# Consultas de ejemplo
\dt                                    # Listar tablas
SELECT * FROM estudiantes LIMIT 5;    # Ver estudiantes
SELECT * FROM vista_estudiantes_activos; # Ver vista
```

## 🛠️ Troubleshooting

### Error: "PostgreSQL container is not running"
- Ejecuta primero el workflow "Deploy PostgreSQL to EC2"
- Verifica que Docker esté funcionando en EC2: `sudo service docker status`

### Error de conexión SSH
- Verifica que `EC2_HOST` sea correcto
- Confirma que `EC2_SSH_KEY` tenga el formato correcto
- Asegúrate de que el Security Group permita SSH (puerto 22)

### Error de permisos Docker
- El usuario debe estar en el grupo docker: `sudo usermod -a -G docker $USER`
- Reinicia la sesión SSH después de agregar al grupo

### Archivos SQL no encontrados
- Verifica que los archivos estén en la carpeta `sql/`
- Confirma que los nombres sean exactamente `schema.sql` y `data.sql`

### Error de conexión a PostgreSQL
- Espera unos segundos después del despliegue
- Verifica los logs: `docker logs postgresql-dev`
- Confirma que las variables de entorno sean correctas

## 📚 Recursos Adicionales

- [Documentación de GitHub Actions](https://docs.github.com/en/actions)
- [Docker PostgreSQL Official Image](https://hub.docker.com/_/postgres)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)

## 🤝 Contribuciones

Si encuentras mejoras o errores, siéntete libre de:
1. Crear un issue
2. Enviar un pull request
3. Sugerir mejoras en la documentación

---

**¡Feliz aprendizaje con DevOps y CI/CD!** 🚀 