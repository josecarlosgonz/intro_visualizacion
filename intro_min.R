# Introducción mínima a R
# Autor: Jose Gonzalez | www.jose-gonzalez.org

# Asignación: <-

# El símbolo "" crea un objeto en R. Se recomienda usarloe en vez de "=" ya que tienen sigfificados distintos
x  <- 2
x
x + 2

# Directorio de trabajo
getwd() # Actual
setwd() # Cambiar directorio

# Cargar un archivo csv
data  <- read.csv("data/envipe2011-2013.csv", encoding="utf8")

# Explorar el archivo
str(data) # Número de observaciones y tipo de variables (i.e. numeric / string)
head(data) # Ver las primeras 10 líneas

# Summary
summary(data)

# Agregar rankings por percepción de inseguridad en 2013 como nueva variable
data$rkIns2013  <- rank(-data$ins2013, ties.method = "min")
head(data)

# R funciona con paquetes, existen miles de ellos
# Instalar un Paquete
install.packages("ggplot2") # ggplto2 facilita hacer gráficos con un buen diseño
# Cargar el paquete
library(ggplot2)
# tambien permite generar plantillas de diseño
qplot(data$pre2012) #histograma prevalencia delictiva
qplot(data$pre2012, data$inc2012) #scatter plot prevalencia vs inciencia

# Agregar lineas de regresion
ggplot(data, aes(x=pre2012, y=inc2012)) +
  geom_point(shape=1) +    # círculos
  geom_smooth() +            # Loess fit con intervalo de confianza
  ggtitle("Prevalencia vs incidencia")
