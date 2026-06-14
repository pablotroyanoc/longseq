setwd("C:/Users/pablo/Desktop/Practicas_SQANTI/final_results/classification_tables")
library(tidyverse)
library(ggplot2)

archivos <- list.files(pattern = "*.txt")
print(archivos)
lista_tablas <- list()

for (f in archivos) {
  
  #EXTRAER IDs con str_split 
  partes <- str_split(f, "_", simplify = TRUE)
  
  sID <- partes[1]
  cID <- partes[2]
  rID <- partes[3]
  
  #CARGAR LA TABLA
  temp_df <- read_delim(f, delim = "\t", show_col_types = FALSE)
  
  #AÑADIR LAS COLUMNAS EXTRA
  temp_df <- temp_df %>%
    mutate(
      sample = sID,
      condition = cID,
      reconstruction = rID
    )
  
  #GUARDAR EN LA LISTA
  lista_tablas[[f]] <- temp_df
  
  message("Procesado: ", f)
}
# Structural category labels
sc_labels <- c("full-splice_match"="FSM", "incomplete-splice_match"="ISM", "novel_in_catalog"="NIC", "novel_not_in_catalog"="NNC", "antisense"="Antisense", "intergenic"="Intergenic", "fusion"="Fusion", "genic"="Genic", "genic_intron"="Genic Intron")
sc_levels <- c("full-splice_match", "incomplete-splice_match", "novel_in_catalog", "novel_not_in_catalog", "antisense", "intergenic", "fusion", "genic", "genic_intron")

colores_finales <- c(
  "Bambu" = "#228B22", "Flair" = "#FFD700", 
  "IsoquantNoRef" = "#D81B60", "IsoquantRef" = "#1E90FF", "Reads" = "#264653"
)

#CONCATENAR
datos_completos <- bind_rows(lista_tablas)

#SELECCIONAR columnas importantes
datos_finales <- datos_completos %>% 
  select(
    sample,
    condition,
    reconstruction,
    isoform,
    structural_category,
    subcategory,
    associated_gene,
    associated_transcript,
    start,
    end,
    strand,
    length,
    exons,
    all_canonical,
    RTS_stage,
    perc_A_downstream_TTS,
    coding,
    CDS_length,
    ORF_length,
    FL
    )

rm(datos_completos)

dim(datos_finales)

unique(datos_finales$sample)

### VER EL NÚMERO DE READS POR MUESTRA
datos_finales %>%
  filter(reconstruction == "Reads") %>%
  group_by(sample, condition) %>%
  summarise(Reads_Secuenciados = n(), .groups = 'drop') %>%
  mutate(Muestra = paste(sample, condition, sep = "_")) %>%
  select(Muestra, Reads_Secuenciados)


###BOXPLOT CON PANELES
datos_boxplot <- datos_finales %>%
  group_by(sample, reconstruction, structural_category) %>%
  summarise(n = n(), .groups = 'drop') %>%
  group_by(sample, reconstruction) %>%
  mutate(porcentaje_interno = (n / sum(n)) * 100)

datos_boxplot <- datos_boxplot %>%
  mutate(structural_category = factor(structural_category, labels=sc_labels, levels = sc_levels))

ggplot(datos_boxplot, aes(x = reconstruction, y = porcentaje_interno, fill = reconstruction)) +
  geom_boxplot(outlier.shape = NA, alpha = 1, color = "black", size = 0.4) + 
  facet_wrap(~structural_category, scales = "free_y") + 
  scale_fill_manual(values = c(
    "Bambu" = "#228B22", "Flair" = "#FFD700", 
    "IsoquantNoRef" = "#D81B60", "IsoquantRef" = "#1E90FF", "Reads" = "#264653"
  )) +
  theme_bw() +
  labs(y = "Percentage (%)", x = "Method") +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1, size = 16, color = "black"),
    axis.text.y = element_text(size = 14, color = "black"),
    axis.title = element_text(size = 17, face = "bold"),
    strip.text = element_text(size = 17, face = "bold"),
    strip.background = element_rect(fill = "gray95")
  )

### BOXPLOT CON PANELES (FSM, ISM, NIC, NNC)
datos_boxplot <- datos_finales %>%
  group_by(sample, reconstruction, structural_category) %>%
  summarise(n = n(), .groups = 'drop') %>%
  group_by(sample, reconstruction) %>%
  mutate(porcentaje_interno = (n / sum(n)) * 100)

datos_boxplot <- datos_boxplot %>%
  mutate(structural_category = factor(structural_category, labels=sc_labels, levels = sc_levels))

