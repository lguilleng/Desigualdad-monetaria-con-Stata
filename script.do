
g area=estrato<=5
label define area 1 "Urbano" 0 "Rural"
label value area area

graph twoway (kdensity ipcm if area==1) (kdensity ipcm if area==0) if ipcm<5000, xline(1000)legend(label(1 "Urbano") label(2 "Rural")) title("Distribución del ingreso percápita mensual de Perú excluyendo el 1% de valores mas altos, 2021", size(medsmall)) ytitle("Densidad") xtitle("ingreso per cápita mensual") note("Fuente: Encuesta Nacional de Hogares, Perú 2021")



cumul ipcm, gen(cipcm)
twoway line cipcm ipcm, sort title("Función de distribución acumulada")

g facpob=factor07*mieperho
hist ipcm [fw=int(facpob)], fraction ytitle("Fracción de la población") xtitle("ingreso per cápita mensual") title("Histograma del ingreso percápita mensual de Perú, 2021") note("Fuente: Encuesta Nacional de Hogares, Perú 2021")


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

hist ipcm [fw=int(facpob)] if ipcm<2000, fraction ytitle("Fracción de la población") xtitle("ingreso per cápita mensual") title("Histograma del ingreso percápita mensual de Perú excluyendo el 5% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")

kdensity ipcm [fw=int(facpob)] if ipcm<4000, ytitle("Densidad") xtitle("ingreso per cápita mensual") title("Distribución del ingreso percápita mensual de Perú excluyendo el 1% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")


graph twoway (kdensity ipcm [fw=int(facpob)] if area==1) (kdensity ipcm [fw=int(facpob)] if area==0) if ipcm<4000, xline(1000)legend(label(1 "Urbano") label(2 "Rural")) title("Distribución del ingreso percápita mensual de Perú excluyendo el 1% de valores mas altos, 2021", size(medsmall)) ytitle("Densidad") xtitle("ingreso per cápita mensual") note("Fuente: Encuesta Nacional de Hogares, Perú 2021")


drop cipcm
cumul ipcm [fw=int(facpob)], gen(cipcm)
twoway line cipcm ipcm [fw=int(facpob)] if ipcm<2000, sort title("Función acumulada del ingreso per cápita mensual en el Perú",size(medsmall)) subtitle("excluyendo el 5% de valores mas altos, 2021",size(medsmall)) ytitle("Proporción acumulada de la población") xtitle("ingreso per cápita mensual")


graph box ipcm [fw=int(facpob)] if ipcm<2000, over(area) ytitle("ingreso per cápita mensual") title("Distribución del ingreso percápita mensual de Perú por área", size(medsmall)) subtitle("excluyendo el 5% de valores mas altos, 2021", size(medsmall)) note("Fuente: Encuesta Nacional de Hogares, Perú 2021")


******** GINI *******
summ ipcm [w=facpob] if ipcm>0
* poblacion de referencia
local obs = r(sum_w)
* media ingreso
local media = r(mean)
sort ipcm
* suma acumulada del ponderador (población)
gen aux = sum(facpob) if ipcm>0
* ubicación promedio en el ranking de ingresos de persona en la población
gen i = (2*aux - facpob + 1)/2
gen aux2 = ipcm*(`obs'-i+1)
summ aux2 [w=facpob]
local gini = 1 + (1/`obs') - (2/(`media'*`obs'^2)) * r(sum)
display "gini = `gini'"


******** THEIL *******
summ ipcm [w=facpob] if ipcm>0
local media = r(mean)

gen termino = ipcm/`media'*ln(ipcm/`media')
summ termino [w=facpob]
local theil = (r(sum)/r(sum_w))

display "Theil = `theil'"


******** ATKINSON *******

* parametro aversión desigualdad
local epsilon = 0.5

summ ipcm [w=facpob] if ipcm>0
local obs = r(sum_w)
local media = r(mean)
drop termino

* epsilon == 1
if `epsilon' == 1 {
generate termino = ln(ipcm/`media')
summ termino [w=facpob]
local atk = 1 - exp(1/`obs'*r(sum))
}
* epsilon != 1
else {
generate termino = (ipcm/`media') ^ (1-`epsilon')
summ termino [w=facpob]
local atk = 1 - (r(sum)/`obs') ^ (1/(1-`epsilon'))
}

display as text "Atkinson(e=`epsilon') = " as result `atk'

