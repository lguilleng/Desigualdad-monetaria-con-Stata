# Desigualdad monetaria con Stata

![](https://github.com/lguilleng/Desigualdad-monetaria-con-Stata/blob/main/graficos/introduccion.jpg)


Medir la desigualdad es necesario para responder a preguntas como:

- ¿es la distribución de ingreso más o menos igualitaria que en el pasado?
- ¿Existe una desigualdad en el acceso a la educación en términos de género u origen étnico?
- ¿Cuál es la brecha salarial entre hombres y mujeres?
- ¿Cuál es la magnitud de la desigualdad en acceso a agua potable entre zonas
urbanas y rurales y cómo ha evolucionado en el tiempo? 

**OJO**
La medida de desigualdad que escojamos debe responder a la
pregunta específica que nos interesa, por lo que es importante conocer las diferentes formas de
medir la desigualdad y sus respectivas propiedades.
Atkinson (1970

## Herramientas visuales para el análisis de la desigualdad

Las gráficas son una herramienta visual que resume la información sobre la distribución de una variable, lo que permite al analista tener una idea de los valores extremos, la concentración y dispersión de la variable, así como su simetría.

### 1. Histograma y función de densidad

El histograma representa la distribución de una variable. Su construcción consiste en organizar de menor a mayor la población de estudio según el valor de la variable de análisis y dividir el rango de la variable en segmentos preferiblemente iguales.

El número de segmentos depende de la precisión requerida: entre mayor sea el número de segmentos, más semejante será el histograma a la distribución real de la variable. Sin embargo, reproducir la distribución de la variable en un histograma puede terminar en una gráfica confusa, con muchos saltos, que en últimas no simplifica la información de su variabilidad.

```
set scheme s1color

g facpob=factor07*mieperho
hist ipcm [fw=int(facpob)], fraction ytitle("Fracción de la población") xtitle("ingreso per cápita mensual") title("Histograma del ingreso percápita mensual de Perú, 2021") note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```

![](graficos/histograma-1.JPG)

Debido a la amplia dispersión de la distribución del ingreso en la parte superior, basta con excluir del gráfico los valores correspondientes al 1% o 5% más rico para visualizar de manera más clara su distribución.

Excluyendo el 1%

```
sum ipcm [w=facpob], detail

                 Ingreso per cápita mensual
-------------------------------------------------------------
      Percentiles      Smallest
 1%     104.2556              0
 5%     182.7508       34.50232
(omitido)
95%     2101.439       26027.59       Skewness       5.389074
99%     4103.975       28911.83       Kurtosis       70.29174

hist ipcm [fw=int(facpob)] if ipcm<4000, fraction ytitle("Fracción de la población") xtitle("ingreso per cápita mensual") title("Histograma del ingreso percápita mensual de Perú excluyendo el 1% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```
![](graficos/histograma-2.JPG)

Excluyendo el 5%

```
sum ipcm [w=facpob], detail

                 Ingreso per cápita mensual
-------------------------------------------------------------
      Percentiles      Smallest
 1%     104.2556              0
 5%     182.7508       34.50232
(omitido)
95%     2101.439       26027.59       Skewness       5.389074
99%     4103.975       28911.83       Kurtosis       70.29174

hist ipcm [fw=int(facpob)] if ipcm<2000, fraction ytitle("Fracción de la población") xtitle("ingreso per cápita mensual") title("Histograma del ingreso percápita mensual de Perú excluyendo el 5% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```
![](graficos/histograma-3.JPG)

Una estimación no-paramétrica de la función de densidad de la variable por el método de kernels provee una representación suavizada de la información del histograma que resulta en una línea continua que bordea el histograma

```
kdensity ipcm [fw=int(facpob)] if ipcm<4000, ytitle("Densidad") xtitle("ingreso per cápita mensual") title("Distribución del ingreso percápita mensual de Perú excluyendo el 1% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```
![](graficos/kdensity-1.JPG)

Si necesitamos comparar las distribución del ingreso per cápita mensual para el área urbano y rural, a través de la función de densidad de kernels, el comando Stata es el siguiente:

```
g area=estrato<=5
label define area 1 "Urbano" 0 "Rural"
label value area area

graph twoway (kdensity ipcm [fw=int(facpob)] if area==1) (kdensity ipcm [fw=int(facpob)] if area==0) if ipcm<4000, xline(1000)legend(label(1 "Urbano") label(2 "Rural")) title("Distribución del ingreso percápita mensual de Perú excluyendo el 1% de valores mas altos, 2021", size(medsmall)) ytitle("Densidad") xtitle("ingreso per cápita mensual") note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```

### 2. Función de distribución acumulada

La función de distribución acumulada es otra manera de visualizar la distribución de una variable. Esta función indica la proporción acumulada de individuos (eje vertical) para cada valor del rango de la variable (eje horizontal), y comienza en las coordenadas (0,0) para ir aumentando hasta llegar al valor máximo del rango de la variable, donde la proporción acumulada es igual a 1. Esto se debe a que toda la población tiene un valor de la variable igual o menor al valor máximo.

```
cumul ipcm [fw=int(facpob)], gen(cipcm)

twoway line cipcm ipcm [fw=int(facpob)], sort title("Función acumulada del ingreso per cápita mensual en el Perú, 2021",size(medsmall)) ytitle("Proporción acumulada de la población") xtitle("ingreso per cápita mensual")
```
![](https://github.com/lguilleng/Desigualdad-monetaria-con-Stata/blob/main/graficos/distribucion%20acumulada-1.JPG)

Excluyendo el 5%

```
twoway line cipcm ipcm [fw=int(facpob)] if ipcm<2000, sort title("Función acumulada del ingreso per cápita mensual en el Perú",size(medsmall)) subtitle("excluyendo el 5% de valores mas altos, 2021",size(medsmall)) ytitle("Proporción acumulada de la población") xtitle("ingreso per cápita mensual")
```
![](https://github.com/lguilleng/Desigualdad-monetaria-con-Stata/blob/main/graficos/distribucion%20acumulada-2.JPG)

### 3. Diagrama de caja (Box Plot)

El boxplot es una representación simplificada de la distribución de una variable en estudio. Consiste en una caja que muestra el rango intercuartílico, es decir, el primer y tercer cuartil de la distribución (percentiles 25 y 75 respectivamente). La línea central de la caja corresponde a la mediana (percentil 50), mientras que dos líneas verticales se extienden desde la caja hacia los valores más extremos de la distribución. Estas líneas indican el valor adyacente inferior y superior de la distribución. Los valores que se encuentran por encima o por debajo de estas líneas se conocen como valores atípicos y pueden o no ser incluidos en el gráfico. El eje vertical del diagrama muestra los valores de la variable que corresponden a cada punto de la distribución.

El boxplot es una herramienta visualmente útil para determinar el rango de valores de la variable en estudio, así como la mediana y la dispersión, medida por el rango intercuartílico que se representa mediante la altura de la caja. Sin embargo, cuando se incluyen valores atípicos en el diagrama de caja, su lectura puede ser difícil debido a que la mayoría de las observaciones se concentran en los valores intercuantílicos, lo que puede hacer que la caja se vea como una línea horizontal cercana al eje horizontal, de manera similar a lo que sucede con el histograma o la función de distribución acumulada.

Para evitar la dificultad de lectura que pueden causar los valores atípicos, se recomienda presentar el diagrama de caja eliminando dichos valores o sustituyéndolos por el percentil 95 o 99 (en la parte derecha de la distribución) y el percentil 1 o 5 (en la parte izquierda de la distribución), según corresponda. Además, cuando se representa la variable en una escala logarítmica, el diagrama de caja se vuelve más fácil de interpretar, incluso si se incluyen valores atípicos.

![](graficos/boxplot-1.JPG)

```
graph box ipcm [fw=int(facpob)], ytitle("ingreso per cápita mensual") title("Distribución del ingreso percápita mensual de Perú, 2021") note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```
![](graficos/boxplot-2.JPG)

Excluyendo el 5%

```
graph box ipcm [fw=int(facpob)] if ipcm<2000, ytitle("ingreso per cápita mensual") title("Distribución del ingreso percápita mensual de Perú excluyendo el 5% de valores mas altos, 2021",size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```
![](graficos/boxplot-3.JPG)

¿Cómo se distribuye por área urbano / rural?

```
graph box ipcm [fw=int(facpob)] if ipcm<2000, over(area) ytitle("ingreso per cápita mensual") title("Distribución del ingreso percápita mensual de Perú por área", size(medsmall)) subtitle("excluyendo el 5% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")
```
![](graficos/boxplot-4.JPG)

### 4. La curva de Lorenz

La curva de Lorenz es una representación de la distribución del ingreso de una población (Lorenz, 1905). Esta curva tiene en el eje horizontal el porcentaje acumulado de individuos desde el más pobre hasta el más rico y en el eje vertical el porcentaje de ingreso perteneciente a cada porcentaje acumulado de la población.

![](graficos/lorenz-1.JPG)
![](graficos/lorenz-2.JPG)

Si una distribución domina en el sentido de Lorenz a otra, entonces todos los índices de desigualdad que cumplen la propiedad de Dalton-Pigou en sentido estricto reportan una menor desigualdad para la distribución dominante. Esta propiedad es muy útil puesto que, si existe dominancia de Lorenz entre dos distribuciones, es posible determinar sin ambigüedad cuál distribución es más equitativa, independiente del índice elegido para cuantificar la desigualdad. La magnitud de la diferencia sí depende del índice de desigualdad elegido.

#### Propiedad de Dalton-Pigou

Esta propiedad exige que todo indicador I(x) cumpla con el principio de las transferencias de Dalton-Pigou: ante toda transferencia igualadora el índice debe reflejar una caída en el nivel de desigualdad (o al menos no aumentar). Se trata de la propiedad central que distingue a un indicador de desigualdad.

Formalmente, para todo par de distribuciones x1, x2 y un escalar  tal que

x2i = x1i + , x2j = x1j - ,   x2k = x1k   para todo k  i , j;

entonces,

x1i < x2i  x2j < x1j  I(x2)  I(x1)

¿Cómo generamos la curva de Lorenz en Stata?

```
ssc install clorenz
```

Clorenz puede producir las siguientes curvas distribucionales para una lista dada de variables:

Curvas de Lorenz
Curvas de Lorenz generalizadas
Curvas de concentración
Curvas de concentración generalizadas

Curva de Lorenz del ingreso per cápita mensual del Perú, 2021

```
clorenz ipcm, hweight(facpob)![image](https://user-images.githubusercontent.com/132394402/236529313-29bf3bff-783e-420f-b192-f531687099d0.png)
```

![](graficos/lorenz-3.JPG)

Curva de Lorenz del ingreso per cápita mensual en área urbana y rural del Perú, 2021

```
clorenz ipcm, hweight(facpob) hgroup(area)
```

![](graficos/lorenz-4.JPG)

Curva de Lorenz del ingreso per cápita mensual en dominios costa, sierra, selva y lima metropolitana del Perú, 2021

```
recode dominio (1/3=1) (4/6=2) (7=3) (8=4), g(gdominio)
label define gdominio 1 "Costa" 2 "Sierra" 3 "Selva" 4 "Lima Metropolitana"
label value gdominio gdominio
clorenz ipcm, hweight(facpob) hgroup(gdominio)
```

![](graficos/lorenz-5.JPG)

La propiedad de que las curvas de Lorenz más cercanas a la línea de equidistribución representen distribuciones más igualitarias, ha llevado a la creación de índices de desigualdad que usan la distancia entre la curva de Lorenz y la línea de equidistribución como medida de desigualdad. Uno de estos es el coeficiente de Gini.

## Índices para el análisis de la desigualdad