# FILTRADO
datos_boxplot_filtrado <- datos_boxplot %>%
  filter(structural_category %in% c("FSM", "ISM", "NIC", "NNC"))

ggplot(datos_boxplot_filtrado, aes(x = reconstruction, y = porcentaje_interno, fill = reconstruction)) +
  geom_boxplot(outlier.shape = NA, alpha = 1, color = "black", size = 0.6) + 
  facet_wrap(~structural_category, scales = "free_y", ncol = 2) + 
  scale_fill_manual(values = c(
    "Bambu" = "#228B22", "Flair" = "#FFD700", 
    "IsoquantNoRef" = "#D81B60", "IsoquantRef" = "#1E90FF", "Reads" = "#264653"
  )) +
  theme_bw(base_size = 22) + 
  labs(y = "Percentage (%)", x = "Method") +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1, size = 20, color = "black", face = "bold"),
    axis.text.y = element_text(size = 20, color = "black"),
    axis.title = element_text(size = 24, face = "bold"),
    strip.text = element_text(size = 24, face = "bold"), 
    strip.background = element_rect(fill = "gray95"),
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank()
  )


###BOXPLOT SIN PANELES
datos_boxplot <- datos_finales %>%
  group_by(sample, reconstruction, structural_category) %>%
  summarise(n = n(), .groups = 'drop') %>%
  group_by(sample, reconstruction) %>%
  mutate(porcentaje_interno = (n / sum(n)) * 100) %>%
  mutate(structural_category = factor(structural_category, 
                                      levels = sc_levels, 
                                      labels = sc_labels))

ggplot(datos_boxplot, aes(x = structural_category, y = porcentaje_interno, fill = reconstruction)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7, width = 0.8, position = position_dodge(width = 0.8)) + 
  geom_point(position = position_dodge(width = 0.8), size = 0.4, alpha = 0.3) + 
  scale_fill_manual(values = c(
    "Bambu" = "#228B22", 
    "Flair" = "#FFD700", 
    "IsoquantNoRef" = "#D81B60", 
    "IsoquantRef" = "#1E90FF", 
    "Reads" = "#264653"
  )) +
  labs(
    x = "Structural Category",
    y = "Percentage (%)",
    fill = "Method"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 16, color = "black"),
    axis.text.y = element_text(size = 16, color = "black"),
    axis.title = element_text(size = 17, face = "bold"),
    strip.text = element_text(size = 17, face = "bold"),
    strip.background = element_rect(fill = "gray95"),
    legend.position = "bottom",
    legend.background = element_rect(fill = "gray98", color = "gray80"),
    legend.title = element_text(size = 16, face = "bold"),
    legend.text = element_text(size = 15),              
    legend.key.size = unit(1.2, "cm") 
  )



###Length distribution
datos_finales %>%
  mutate(structural_category = factor(structural_category, 
                                      levels = sc_levels, 
                                      labels = sc_labels)) %>%

ggplot(aes(x = length, fill = reconstruction, color = reconstruction)) +
  geom_density(alpha = 0.3, size = 0.8) +
  facet_wrap(~structural_category, scales = "free") + 
  scale_x_log10(breaks = c(100, 500, 1000, 3000, 10000)) +
  scale_fill_manual(values = c(
    "Bambu" = "#228B22", "Flair" = "#FFD700", 
    "IsoquantNoRef" = "#D81B60", "IsoquantRef" = "#1E90FF", "Reads" = "#264653"
  )) +
  scale_color_manual(values = c(
    "Bambu" = "#228B22", "Flair" = "#FFD700", 
    "IsoquantNoRef" = "#D81B60", "IsoquantRef" = "#1E90FF", "Reads" = "#264653"
  )) +
  theme_bw() +
  labs(
    x = "Sequence length (bp, log10 scale)",
    y = "Density",
    fill = "Method",
    color = "Method"
  ) +
  theme(
    legend.position = "bottom",
    legend.title = element_text(size = 18, face = "bold"),
    legend.text = element_text(size = 18),
    axis.text = element_text(size = 14, color = "black"),
    axis.title = element_text(size = 19, face = "bold"),
    strip.text = element_text(size = 18, face = "bold"),
    strip.background = element_rect(fill = "gray95")
  )


###INTRAPRIMING PERC
# 1. Calculamos el % de isoformas con > 60% de intrapriming por programa
datos_porcentaje_peligro <- datos_finales %>%
  group_by(reconstruction) %>%
  summarise(
    total_isoformas = n(),
    n_peligro = sum(perc_A_downstream_TTS > 60, na.rm = TRUE),
    porcentaje_peligro = (n_peligro / total_isoformas) * 100,
    .groups = 'drop'
  )

