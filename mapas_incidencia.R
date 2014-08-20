#####################
#======
# Crea mapas interactivos sobre crímenes del fuero común a nivel estatal
#======
# Vease el script "descarga_datos.R" para referencia de cómo se obtuvieron las estadísticas
#====
require(reshape)
require(plyr)
require(ggplot2)

#### Cargar datos para los Estados
#====
# Estados
edo  <- read.csv("data/fuero-comun-estados.csv")

# La informacion esta disponible para distintas fechas
unique(edo$year) # 1997 - 2014


# Los archivos contienen todos los delitos del fuero comun reportados

unique(edo[,c("crime")])
head(edo[edo$crime=="HOMICIDIOS",],40)
table(edo$type)
table(edo$crime,edo$type)
#=====
# Tasas por cada 100 mil habitantes para el periodo 2011 - 2013

edo  <- subset(edo, year < 2014)
unique(edo$type)
# Agregar datos para crímenes en los siguientes grupos: homicidios, secuestros, robos, otros delitos

# Agregar DELITOS PATRIMONIALES, DELITOS SEXUALES, LESIONES, OTROS DELITOS, en una sola categoría llamada OTROS DELITOS
other  <- c("DELITOS PATRIMONIALES","DELITOS SEXUALES","LESIONES", "OTROS DELITOS")
edo$group  <- edo$crime
for(x in other){
  edo$group  <- gsub(x,"OTROS DELITOS", edo$group)
}


# Agregar homicidios dolosos como grupo
names(edo)
table(edo$type)
edo$group[edo$group =="HOMICIDIOS" & edo$type =="DOLOSOS"]  <- "HOMICIDIOS DOLOSOS"
edo$group[edo$group =="HOMICIDIOS" & edo$type =="CULPOSOS"]  <- "HOMICIDIOS CULPOSOS"

# Cambiar nombre secuestro
edo$group  <- gsub("PRIV. DE LA LIBERTAD \\(SECUESTRO\\)","SECUESTRO",edo$group)
table(edo$group)
format(table(edo$group)  / length(edo$group)*100, digits=2)

# Para efectos del mapa interactivo se excluirán de los cálculos las observaciones con NA.
summary(edo$count)
names(edo)
aveEdo <- ddply(edo, c("state_code","year","group"), summarize,
                averiguaciones = sum(count,na.rm=T))
head(aveEdo)
# Revisar si coinciden los numeros de averiguaciones
format(sum(edo$count,na.rm=T),big.mark=",") # Numero total de averiguaciones 26,457,133
format(sum(aveEdo$averiguaciones,na.rm=T), big.mark=",") # Numero total de averiguaciones 26,457,133

# Estimaciones de poblacion por estado 
population <- ddply(edo, c("state_code","year"), summarize,
                    population = max(population))
table(is.na(edo$population)) # Todas las obs tienen pob

##### Fix required
ddply(population, c("year"), summarize, population = prettyNum(sum(population), big.mark =",")) # Las estimaciones de poblacion se ven un poco altas
# Como los resultados se ven un poco altos (casi un million arriba) es necesario utilizar
# el archivo original de CONAPO http://www.conapo.gob.mx/es/CONAPO/Proyecciones_Datos

##### Fix required

# Tasa de averiguaciones previas por cada 100 mil habitantes
head(aveEdo)
head(population)
aveEdo  <- merge(aveEdo, population, by= c("state_code","year"))
aveEdo$rate  <- (aveEdo$averiguaciones*100000 / aveEdo$population)
summary(aveEdo$rate)

# Cambiar formato % en rate para reducir a dos decimales
aveEdo$rate  <- as.numeric(format(round(as.numeric(aveEdo$rate),2), nsmall = 2))

# Agregar abreviaturas de los estados
temp  <- read.csv("data/state_names.csv",stringsAsFactors=F, encoding="utf8")
temp
aveEdo  <- merge(aveEdo,temp)
head(aveEdo)
table(aveEdo$name)
table(aveEdo$group)

# Total de delitos del fuero común:
aveTot <- ddply(edo, c("state_code","year"), summarize,
                averiguaciones = sum(count,na.rm=T))
head(aveTot)
# Revisar si coinciden los numeros de averiguaciones
format(sum(edo$count,na.rm=T),big.mark=",") # Numero total de averiguaciones 26,457,133
format(sum(aveTot$averiguaciones,na.rm=T), big.mark=",") # Numero total de averiguaciones 26,457,133

# Calcular tasa del total de delitos del fuero común
aveTot  <- merge(aveTot, population, by= c("state_code","year"))
aveTot$rate  <- (aveTot$averiguaciones*100000 / aveTot$population)
summary(aveTot$rate)

# Cambiar formato % en rate para reducir a dos decimales
aveTot$rate  <- as.numeric(format(round(as.numeric(aveTot$rate),2), nsmall = 2))

# Agregar abreviaturas de los estados
temp  <- read.csv("data/state_names.csv",stringsAsFactors=F, encoding="utf8")
aveTot  <- merge(aveTot,temp)
head(aveTot)
table(aveTot$name)

# Estrucurar datos para mapas
#======
# Delitos del fuero común por grupo:
# Para los homicidios sólo se publicarán los homicidios dolosos
homicidios  <- subset(aveEdo, aveEdo$group == "HOMICIDIOS DOLOSOS")
secuestro  <- subset(aveEdo, aveEdo$group == "SECUESTRO")
robos  <- subset(aveEdo, aveEdo$group == "ROBOS")
otros  <- subset(aveEdo, aveEdo$group == "OTROS DELITOS")


# Exportar datos en formato csv como respaldo
write.csv(homicidios,"data/homicidios_estado.csv",row.names=F,fileEncoding="utf8")
write.csv(secuestro,"data/secuestros_estado.csv",row.names=F,fileEncoding="utf8")
write.csv(robos,"data/robos_estado.csv",row.names=F,fileEncoding="utf8")
write.csv(otros,"data/otros_estado.csv",row.names=F,fileEncoding="utf8")


#### Esta sección carga los paquetes necesarios para hacer los mapas interactivos

# Mapas interactivos:
#======
# Instalar librerías en Mac
#require(reshape2)
#require(devtools)
#install_github(repo='rCharts',username='ramnathv',ref="dev")
#install_github(repo='rMaps',username='ramnathv',ref="master")
require(rCharts)
require(rMaps)

# Ejecutar scripts para cada mapa
source("mapa_homicidios.R")
source("mapa_otros_delitos.R")
source("mapa_robos.R")
source("mapa_secuestro.R")
source("mapa_total_delitos_comun.R")

