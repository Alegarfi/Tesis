setwd("~/Documentos/sradb/")
vignette('SRAdb')
library(SRAdb) #Cuando el paquete ya está instalado
sqlfile <- 'SRAmetadb.sqlite' #Primero debe asignarse el objeto aunque el archivo aún no se/
  ##haya cargado; el paquete así lo requiere 
sra_con <- dbConnect(SQLite(), sqlfile) #comando utilizado para enlazar el archivo SQlite con/
##/el que se trabajará. Para que funcione, hay que crear el objeto 'sqlfile'/

file.info('SRAmetadb.sqlite')##/Después de descargar el archivo, conviene aplicar este comando/
##para saber si es legible el archivo


sra_tables <- dbListTables(sra_con) #'dbListTables' enlista todas las tablas de la DB. Al 
  ##ejecutarlo, enlistará las tablas que tiene el archivo, así mismo, también genera el obj./
  ##/'sra_tables' que nos ha de sertvir posteriormente para buscar información de interés

dbListFields(sra_con,"sra_ft_content") #'dbListFields' enlista los campos asociados con la tabla/
  ##/al ejecutarlo, podemos ver los campos que pueden ser de interés, por ejempo,/
  ##/'dbListFields(sra_con,"metaInfo")' mostrará cuáles son los campos para 'metaInfo'

colDesc <- colDescriptions(sra_con=sra_con)[1:5,]
colDesc[, 1:4]


#####################################################
##ESCRIBIENDO CONSULTAS SQL Y OBTENIENDO RESULTADOS##
#####################################################
#Seleccionando tres archivos de la tabla 'study' y mostrando las primeras cinco columas
rs <- dbGetQuery(sra_con,"select * from sra_ft_content")
rs[, 1:3]

rs <- dbGetQuery(sra_con, paste( "select study_accession, study_title from study where",
                                   "study_description like 'Transcriptome%' ", sep=" "))
rs[1:3,]

rs <- dbGetQuery(sra_con, paste( "SELECT study_type AS StudyType, count( * ) AS Number FROM 'study' GROUP BY study_type order by Number DESC ", sep=""))


getTableCounts <- function(tableName,conn) {sql <- sprintf("select count(*) from %s",tableName)
      return(dbGetQuery(conn,sql)[1,1])}

do.call(rbind,sapply(sra_tables[c(2,4,5,11,12)], getTableCounts, sra_con, simplify=FALSE))

rs <- dbGetQuery(sra_con, paste( "SELECT study_type AS StudyType, 
count( * ) AS Number FROM `study` GROUP BY study_type order
by Number DESC ", sep=""))
rs

rs <- dbGetQuery(sra_con, paste( "SELECT instrument_model AS 'Instrument Model', 
count( * ) AS Experiments FROM 'experiment'GROUP BY instrument_model order 
by Experiments DESC", sep=""))
rs