# 2. Representación en Barplot de porcentajes
ggplot(datos_porcentaje_peligro, aes(x = reconstruction, y = porcentaje_peligro, fill = reconstruction)) +
  geom_bar(stat = "identity", alpha = 0.6, color = "black", width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = paste0(round(porcentaje_peligro, 2), "%")), 
            vjust = -1, size = 6, fontface = "bold") +
  scale_fill_manual(values = colores_finales) +
  theme_minimal() +
  labs(
    x = "Method",
    y = "% of Total Isoforms (>60% Adenines)"
  ) +
  theme(
    axis.title.y = element_text(size = 18, face = "bold", margin = margin(r = 20)),
    axis.title.x = element_text(size = 18, face = "bold", margin = margin(t = 20)),
    axis.text = element_text(size = 16, color = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2)))


###Numbre of isoforms per gene

#Preparamos los datos: contamos isoformas y FILTRAMOS las "Reads"
distribucion_genes <- datos_finales %>%
  filter(reconstruction != "Reads") %>%  # <--- Aquí quitamos la categoría de lecturas crudas
  group_by(reconstruction, sample, associated_gene) %>%
  summarise(n_isoformas = n(), .groups = 'drop')

ggplot(distribucion_genes, aes(x = reconstruction, y = n_isoformas, fill = reconstruction)) +
  geom_jitter(width = 0.2, alpha = 0.05, size = 0.5, color = "gray40") + 
  geom_boxplot(alpha = 1, outlier.shape = NA, color = "black", width = 0.5, size = 0.7) +
  scale_y_log10(breaks = c(1, 2, 5, 10, 20, 50, 100)) +
  scale_fill_manual(values = colores_finales) +
  theme_minimal(base_size = 20) + 
  labs(
    x = "Method",
    y = "Number of Isoforms per gene"
  ) +
  theme(
    legend.position = "none",
    axis.title.x = element_text(size = 22, face = "bold", margin = margin(t = 15)),
    axis.title.y = element_text(size = 22, face = "bold", margin = margin(r = 15)),
    axis.text.x = element_text(size = 18, color = "black", face = "bold"),
    axis.text.y = element_text(size = 18, color = "black"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray90")
  )

ggsave("number_of_isoforms_no_reads.png", width = 9, height = 7, dpi = 300)


###ISOQUANT
tmap <- read_delim("comparativa_global_tmaps.tsv", delim = "\t")
datos_finales <- datos_finales %>%
  mutate(sample_full = paste(sample, condition, sep = "_"))
unique(datos_finales$sample_full)

# Clasificamos el NoRef
noref_clasificado <- datos_finales %>%
  filter(reconstruction == "IsoquantNoRef") %>%
  left_join(tmap, by = c("isoform" = "qry_id", "sample_full" = "sample")) %>%
  mutate(Grupo = ifelse(!is.na(class_code) & class_code == "=", "Common", "NoRef_Esp"))

# Comprobamos cuántas hay de cada una
table(noref_clasificado$Grupo)

# Buscamos en el análisis CON Referencia las que no están en el tmap
ref_clasificado <- datos_finales %>%
  filter(reconstruction == "IsoquantRef") %>%
  anti_join(tmap, by = c("isoform" = "ref_id", "sample_full" = "sample")) %>%
  mutate(Grupo = "Ref_Esp")

nrow(ref_clasificado)

tabla_para_grafico <- bind_rows(
  noref_clasificado %>% select(FL, Grupo),
  ref_clasificado %>% select(FL, Grupo)
)

ggplot(tabla_para_grafico, aes(x = Grupo, y = FL, fill = Grupo)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8, color = "black", width = 0.6) + 
  scale_y_log10() + 
  scale_fill_manual(values = c(
    "Common" = "#2ecc71", 
    "NoRef_Esp" = "#f1c40f", 
    "Ref_Esp" = "#e74c3c"  
  )) +
  theme_minimal() +
  labs(
    title = NULL,     
    subtitle = NULL,  
    x = "Isoform Group", 
    y = "Abundance (FL reads, log10)"
  ) +
  theme(
    legend.position = "none",
    axis.title.y = element_text(size = 18, face = "bold", margin = margin(r = 20)),
    axis.title.x = element_text(size = 18, face = "bold", margin = margin(t = 20)),
    axis.text = element_text(size = 17, color = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )