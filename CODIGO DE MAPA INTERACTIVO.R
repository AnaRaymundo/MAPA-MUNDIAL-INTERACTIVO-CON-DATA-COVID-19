#seteando 
setwd("C:/Users/Usuario/Desktop/UNMSM/2020-2/PROGRA/final/COVID-19-master")
#librerias
install.packages("leafpop")

library(sf)
library(leafem)
library(leafpop)
library(leaflet)
library(dplyr)
library(tidyverse)

#leyendo los *.csv
confirmados_covid<-read.csv("casos confirmados.csv")
fallecidos_covid<-read.csv("fallecidos.csv")
recuperados_covid<-read.csv("recuperados.csv")

#seleccionando con la funcion select
d1 <- recuperados_covid %>% dplyr::select(Recovered)
d2 <- fallecidos_covid %>% dplyr::select(Deaths)

#Cambiando el nombre de la columna
colnames(d1) <- c("Recuperados")
colnames(d2) <- c("Muertos")

#Uniendo los datos

data_final <- confirmados_covid %>% mutate(Fallecidos = d2, Recuperados = d1) %>% 
    summarise(Provincia_estado = Province_State,
              Pais = Country_Region ,
            Registro = Last_Update,Long_,Lat,
            Confirmados = Confirmed,  Fallecidos,
            Recuperados) 


#eliminando lat y long con  NA

covid_final <- na.omit(data_final)

# Eliminando los cero
covid_final <- na_if(covid_final,0)


#georefereciando
cord_covid <- st_as_sf(covid_final, 
                       coords = c("Long_", "Lat"), 
                       crs = st_crs(4326))


#leafleteando
cord_covid %>%
leaflet() 

#Añadiendo creditos
cord_covid %>%
  leaflet() %>%
  addTiles(attribution = 'Mapa Covid-19')

#Arreglando el zoom
cord_covid %>%
  leaflet(options = leafletOptions(zoomControl = TRUE,
                                   minZoom = 1, maxZoom = 8,
                                   dragging = TRUE)) %>%
  addTiles(attribution = 'Mapa Covid-19') %>% 
  addCircles(data = cord_covid)



#Añadiendo nueva forma visual  y los datos por cada punto georeferenciado
cord_covid %>%
  leaflet(options = leafletOptions(zoomControl = TRUE,
                                   minZoom = 1, maxZoom = 8,
                                   dragging = TRUE)) %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,group = "a",
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions())

#Añadiendo un minimapa
cord_covid %>%
  leaflet(options = leafletOptions(zoomControl = TRUE,
                                   minZoom = 1, maxZoom = 8,
                                   dragging = TRUE)) %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,group = "a",
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions()) %>%
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE,
    position = "bottomright")

#Añadiendo un bottom para ubicación

cord_covid %>%
  leaflet(options = leafletOptions(zoomControl = TRUE,
                                   minZoom = 1, maxZoom = 8,
                                   dragging = TRUE)) %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,group = "a",
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions()) %>%
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE,
    position = "bottomright") %>%
  addEasyButton(easyButton(
    icon = "fa-crosshairs", 
    title = "Ubicame",
    onClick = JS("function(btn, map){ map.locate({setView: true}); }")))

#Añadiendo capas esteticos y un boton de capas 
cord_covid %>%
  leaflet(options = leafletOptions(zoomControl = TRUE,
                                   minZoom = 1, maxZoom = 8,
                                   dragging = TRUE)) %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,group = "a",
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions()) %>%
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE,
    position = "bottomright") %>%
  addEasyButton(easyButton(
    icon = "fa-crosshairs", 
    title = "Ubicame",
    onClick = JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
  addProviderTiles("Stamen.TonerLite",
                   group = "Toner"
  ) %>%
  addTiles(group = "OSM"
  ) %>%
  addProviderTiles("Esri.WorldTopoMap",    
                   group = "Topo") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Mapnik") %>%
  addProviderTiles("CartoDB.Positron",     group = "CartoDB") %>%
  addLayersControl(baseGroups = c("Toner", "OSM", "Topo", "Mapnik", "CartoDB"),
                   options = layersControlOptions(collapsed = TRUE))

#usamos una imagen para el logo

img <- "https://www.r-project.org/logo/Rlogo.svg"

#Ahora, añadimos un logo
cord_covid %>%
  leaflet(options = leafletOptions(zoomControl = TRUE,
                                   minZoom = 1, maxZoom = 8,
                                   dragging = TRUE)) %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,group = "a",
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions()) %>%
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE,
    position = "bottomright") %>%
  addEasyButton(easyButton(
    icon = "fa-crosshairs", 
    title = "Ubicame",
    onClick = JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
  addProviderTiles("Stamen.TonerLite",
                   group = "Toner"
                    ) %>%
  addTiles(group = "OSM"
           ) %>%
  addProviderTiles("Esri.WorldTopoMap",    
                   group = "Topo") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Mapnik") %>%
  addProviderTiles("CartoDB.Positron",     group = "CartoDB") %>%
  addLayersControl(baseGroups = c("Toner", "OSM", "Topo", "Mapnik", "CartoDB"),
                   options = layersControlOptions(collapsed = TRUE))%>% 
  addLogo(img, url = "https://www.r-project.org/logo/") 



 

