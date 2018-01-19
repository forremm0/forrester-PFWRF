library(ncdf4)
library(scales)
library(lattice)

#Read in original wrfinput files:
s1 = nc_open("wrfrst_04-12_s1")
s2 = nc_open("wrfrst_04-12_s2")
s3 = nc_open("wrfrst_04-12_s3")
s4 = nc_open("wrfrst_04-12_s4")
s5 = nc_open("wrfrst_04-12_s5")
s6 = nc_open("wrfrst_04-12_s6")
s7 = nc_open("wrfrst_04-12_s7")
s8 = nc_open("wrfrst_04-12_s8")

#Vars we need to perturb:
#P, T_PHYS, U_1, U_2, V_1, V_2, QVAPOR
#Variable to apply perturbation
varID = "T_PHYS"
alpha = 3

############################# original variable fields ###############################
s1_var = ncvar_get(s1,varID)
s2_var = ncvar_get(s2,varID)
s3_var = ncvar_get(s3,varID)
s4_var = ncvar_get(s4,varID)
s5_var = ncvar_get(s5,varID)
s6_var = ncvar_get(s6,varID)
s7_var = ncvar_get(s7,varID)
s8_var = ncvar_get(s8,varID)

mean_var = (s1_var + s2_var + s3_var + s4_var + s5_var + s6_var + s7_var + s8_var)/8
s1_diff = s1_var - mean_var
s2_diff = s2_var - mean_var
s3_diff = s3_var - mean_var
s4_diff = s4_var - mean_var
s5_diff = s5_var - mean_var
s6_diff = s6_var - mean_var
s7_diff = s7_var - mean_var
s8_diff = s8_var - mean_var

s1_new = s1_var + alpha*s1_diff
s2_new = s2_var + alpha*s2_diff
s3_new = s3_var + alpha*s3_diff
s4_new = s4_var + alpha*s4_diff
s5_new = s5_var + alpha*s5_diff
s6_new = s6_var + alpha*s6_diff
s7_new = s7_var + alpha*s7_diff
s8_new = s8_var + alpha*s8_diff

#Only for QVAPOR!
#s1_new[which(s1_new<0)] = 0.000000001
#s2_new[which(s2_new<0)] = 0.000000001
#s3_new[which(s3_new<0)] = 0.000000001
#s4_new[which(s4_new<0)] = 0.000000001
#s5_new[which(s5_new<0)] = 0.000000001
#s6_new[which(s6_new<0)] = 0.000000001
#s7_new[which(s7_new<0)] = 0.000000001
#s8_new[which(s8_new<0)] = 0.000000001

#Visualizing the
#plot(density(s1_var,from=0,to=0.0005))
#plot(density(s1_var))
#lines(density(s2_var),col="blue")
#lines(density(s3_var),col="green")
#lines(density(s4_var),col="yellow")
#lines(density(s5_var),col="purple")
#lines(density(s6_var),col="red")
#lines(density(s7_var),col="orange")
#lines(density(s8_var),col="darkgreen")


#plot(density(s1_new,from=0,to=0.0005))
#plot(density(s1_new))
#lines(density(s2_new),col="blue")
#lines(density(s3_new),col="green")
#lines(density(s4_new),col="yellow")
#lines(density(s5_new),col="purple")
#lines(density(s6_new),col="red")
#lines(density(s7_new),col="orange")
#lines(density(s8_new),col="darkgreen")


############## Replace the original with the perturbed value #################
s1_edit = nc_open("./edited/wrfrst_04-12_s1_edited",write=TRUE)
ncvar_put(nc=s1_edit,varid=varID,vals = s1_new)
nc_close(s1_edit)

s2_edit = nc_open("./edited/wrfrst_04-12_s2_edited",write=TRUE)
ncvar_put(nc=s2_edit,varid=varID,vals = s2_new)
nc_close(s2_edit)

s3_edit = nc_open("./edited/wrfrst_04-12_s3_edited",write=TRUE)
ncvar_put(nc=s3_edit,varid=varID,vals = s3_new)
nc_close(s3_edit)

s4_edit = nc_open("./edited/wrfrst_04-12_s4_edited",write=TRUE)
ncvar_put(nc=s4_edit,varid=varID,vals = s4_new)
nc_close(s4_edit)

s5_edit = nc_open("./edited/wrfrst_04-12_s5_edited",write=TRUE)
ncvar_put(nc=s5_edit,varid=varID,vals = s5_new)
nc_close(s5_edit)

s6_edit = nc_open("./edited/wrfrst_04-12_s6_edited",write=TRUE)
ncvar_put(nc=s6_edit,varid=varID,vals = s6_new)
nc_close(s6_edit)

s7_edit = nc_open("./edited/wrfrst_04-12_s7_edited",write=TRUE)
ncvar_put(nc=s7_edit,varid=varID,vals = s7_new)
nc_close(s7_edit)

s8_edit = nc_open("./edited/wrfrst_04-12_s8_edited",write=TRUE)
ncvar_put(nc=s8_edit,varid=varID,vals = s8_new)
nc_close(s8_edit)

#
