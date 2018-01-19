library(lattice)
library(ncdf4)

#This is the maximum beetle overlay
fID <- read.csv("fID_table_beetle.txt")
beetle_list = fID[,3]
dim(beetle_list) = c(216,132)
beetle = which(beetle_list==1)


#But we only want 'beetles' that overlap with vergreen needleaf cells
#Load a wrfinput file to experiment with:
temp = nc_open("./edited_green/wrfrst_04-12_s1_edited_green")
lu_index = ncvar_get(temp,"LU_INDEX")
evergreen = which(lu_index==14)

landusef = ncvar_get(nc=temp,varid="LANDUSEF")

#Some statistics:
length(evergreen)
length(intersect(beetle,evergreen))
length(intersect(beetle,evergreen))/length(evergreen)
overlap = intersect(beetle,evergreen)

#Look at which land cover type isn't being used. This will be our "beetle" infestation
sort(unique(as.vector(lu_index)))
#Number 4 isn't being used

new_lu_index = lu_index
new_lu_index[overlap] = 4

levelplot(lu_index)
levelplot(new_lu_index)

ivgtyp = ncvar_get(temp,"IVGTYP")

######################## Now edit wrstput ###################
#We are ONLY editing grey phase
##############################################################
s1 = nc_open("./edited_grey/wrfrst_04-12_s1_edited_grey",write=T)
ncvar_put(nc=s1,varid="LU_INDEX",vals=new_lu_index)
nc_close(s1)

####################### Now edit ivgtyp ###################
s1 = nc_open("./edited_grey/wrfrst_04-12_s1_edited_grey",write=T)
ncvar_put(nc=s1,varid="IVGTYP",vals=new_lu_index)
nc_close(s1)

###################### Edit landusef ###################
#First, change the sum of all cells with lu_index=4 (so all beetle cells) to
#a sum of 0. This eliminates ALL prior land classification percentation
#for these cells
beetle = which(lu_index==4,arr.ind=T)
landusef_new = landusef

for(i in 1:length(landusef[1,1,])){
  layer = landusef[,,i]
  layer[beetle] = 0
  landusef_new[,,i] = layer
}

#Now all information is cleared at all beetle cells
#Place all % land cover for beetle cells at level 4 land classification
evergreen = landusef_new[,,14]
subst = landusef_new[,,4]
subst[beetle] = 1
landusef_new[,,4] = subst

#Check to make sure that all levels add to 1
sums = rep(0,216*132)
dim(sums) = c(216,132)
for(i in 1:216){
  for(j in 1:132){
    sums[i,j] = sum(landusef_new[i,j,])
  }
}
unique(as.vector(sums))

s1 = nc_open("./edited_grey/wrfrst_04-12_s1_edited_grey",write=T)
ncvar_put(nc=s1,varid="LANDUSEF",vals=landusef_new)
nc_close(s1)



