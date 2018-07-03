# Først loader vi nogle nødvendige biblioteker ind som skal bruges
# Du kan tænke på det lige som Apps på en smartphone. De kan noget 
# vi skal bruge i vores analyse.
library(pdftools)
library(tidyverse)

# Men de kan ikke alt. Så derfor bygger vi selv en særlig funktion
# der kan hive præcis det data ud af lønsedlerne som vi har brug for.
extract_pay_info <- function(txt){
  
  lines <- read_lines(txt)
  
  pay_period_regex <- "Lønperiode:\\s+\\d{2}.\\d{2}.\\d{4} - \\d{2}.\\d{2}.\\d{4}"
  
  am_pay_regex <- "AM-indkomst\\s+([[:graph:]])+\\s"
  
  restaurant <- lines[1] %>% str_trim()
  
  person <- lines[which(str_detect(lines, "CPR-nummer")) + 1] %>% str_trim()
  
  pay_period <- str_extract(txt, pay_period_regex) %>%
    str_extract("\\d{2}.\\d{2}.\\d{4} - \\d{2}.\\d{2}.\\d{4}")
  
  pay_period_start <- pay_period %>%
    str_split(" - ") %>%
    unlist() %>%
    .[1] %>%
    lubridate::dmy()
  
  pay_period_end <- pay_period %>%
    str_split(" - ") %>%
    unlist() %>%
    .[2] %>%
    lubridate::dmy()
  
  pay_month <- lubridate::month(pay_period_end, label = TRUE)
  
  am_pay <- str_extract(txt, am_pay_regex) %>%
    str_replace("AM-indkomst\\s+", "") %>%
    str_trim()
  
  am_pay <- am_pay %>% 
    str_replace_all("\\.", "") %>%
    str_replace_all(",", ".") %>%
    as.numeric()
  
  out <- tibble(person, restaurant, pay_period_start, pay_period_end, pay_month, am_pay)
  
  return(out)
}

# Læg dine pdf'er i en mappe i samme folder som denne kode.
# I dette tilfælde er alle pdf'erne lagt i mappen "pdf_mappe"
# Derefter kører du næste linje, der finder alle pdf'erne i mappen
pdfs <- list.files("pdf_mappe", pattern = ".pdf", full.names = TRUE)
  
# Denne linje kører et loop henover alle pdf'erne og udtrækker teksten
txts <- map(pdfs, pdf_text) %>% unlist()
  
# Denne linje kører vores særlige funktion ned over alle de tekster
# vi har trukket ud af pdf'erne.
pay_df <- map_df(txts, extract_pay_info)

# Denne sidste linje skriver alle oplysningerne til en csv file
write_excel_csv(x = pay_df, path = "pay_info.csv")

# OBS:
# Når du læser filen ind i excel skal du gå til menupunket: data
# Klik derefter på from text / fra tekst
# Her vælger du denne fil. Under Advanced skal du vælge at 
# decimal er angivet ved , og ikke .