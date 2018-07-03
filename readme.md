# Lønseddel-data-udtrækker

Dette repository indeholder kode til at trække informationer ud af lønsedler.

### STEP 1: Start docker containeren

Der er bygget et såkaldt docker-compose script der ordner alt setup. Du skal bare eksekvere kommandoen:

```
docker-compose up -d
```

Det kan godt tage lidt tid, hvis den lige skal downloade det hele. 

### STEP 2: Log ind i Rstudio
Derefter er Rstudio klar i din browser på dette link: [http://0.0.0.0:6237/](http://0.0.0.0:6237/)

Bruger og password er `rstudio`.


### STEP 3: Kør koden
I Rstudio åbner du filen `script.R`.

Du skal lave en mappe i den mappe hvor du startede `docker-compose`, der indeholder de lønsedler du vil have data på. Der er allerede en mappe, der hedder "pdf_mappe". Hvis du lægger lønsedlerne der, så virker koden automatisk, da den er skrevet til at lede efter den mappe.

Ellers så bare læs script.R filen igennem. Der står hvad du skal gøre.


