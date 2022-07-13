install.packages("tidyr")
install.packages("odbc")
install.packages("dplyr")
install.packages("dbplyr")
install.packages("readxl")
install.packages("stringr")

library(tidyr)
library(odbc)
library(dplyr)
library(dbplyr)
library(readxl)
library(stringr)

# Connect using the DSN
db <- DBI::dbConnect(odbc::odbc(), "RSQL_localhost",Database = "yf_workspace")

# Connect without a DSN
db <- DBI::dbConnect(odbc::odbc(),
                     Driver = 'RSQL_localhost',
                     Server = 'localhost',
                     Database = "yf_workspace",
                     trusted_connection = 'yes',
                     Port = 1433
)


excel_sheets("C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\Pargo Case Data.xlsx")


m_pickuppoints <- read_excel("C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\Pargo Case Data.xlsx", sheet = "Pickup Points")
m_parcels <- read_excel("C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\Pargo Case Data.xlsx", sheet = "Parcels")
m_customers <- read_excel("C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\Pargo Case Data.xlsx", sheet = "Customers")


# dbWriteTable(db, "m_customers", m_customers)
# dbWriteTable(db, "m_parcels", m_parcels)
# dbWriteTable(db, "m_pickuppoints", m_pickuppoints)



pickuppoints <- m_pickuppoints
parcels <- m_parcels
customers <- m_customers

length(unique(nchar(customers$`Customer ID`)))


data <- check %>%
  group_by(Waybill) %>%
  summarise(count = n(),
            character_count = nchar(Waybill))

character_count <- data %>%
  group_by(character_count) %>%
  summarise(count = n())

View(character_count)

#customer cell - format based on numbers
#province - kwazulu
#waybill - format based on numbers
#order date - change numeric to date format

## non numeric exceptions
#sales amount
#parcel kg




customers$`Customer Cell` <- str_replace_all(customers$`Customer Cell`, fixed(" "), "")
customers$`Customer Cell` <- str_replace_all(customers$`Customer Cell`, fixed("+"), "")


customers <- customers %>%
  mutate(`Customer Cell` = case_when(nchar(`Customer Cell`) == 9 ~ paste0('27',`Customer Cell`),
                                     TRUE ~ `Customer Cell`))


pickuppoints$Province <-  tolower(pickuppoints$Province)

pickuppoints <- pickuppoints %>%  
  mutate(Province = case_when(grepl('eastern', Province) ~ "Eastern Cape",
                                grepl('kwa', Province) ~ "KwaZulu-Natal",
                                grepl('free', Province) ~ "Free State",
                                grepl('western', Province) ~ "Western Cape",
                                grepl('gaute', Province) ~ "Gauteng",
                                grepl('limpo', Province) ~ "Limpopo",
                                grepl('mpuma', Province) ~ "Mpumalanga",
                                grepl('northen', Province) ~ "Northern Cape",
                                grepl('north wes', Province) ~ "North West")
         )
  
  

parcels <- parcels %>%
  mutate(Waybill = case_when(nchar(Waybill) == 17 ~ substr(Waybill,1,nchar(Waybill)-4),
                             nchar(Waybill) == 16 ~ substr(Waybill,1,nchar(Waybill)-3),
                             nchar(Waybill) == 15 & substr(Waybill,1,2) != '01' ~ substr(Waybill,1,nchar(Waybill)-2),
                             nchar(Waybill) == 15 & substr(Waybill,1,2) == '01' ~ substring(Waybill, 3),
                                     TRUE ~ Waybill)
  )

parcels$`Order Date` <- as.Date(parcels$`Order Date`, origin = "1899-12-30")
parcels$`Parcel KG` <- as.numeric(parcels$`Parcel KG`)
parcels$`Sales amount` <- as.numeric(parcels$`Sales amount`)




dbWriteTable(db, "customers", customers)
dbWriteTable(db, "parcels", parcels)
dbWriteTable(db, "pickuppoints", pickuppoints)

write.csv(customers, 'C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\transformed data\\customers.csv', row.names = FALSE)
write.csv(parcels, 'C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\transformed data\\parcels.csv', row.names = FALSE)
write.csv(pickuppoints, 'C:\\Users\\Yacoob.Fakier\\Documents\\Personal\\PG assignment\\datasets\\transformed data\\pickuppoints.csv', row.names = FALSE)




