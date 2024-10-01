# README

## Instalaciones necesarias

* Postgres
  ```bash
    # actualizamos el sistema
    sudo apt update
    sudo apt upgrade
    # instalamos postgresql
    sudo apt install postgresql postgresql-contrib libpq-dev
    # verificamos la instalación
    sudo systemctl status postgresql
    # habilitamos el servicio
    sudo systemctl start postgresql
    # Creamos un usuario y contraseña
    sudo -i -u postgres
    createuser --interactive
    psql
    ALTER USER "usuario" WITH PASSWORD 'password';
    # verificamos la creación del usuario
    \du
    \q
    exit
  ```

* La versión de ruby que utilizaremos es la 3.2.2, recomiendo usar rbenv para realizar la instalación.

## Configuración del proyecto
* Clonamos el repositorio
```bash
  git clone url_del_repositorio
```
* Descargamos las gemas necesarias
```bash
  bundle install
```
* Creamos un archivo llamado `.env` en la raíz del proyecto con las siguientes variables de entorno (usuario y password son los datos que se ingresaron al crear el usuario en postgresql)
```bash
  DB_USER=usuario
  DB_PASS=password
```
* Realizamos el setup de la BD
```bash
  bin/rails db:setup
```
* Corremos el servidor
```bash
  bin/rails s
```

## Datos para hacer pruebas
* Tenemos 3 usuarios en la BD con los siguientes datos cada uno:
  ```ruby
  [
  # id     name         username      balance_usd     balance_btc
    [3,  "Testino",    "testino2",  "200.0",         "1.0"],
    [1,  "Jose Pablo", "jpablo",    "4000.0",        "5.015621619330259052"],
    [2,  "Testino",    "testino1",  "4198.589545",   "0.95"]
  ]
  ```
* sobre estos datos podemos usar los endpoints para crear transactions, listar transactions, etc.
  
## Uso de la api
* La api está desplegada en heroku, la documentación de esta podemos verla en [link](https://vita-api-603504249c56.herokuapp.com/api-docs/index.html) y podemos hacer pruebas de los endpoints directamente acá, tal como se muestra en el vídeo.
  

https://github.com/user-attachments/assets/372f2ff0-9352-4eff-b75a-d4c9a727ee74


* Tenemos 4 endpoints:
  - ``/btc_price``: get que nos trae el cambio del btc a dolar.
  - ``/transactions``: post que nos permite crear una transaction, pasando como body ``user_id`` ``currency_sent`` ``currency_received`` ``amount_sent`` (Los únicos valores válidos para currency_sent y currency_received son: ``USD`` ``BTC``)
  - ``/transactions/{id}``: get que nos trae una transaction en específico.
  - ``/users/{user_id}/transactions``: get que nos trae la lista de todas las transacciones de un user en específico.
* Si gustamos podemos hacer las pruebas directamente en la documentación de la api que se adjuntó, sino podemos probarla usando cualquier otra herramienta.

## Tests
* Para correr los tests podemos usar el comando
```bash
  bundle exec rspec
```
