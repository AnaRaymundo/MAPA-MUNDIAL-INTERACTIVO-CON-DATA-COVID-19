# MAPA MUNDIAL INTERACTIVO CON DATA COVID 19
#### INTEGRANTES
- Peña Alonso, Cristian
- Raymundo Caqui, Ana Liz
- Romero de la Cruz, Juan Daniel
- Rupay Ruiz, Kevin

#### Introducción

Los años 2020 y 2021 fueron y están siendo golpeados muy fuertemente por el virus más mortal de la historia, el COVID19 o también conocido como "Coronavirus", para ello como equipo decidimos combinar diversas librerías en Rstudio para así desarrollar un mapa mundial con los datos de casos confirmados, fallecidos y recuperados; por cada región de un determinado país.

#### Librerías a usar

```{r eval = FALSE}
library(Rcpp)
library(sf)
library(leafpop)
library(leaflet)
library(dplyr)
library(tidyverse)
```


#### Tenemos 3 csv que contienen los datos de casos confirmado,fallecidos y recuperados de covid. 

#### Abriendo los csv

```{r eval=FALSE}
confirmados_covid<-read.csv("casos confirmados.csv")
fallecidos_covid<-read.csv("fallecidos.csv")
recuperados_covid<-read.csv("recuperados.csv")
```

#### Necesitamos que los datos estén en un mismo archivo csv. Para ello Seleccionamos la columna que queremos.

```{r eval=FALSE}
d1<-recuperados_covid %>% dplyr::select(Recovered)
d2<-fallecidos_covid %>% dplyr::select(Deaths)

```


#### Cambiando el nombre de la columna

```{eval=FALSE} 
colnames(d1) <- c("Recuperados")
colnames(d2) <- c("Muertos")
```

#### visualizacion
```{r eval=FALSE}
view(d1)
view(d2)
```

#### Agregando los datos extraidos en un csv

```{r eval=FALSE}
data_final<-confirmados_covid %>% mutate(Fallecidos=d2,Recuperados=d1) %>% 
summarise(Province_State,Country_Region,
                                            Registro=Last_Update,Long_,Lat,
                                            Confirmados=Confirmed,Fallecidos,
                                            Recuperados)

```


#### Eliminando datos perdidos (no poseen coordenadas)

```{r eval=FALSE}
covid_final<-na.omit(data_final)
view(covid_final)
```

#### Reemplazando los 0 por N.A 

```{r eval=FALSE}
cov_final2<-na_if(covid_final,0)
view(cov_final2)

```

#### Poniendo coordenadas al data frame

```{r eval=FALSE}

cord_covid <- st_as_sf(cov_final2, coords = c("Long_", "Lat"), crs = st_crs(4326))

```

#### Visualización

```{r eval =FALSE}
cord_covid %>%
  leaflet() %>%
  
```

#### Añadiendo créditos

```{r eval=FALSE  }
cord_covid %>%
  leaflet() %>%
  addTiles(attribution = 'Mapa Covid-19')


```

#### Nueva forma vusal y datos de cada punto

```{r eval=FALSE}

cord_covid %>%
  leaflet() %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions())

```

#### Añadiendo minimapa
```{r eval=FALSE}
ord_covid %>%
  leaflet() %>%
  addTiles(attribution = 'Mapa Covid-19') %>%
  addMarkers(data = cord_covid,group = "a",
             popup =  popupTable(cord_covid),
             clusterOptions = markerClusterOptions()) %>%
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = T,
    position = "bottomright")
```

#### Añadiendo un boton para ubicacion

```{r eval=FALSE}
cord_covid %>%
  leaflet() %>%
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


```



#### Añadiendo capas esteticas y un boton de capas

```{r eval = FALSE}
cord_covid %>%
  leaflet() %>%
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
   addTiles(group = "OSM (default)") %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner", "Toner Lite")) 

```

#### Usamos una imagen para el logo

```{r eval = FALSE}
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
```` 
