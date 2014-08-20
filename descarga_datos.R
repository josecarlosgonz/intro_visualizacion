#####################
#======
# Descarga de datos del Secretariado Ejecutivo de Seguridad Pública
#======

# Debido a que el servidor del Secretariado Ejecutivo de Seguridad Pública tiene un funcionamiento
# intermitente, es necesario descargar los datos desde el Blog de Diego Valle-Jones. El cual
# provee una rutina que descarga y estructura automáticamente los datos del Secretariado
# URL al blog de Diego Valle- Jones: http://crimenmexico.diegovalle.net/en/csv/
# URL de la fuente original de datos: http://www.secretariadoejecutivo.gob.mx/es/SecretariadoEjecutivo/Incidencia_Delictiva
#====
#====
#### Descargar datos

# Municipios
require(R.utils) 
temp <- tempfile()
download.file("http://crimenmexico.diegovalle.net/en/csv/fuero-comun-municipios.csv.gz",temp)
mun <- read.csv(gunzip(temp, "fuero-comun-municipios.csv.gz", overwrite=T))
unlink(temp)
file.remove("fuero-comun-municipios.csv.gz")

# Estados
temp <- tempfile()
download.file("http://crimenmexico.diegovalle.net/en/csv/fuero-comun-estados.csv.gz",temp)
edo <- read.csv(gunzip(temp, "fuero-comun-estados.csv.gz", overwrite=T))
file.remove("fuero-comun-estados.csv.gz")
unlink(temp)