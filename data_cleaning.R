library(dplyr)
library(dbplyr)

ensayos <- DBI::dbConnect(RSQLite::SQLite(), "datos/ensayos.db")

src_dbi(ensayos)

cultivares <- tbl(ensayos, "cultivares")
datos_ensayos <- tbl(ensayos, "datos_ensayos")
empresa <- tbl(ensayos, "empresa")
localidades <- tbl(ensayos, "localidades")

cultivos <- full_join(datos_ensayos, cultivares, 
                      by = c("IdCultivar" = "idCultivar")) %>% 
  collect()


columnas_drop <- c("IdEnsayo_Cultivar", "IdCultivar", "Rendimiento_Ajustado",
                   "idEmpresa", "Latitud", "Longitud", "Fecha_Siembra", "IdLocalidad")

factores <- c('Campania', 'Tipo_Ensayo', 'Epoca', 'Tipo_Siembra', 'Testigo', 'Visible')


cultivos <- cultivos %>% 
  select(-any_of(columnas_drop)) %>% 
  # mutate(across(any_of(factores), as.factor)) %>%
  drop_na() %>% 
  janitor::clean_names()

write_csv(cultivos, "datos/cultivos.csv")


