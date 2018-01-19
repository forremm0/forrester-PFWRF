library(ncdf4)
library(ggplot2)
library(lattice)

#SNODAS SWE (mm) (-9999 = NA)
snodas = nc_open("G02158_88748_snow.sub.nc",write=FALSE)
snodas_snow = ncvar_get(nc=snodas,varid="Snow_Water_Equivalent_with_State_Model_variable_type")[,,5]
snodas_snow_att = ncatt_get(nc=snodas,varid="Snow_Water_Equivalent_with_State_Model_variable_type")
#Converts -9999 values to 0
snodas_snow[which(snodas_snow<0)]=0

#SNODAS snow depth (mm) (-9999 = NA)
snodas_snowh = ncvar_get(nc=snodas,varid="Snow_Depth_with_State_Model_variable_type")[,,5]
snodas_snowh_att = ncatt_get(nc=snodas,varid="Snow_Depth_with_State_Model_variable_type")
#Converts -9999 values to 0
snodas_snowh[which(snodas_snowh<0)]=0

#SNODAS latitude and longitude
snodas_lat = snodas$dim$latitude$vals
snodas_lon = snodas$dim$longitude$vals

#wrfinput SWE (kg m^-2, or mm)
wrfin = nc_open("originals/wrfinput_d02_s1",write=FALSE)
wrfin_snow = ncvar_get(nc=wrfin,varid="SNOW") 
wrfin_snow_att = ncatt_get(nc=wrfin,varid="SNOW")

#wrfinput snow depth (m)
wrfin_snowh = ncvar_get(nc=wrfin,varid="SNOWH") 
wrfin_snowh_att = ncatt_get(nc=wrfin,varid="SNOWH")

#wrfinput flag snow coverage (0 to 1 fractional snow coverage for that cell)
#SNOWC is calculated from snowpack but also on vegetation, so we will leave it alone
wrfin_snowc = ncvar_get(nc=wrfin,varid="SNOWC") 
wrfin_snowc_att = ncatt_get(nc=wrfin,varid="SNOWC")

#wrfinput latitude longitude
wrfin_lat = ncvar_get(nc=wrfin,varid="XLAT")
wrfin_lon = ncvar_get(nc=wrfin,varid="XLONG")

#quick look at wrf inputs
#levelplot(wrfin_snow)
#levelplot(wrfin_snowh)
#levelplot(wrfin_snowc)

#quick look at snodas 
#levelplot(snodas_snow)
#levelplot(snodas_snowh)

#####################################################################################
# Create the SWE grid (this will be the SNOW variable in kg/m^2, i.e. mm)
# Create the snow depth grid (the SNOWH variable in m)
#####################################################################################
x = length(wrfin_snow[,1])
y = length(wrfin_snow[1,])
snow = matrix(0,ncol=y,nrow=x)
snowh = matrix(0,ncol=y,nrow=x)

for(i in 1:length(wrfin_snow)){
  wlat = wrfin_lat[i]
  wlon = wrfin_lon[i]
  
  dist_lat = abs(wlat-snodas_lat)
  dist_lon = abs(wlon-snodas_lon)
  
  yindex = which(dist_lat==min(dist_lat))
  xindex = which(dist_lon==min(dist_lon))
  
  snow[i] = snodas_snow[xindex,yindex]
  snowh[i] = snodas_snowh[xindex,yindex]
}

elev = ncvar_get(nc=wrfin,varid="HGT") 
#levelplot(elev)
#levelplot(snow)
#levelplot(snowh)

print(dim(snow))
print(dim(wrfin_snow))

#####################################################################################
# Edit the wrfinput file
#####################################################################################
setwd("edited")
new_wrfinput = nc_open("green/wrfinput_d02_s1_edited_green",write=TRUE)

#snow_old = ncvar_get(nc=new_wrfinput,varid="SNOW")
#levelplot(snow_old)
ncvar_put(nc=new_wrfinput,varid="SNOW",vals=snow)
#snow_new = ncvar_get(nc=new_wrfinput,varid="SNOW")
#levelplot(snow_new)

