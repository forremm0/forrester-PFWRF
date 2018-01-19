

set tcl_precision 17

set runname PFWRF

#
# Import the ParFlow TCL package
#
lappend auto_path $env(PARFLOW_DIR)/bin 
package require parflow
namespace import Parflow::*
pfset FileVersion 4

pfset Process.Topology.P       24
pfset Process.Topology.Q       22
pfset Process.Topology.R       1

#-----------------------------------------------------------------------------
# Timing (time units is set by units of permeability)
#-----------------------------------------------------------------------------

pfset TimingInfo.BaseUnit			0.0002777777777777777777777777 ;# Must match the timestep unit for WRF! 1 s = 1/3600 hr
pfset TimingInfo.StartCount			0.0
pfset TimingInfo.StartTime			0.0
pfset TimingInfo.StopTime       	        10000
pfset TimingInfo.DumpInterval   	        -4 ;# We want it to dump out every hour = every 4 times PF is called
pfset TimeStep.Type			    	Constant
pfset TimeStep.Value				900 ;#Should be set by WRF, but set here also just in case.
					            ;#Subcycle = 150, at every 6 seconds this is ever 900 s, or every 0.25 hr

#----------------------------------------------------------------------------
# Time Cycles
#----------------------------------------------------------------------------
pfset Cycle.Names					 constant
pfset Cycle.constant.Names 			 "alltime"
pfset Cycle.constant.alltime.Length	 1
pfset Cycle.constant.Repeat 		-1

#-----------------------------------------------------------------------------
# Make a directory for the simulation and copy inputs into it
#-----------------------------------------------------------------------------

#Not doing this for WRF

#---------------------------------------------------------
# Computational Grid
#---------------------------------------------------------
pfset ComputationalGrid.Lower.X           0.0
pfset ComputationalGrid.Lower.Y           0.0
pfset ComputationalGrid.Lower.Z           0.0

pfset ComputationalGrid.NX                216
pfset ComputationalGrid.NY                132
pfset ComputationalGrid.NZ                5

pfset ComputationalGrid.DX	             1000.0
pfset ComputationalGrid.DY               1000.0
pfset ComputationalGrid.DZ               100.0

#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------
pfset GeomInput.Names                 "domaininput soilinput indi_input"

pfset GeomInput.domaininput.GeomName  domain
pfset GeomInput.domaininput.InputType  Box

pfset GeomInput.soilinput.GeomName soil
pfset GeomInput.soilinput.InputType  Box

#---------------------------------------------------------
# Domain Geometry 
#---------------------------------------------------------
pfset Geom.domain.Lower.X                        0.0
pfset Geom.domain.Lower.Y                        0.0
pfset Geom.domain.Lower.Z                        0.0
 
pfset Geom.domain.Upper.X                        216000.0
pfset Geom.domain.Upper.Y                        132000.0
pfset Geom.domain.Upper.Z                        500.0
pfset Geom.domain.Patches             "x-lower x-upper y-lower y-upper z-lower z-upper"

#---------------------------------------------------------
# Soil Geometry 
#---------------------------------------------------------
pfset Geom.soil.Lower.X                        0.0
pfset Geom.soil.Lower.Y                        0.0
pfset Geom.soil.Lower.Z                        100.0
 
pfset Geom.soil.Upper.X                        216000.0
pfset Geom.soil.Upper.Y                        132000.0
pfset Geom.soil.Upper.Z                        500.0

#-----------------------------------------------------------------------------
# Subsurface Indicator Geometry Input
#-----------------------------------------------------------------------------
pfset GeomInput.indi_input.InputType    IndicatorField
pfset GeomInput.indi_input.GeomNames    "s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 g1 g2 g3 g4 g5 g6 g7 g8 b1 b2"
pfset Geom.indi_input.FileName          "subsurface.indi.pfb"

pfset GeomInput.s1.Value    1
pfset GeomInput.s2.Value    2
pfset GeomInput.s3.Value    3
pfset GeomInput.s4.Value    4
pfset GeomInput.s5.Value    5
pfset GeomInput.s6.Value    6
pfset GeomInput.s7.Value    7
pfset GeomInput.s8.Value    8
pfset GeomInput.s9.Value    9
pfset GeomInput.s10.Value   10
pfset GeomInput.s11.Value   11
pfset GeomInput.s12.Value   12
pfset GeomInput.s13.Value   13

pfset GeomInput.g1.Value    21
pfset GeomInput.g2.Value    22
pfset GeomInput.g3.Value    23
pfset GeomInput.g4.Value    24
pfset GeomInput.g5.Value    25
pfset GeomInput.g6.Value    26
pfset GeomInput.g7.Value    27
pfset GeomInput.g8.Value    28
pfset GeomInput.b1.Value    19
pfset GeomInput.b2.Value    20


#--------------------------------------------
# variable dz assignments
#------------------------------------------
pfset Solver.Nonlinear.VariableDz  True 
pfset dzScale.GeomNames            domain
pfset dzScale.Type            nzList
pfset dzScale.nzListNumber       5

# 5 layers, starts at 0 for the bottom to 5 at the top
# note this is opposite Noah/WRF
# layers are 0.1 m, 0.3 m, 0.6 m, 1.0 m, 100 m
pfset Cell.0.dzScale.Value 1.0
# 100 m * .01 = 1m 
pfset Cell.1.dzScale.Value 0.01
# 100 m * .006 = 0.6 m 
pfset Cell.2.dzScale.Value .006
# 100 m * 0.003 = 0.3 m 
pfset Cell.3.dzScale.Value .003
# 100 m * 0.001 = 0.1m = 10 cm which is default top Noah layer
pfset Cell.4.dzScale.Value 0.001

#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------

pfset Geom.Perm.Names                 "domain s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 g1 g2 g3 g4 g5 g6 g7 g8 b1 b2"

# Values in m/hour

pfset Geom.domain.Perm.Type             Constant
pfset Geom.domain.Perm.Value            0.02

pfset Geom.s1.Perm.Type                 Constant
pfset Geom.s1.Perm.Value                0.269022595

pfset Geom.s2.Perm.Type                 Constant
pfset Geom.s2.Perm.Value                0.043630356

pfset Geom.s3.Perm.Type                 Constant
pfset Geom.s3.Perm.Value                0.015841225

pfset Geom.s4.Perm.Type                 Constant
pfset Geom.s4.Perm.Value                0.007582087

pfset Geom.s5.Perm.Type                 Constant
pfset Geom.s5.Perm.Value                0.01818816

pfset Geom.s6.Perm.Type                 Constant
pfset Geom.s6.Perm.Value                0.005009435

pfset Geom.s7.Perm.Type                 Constant
pfset Geom.s7.Perm.Value                 0.005492736

pfset Geom.s8.Perm.Type            Constant
pfset Geom.s8.Perm.Value           0.004675077

pfset Geom.s9.Perm.Type            Constant
pfset Geom.s9.Perm.Value           0.003386794

pfset Geom.s10.Perm.Type            Constant
pfset Geom.s10.Perm.Value           0.004783973

pfset Geom.s11.Perm.Type            Constant
pfset Geom.s11.Perm.Value           0.003979136

pfset Geom.s12.Perm.Type            Constant
pfset Geom.s12.Perm.Value           0.006162952

pfset Geom.s13.Perm.Type            Constant
pfset Geom.s13.Perm.Value           0.005009435


pfset Geom.b1.Perm.Type            Constant
pfset Geom.b1.Perm.Value           0.005

pfset Geom.b2.Perm.Type            Constant
pfset Geom.b2.Perm.Value           0.01


pfset Geom.g1.Perm.Type            Constant
pfset Geom.g1.Perm.Value           0.02

pfset Geom.g2.Perm.Type            Constant
pfset Geom.g2.Perm.Value           0.03

pfset Geom.g3.Perm.Type            Constant
pfset Geom.g3.Perm.Value           0.04

pfset Geom.g4.Perm.Type            Constant
pfset Geom.g4.Perm.Value           0.05

pfset Geom.g5.Perm.Type            Constant
pfset Geom.g5.Perm.Value           0.06

pfset Geom.g6.Perm.Type            Constant
pfset Geom.g6.Perm.Value           0.08

pfset Geom.g7.Perm.Type            Constant
pfset Geom.g7.Perm.Value           0.1

pfset Geom.g8.Perm.Type            Constant
pfset Geom.g8.Perm.Value           0.2

pfset Perm.TensorType               TensorByGeom
pfset Geom.Perm.TensorByGeom.Names  "domain soil"

pfset Geom.domain.Perm.TensorValX  1.0d0
pfset Geom.domain.Perm.TensorValY  1.0d0
pfset Geom.domain.Perm.TensorValZ  1.0d0

pfset Geom.soil.Perm.TensorValX  0.00001d0
pfset Geom.soil.Perm.TensorValY  0.00001d0
pfset Geom.soil.Perm.TensorValX  1.0d0
pfset Geom.soil.Perm.TensorValY  1.0d0
pfset Geom.soil.Perm.TensorValZ  1.0d0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type            Constant
pfset SpecificStorage.GeomNames       "domain"
pfset Geom.domain.SpecificStorage.Value 1.0e-5

#-----------------------------------------------------------------------------
# Phases
#-----------------------------------------------------------------------------

pfset Phase.Names "water"

pfset Phase.water.Density.Type	        Constant
pfset Phase.water.Density.Value	        1.0

pfset Phase.water.Viscosity.Type	Constant
pfset Phase.water.Viscosity.Value	1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------

pfset Contaminants.Names			""

#-----------------------------------------------------------------------------
# Retardation
#-----------------------------------------------------------------------------

pfset Geom.Retardation.GeomNames           ""

#-----------------------------------------------------------------------------
# Gravity
#-----------------------------------------------------------------------------

pfset Gravity				1.0

#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------
pfset Geom.Porosity.GeomNames           "domain s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 g1 g2 g3 g4 g5 g6 g7 g8"
#pfset Geom.Porosity.GeomNames           "domain"

pfset Geom.domain.Porosity.Type         Constant
pfset Geom.domain.Porosity.Value        0.33

pfset Geom.s1.Porosity.Type    Constant
pfset Geom.s1.Porosity.Value   0.375

pfset Geom.s2.Porosity.Type    Constant
pfset Geom.s2.Porosity.Value   0.39

pfset Geom.s3.Porosity.Type    Constant
pfset Geom.s3.Porosity.Value   0.387

pfset Geom.s4.Porosity.Type    Constant
pfset Geom.s4.Porosity.Value   0.439

pfset Geom.s5.Porosity.Type    Constant
pfset Geom.s5.Porosity.Value   0.489

pfset Geom.s6.Porosity.Type    Constant
pfset Geom.s6.Porosity.Value   0.399

pfset Geom.s7.Porosity.Type    Constant
pfset Geom.s7.Porosity.Value   0.384

pfset Geom.s8.Porosity.Type            Constant
pfset Geom.s8.Porosity.Value           0.482

pfset Geom.s9.Porosity.Type            Constant
pfset Geom.s9.Porosity.Value           0.442

pfset Geom.s10.Porosity.Type            Constant
pfset Geom.s10.Porosity.Value           0.385

pfset Geom.s11.Porosity.Type            Constant
pfset Geom.s11.Porosity.Value           0.481

pfset Geom.s12.Porosity.Type            Constant
pfset Geom.s12.Porosity.Value           0.459

pfset Geom.s13.Porosity.Type            Constant
pfset Geom.s13.Porosity.Value           0.399

pfset Geom.g1.Porosity.Type            Constant
pfset Geom.g1.Porosity.Value           0.33

pfset Geom.g2.Porosity.Type            Constant
pfset Geom.g2.Porosity.Value           0.33

pfset Geom.g3.Porosity.Type            Constant
pfset Geom.g3.Porosity.Value           0.33

pfset Geom.g4.Porosity.Type            Constant
pfset Geom.g4.Porosity.Value           0.33

pfset Geom.g5.Porosity.Type            Constant
pfset Geom.g5.Porosity.Value           0.33

pfset Geom.g6.Porosity.Type            Constant
pfset Geom.g6.Porosity.Value           0.33

pfset Geom.g7.Porosity.Type            Constant
pfset Geom.g7.Porosity.Value           0.33

pfset Geom.g8.Porosity.Type            Constant
pfset Geom.g8.Porosity.Value           0.33


#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------

pfset Domain.GeomName domain

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------

pfset Phase.RelPerm.Type               VanGenuchten
pfset Phase.RelPerm.GeomNames      "domain s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13"
#pfset Phase.RelPerm.GeomNames      "domain s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13"
#pfset Phase.RelPerm.GeomNames      "domain"

pfset Geom.domain.RelPerm.Alpha    1.
pfset Geom.domain.RelPerm.N        3.
pfset Geom.domain.RelPerm.NumSamplePoints   20000
pfset Geom.domain.RelPerm.MinPressureHead   -300
pfset Geom.domain.RelPerm.InterpolationMethod  Linear


pfset Geom.s1.RelPerm.Alpha        3.548
#pfset Geom.s1.RelPerm.Alpha        2.5
pfset Geom.s1.RelPerm.N            4.162
pfset Geom.s1.RelPerm.NumSamplePoints   20000
pfset Geom.s1.RelPerm.MinPressureHead   -300
pfset Geom.s1.RelPerm.InterpolationMethod  Linear


pfset Geom.s2.RelPerm.Alpha        3.467
pfset Geom.s2.RelPerm.N            2.738
pfset Geom.s2.RelPerm.NumSamplePoints   20000
pfset Geom.s2.RelPerm.MinPressureHead   -300
pfset Geom.s2.RelPerm.InterpolationMethod  Linear


pfset Geom.s3.RelPerm.Alpha        2.692
pfset Geom.s3.RelPerm.N            2.445
pfset Geom.s3.RelPerm.NumSamplePoints   20000
pfset Geom.s3.RelPerm.MinPressureHead   -300
pfset Geom.s3.RelPerm.InterpolationMethod  Linear


pfset Geom.s4.RelPerm.Alpha        0.501
pfset Geom.s4.RelPerm.N            2.659
pfset Geom.s4.RelPerm.NumSamplePoints   20000
pfset Geom.s4.RelPerm.MinPressureHead   -300
pfset Geom.s4.RelPerm.InterpolationMethod  Linear


pfset Geom.s5.RelPerm.Alpha        0.661
pfset Geom.s5.RelPerm.N            2.659
pfset Geom.s5.RelPerm.NumSamplePoints   20000
pfset Geom.s5.RelPerm.MinPressureHead   -300
pfset Geom.s5.RelPerm.InterpolationMethod  Linear


pfset Geom.s6.RelPerm.Alpha        1.122
pfset Geom.s6.RelPerm.N            2.479
pfset Geom.s6.RelPerm.NumSamplePoints   20000
pfset Geom.s6.RelPerm.MinPressureHead   -300
pfset Geom.s6.RelPerm.InterpolationMethod  Linear


pfset Geom.s7.RelPerm.Alpha        2.089
pfset Geom.s7.RelPerm.N            2.318
pfset Geom.s7.RelPerm.NumSamplePoints   20000
pfset Geom.s7.RelPerm.MinPressureHead   -300
pfset Geom.s7.RelPerm.InterpolationMethod  Linear


pfset Geom.s8.RelPerm.Alpha        0.832
pfset Geom.s8.RelPerm.N            2.514
pfset Geom.s8.RelPerm.NumSamplePoints   20000
pfset Geom.s8.RelPerm.MinPressureHead   -300
pfset Geom.s8.RelPerm.InterpolationMethod  Linear


pfset Geom.s9.RelPerm.Alpha        1.585
pfset Geom.s9.RelPerm.N            2.413
pfset Geom.s9.RelPerm.NumSamplePoints   20000
pfset Geom.s9.RelPerm.MinPressureHead   -300
pfset Geom.s9.RelPerm.InterpolationMethod  Linear


pfset Geom.s10.RelPerm.Alpha        3.311
#pfset Geom.s10.RelPerm.Alpha        2.
pfset Geom.s10.RelPerm.N            2.202
pfset Geom.s10.RelPerm.NumSamplePoints   20000
pfset Geom.s10.RelPerm.MinPressureHead   -300
pfset Geom.s10.RelPerm.InterpolationMethod  Linear


pfset Geom.s11.RelPerm.Alpha        1.622
pfset Geom.s11.RelPerm.N            2.318
pfset Geom.s11.RelPerm.NumSamplePoints   20000
pfset Geom.s11.RelPerm.MinPressureHead   -300
pfset Geom.s11.RelPerm.InterpolationMethod  Linear


pfset Geom.s12.RelPerm.Alpha        1.514
pfset Geom.s12.RelPerm.N            2.259
pfset Geom.s12.RelPerm.NumSamplePoints   20000
pfset Geom.s12.RelPerm.MinPressureHead   -300
pfset Geom.s12.RelPerm.InterpolationMethod  Linear


pfset Geom.s13.RelPerm.Alpha        1.122
pfset Geom.s13.RelPerm.N            2.479
pfset Geom.s13.RelPerm.NumSamplePoints   20000
pfset Geom.s13.RelPerm.MinPressureHead   -300
pfset Geom.s13.RelPerm.InterpolationMethod  Linear



#---------------------------------------------------------
# Saturation
#---------------------------------------------------------

pfset Phase.Saturation.Type              VanGenuchten
pfset Phase.Saturation.GeomNames         "domain s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13"
#pfset Phase.Saturation.GeomNames         "domain s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13"
#pfset Phase.Saturation.GeomNames         "domain"

pfset Geom.domain.Saturation.Alpha        1.
pfset Geom.domain.Saturation.N            3.
#pfset Geom.domain.Saturation.SRes         0.1
pfset Geom.domain.Saturation.SRes         0.001
pfset Geom.domain.Saturation.SSat         1.0

pfset Geom.s1.Saturation.Alpha        3.548
pfset Geom.s1.Saturation.N            4.162
pfset Geom.s1.Saturation.SRes         0.0001
#pfset Geom.s1.Saturation.SRes         0.1
pfset Geom.s1.Saturation.SSat         1.0

pfset Geom.s2.Saturation.Alpha        3.467
#pfset Geom.s2.Saturation.Alpha        2.5
pfset Geom.s2.Saturation.N            2.738
pfset Geom.s2.Saturation.SRes         0.0001
#pfset Geom.s2.Saturation.SRes         0.1
pfset Geom.s2.Saturation.SSat         1.0

pfset Geom.s3.Saturation.Alpha        2.692
pfset Geom.s3.Saturation.N            2.445
pfset Geom.s3.Saturation.SRes         0.0001
#pfset Geom.s3.Saturation.SRes         0.1
pfset Geom.s3.Saturation.SSat         1.0

pfset Geom.s4.Saturation.Alpha        0.501
pfset Geom.s4.Saturation.N            2.659
pfset Geom.s4.Saturation.SRes         0.0001
#pfset Geom.s4.Saturation.SRes         0.1
pfset Geom.s4.Saturation.SSat         1.0

pfset Geom.s5.Saturation.Alpha        0.661
pfset Geom.s5.Saturation.N            2.659
pfset Geom.s5.Saturation.SRes         0.0001
#pfset Geom.s5.Saturation.SRes         0.1
pfset Geom.s5.Saturation.SSat         1.0

pfset Geom.s6.Saturation.Alpha        1.122
pfset Geom.s6.Saturation.N            2.479
pfset Geom.s6.Saturation.SRes         0.0001
#pfset Geom.s6.Saturation.SRes         0.1
pfset Geom.s6.Saturation.SSat         1.0

pfset Geom.s7.Saturation.Alpha        2.089
pfset Geom.s7.Saturation.N            2.318
pfset Geom.s7.Saturation.SRes         0.0001
#pfset Geom.s7.Saturation.SRes         0.1
pfset Geom.s7.Saturation.SSat         1.0

pfset Geom.s8.Saturation.Alpha        0.832
pfset Geom.s8.Saturation.N            2.514
pfset Geom.s8.Saturation.SRes         0.0001
#pfset Geom.s8.Saturation.SRes         0.1
pfset Geom.s8.Saturation.SSat         1.0

pfset Geom.s9.Saturation.Alpha        1.585
pfset Geom.s9.Saturation.N            2.413
pfset Geom.s9.Saturation.SRes         0.0001
#pfset Geom.s9.Saturation.SRes         0.1
pfset Geom.s9.Saturation.SSat         1.0

pfset Geom.s10.Saturation.Alpha        3.311
#pfset Geom.s10.Saturation.Alpha        2.
pfset Geom.s10.Saturation.N            2.202
pfset Geom.s10.Saturation.SRes         0.0001
#pfset Geom.s10.Saturation.SRes         0.1
pfset Geom.s10.Saturation.SSat         1.0

pfset Geom.s11.Saturation.Alpha        1.622
pfset Geom.s11.Saturation.N            2.318
pfset Geom.s11.Saturation.SRes         0.0001
#pfset Geom.s11.Saturation.SRes         0.1
pfset Geom.s11.Saturation.SSat         1.0

pfset Geom.s12.Saturation.Alpha        1.514
pfset Geom.s12.Saturation.N            2.259
pfset Geom.s12.Saturation.SRes         0.0001
#pfset Geom.s12.Saturation.SRes         0.1
pfset Geom.s12.Saturation.SSat         1.0

pfset Geom.s13.Saturation.Alpha        1.122
pfset Geom.s13.Saturation.N            2.479
pfset Geom.s13.Saturation.SRes         0.0001
#pfset Geom.s13.Saturation.SRes         0.1
pfset Geom.s13.Saturation.SSat         1.0


#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names                           ""
 
#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------
pfset BCPressure.PatchNames                   [pfget Geom.domain.Patches]

pfset Patch.x-lower.BCPressure.Type		      FluxConst
pfset Patch.x-lower.BCPressure.Cycle		      "constant"
pfset Patch.x-lower.BCPressure.alltime.Value	      0.0

pfset Patch.y-lower.BCPressure.Type		      FluxConst
pfset Patch.y-lower.BCPressure.Cycle		      "constant"
pfset Patch.y-lower.BCPressure.alltime.Value	      0.0

pfset Patch.z-lower.BCPressure.Type		      FluxConst
pfset Patch.z-lower.BCPressure.Cycle		      "constant" 
pfset Patch.z-lower.BCPressure.alltime.Value	       0.0 

pfset Patch.x-upper.BCPressure.Type		      FluxConst
pfset Patch.x-upper.BCPressure.Cycle		      "constant"
pfset Patch.x-upper.BCPressure.alltime.Value	      0.0

pfset Patch.y-upper.BCPressure.Type		      FluxConst
pfset Patch.y-upper.BCPressure.Cycle		      "constant"
pfset Patch.y-upper.BCPressure.alltime.Value	      0.0

## overland flow boundary condition
pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		      "constant"
pfset Patch.z-upper.BCPressure.alltime.Value	     0.0 

#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------

pfset TopoSlopesX.Type "PFBFile"
pfset TopoSlopesX.GeomNames "domain"
pfset TopoSlopesX.FileName slopex.pfb


#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------

pfset TopoSlopesY.Type "PFBFile"
pfset TopoSlopesY.GeomNames "domain"
pfset TopoSlopesY.FileName   slopey.pfb

#---------------------------------------------------------
##  Distribute inputs
#---------------------------------------------------------

pfset ComputationalGrid.NZ                5
pfdist subsurface.indi.pfb
pfdist CO.2008.pfclm.out.press.04704.pfb
#pfdist PFWRF.out.press.02448.pfb
#pfdist PFWRF.out.press.02736.pfb

pfset ComputationalGrid.NZ                1
pfdist slopex.pfb
pfdist slopey.pfb

pfset ComputationalGrid.NZ                5

#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------

pfset Mannings.Type "Constant"
pfset Mannings.GeomNames "domain"
pfset Mannings.Geom.domain.Value 5.0e-5


#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------

pfset PhaseSources.water.Type                         Constant
pfset PhaseSources.water.GeomNames                    domain
pfset PhaseSources.water.Geom.domain.Value            0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                                    NoKnownSolution


#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------

pfset Solver                                             Richards
pfset Solver.MaxIter                                     2500000
pfset Solver.TerrainFollowingGrid                        True

pfset Solver.Nonlinear.MaxIter                           2000 
pfset Solver.Nonlinear.ResidualTol                       1e-5
pfset Solver.Nonlinear.EtaValue                          0.001

pfset Solver.PrintSubsurf								False
pfset Solver.Drop                                      1E-20
pfset Solver.AbsTol                                     1E-10
pfset Solver.MaxConvergenceFailures                       7

pfset Solver.Nonlinear.UseJacobian                      True 
pfset Solver.Nonlinear.DerivativeEpsilon                1e-16
pfset Solver.Nonlinear.StepTol				 			1e-20
pfset Solver.Nonlinear.Globalization                    LineSearch
pfset Solver.Linear.KrylovDimension                     500
pfset Solver.Linear.MaxRestarts                         8

pfset Solver.Linear.Preconditioner                       MGSemi
pfset Solver.Linear.Preconditioner                       PFMG
pfset Solver.Linear.Preconditioner.PCMatrixType     FullJacobian

pfset Solver.WriteSiloSubsurfData 					False 
pfset Solver.WriteSiloPressure 						False
pfset Solver.WriteSiloSaturation 					False
pfset Solver.WriteSiloConcentration 					False
pfset Solver.WriteSiloSlopes 						False
pfset Solver.WriteSiloMask 						False
pfset Solver.WriteSiloMannings                                          True
pfset Solver.WriteSiloEvapTrans                                         False

pfset Solver.PrintSubsurfData 						True 
pfset Solver.PrintSpecificStorage 					True 
pfset Solver.PrintMask 							True 
pfset Solver.PrintPressure 						True
pfset Solver.PrintSaturation 						True


#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

pfset ICPressure.Type                                 PFBFile
pfset ICPressure.GeomNames                            domain
pfset Geom.domain.ICPressure.RefPatch                   z-upper
pfset Geom.domain.ICPressure.FileName                   CO.2008.pfclm.out.press.04704.pfb
#pfset Geom.domain.ICPressure.FileName                 PFWRF.out.press.02736.pfb
#pfset Geom.domain.ICPressure.FileName                  PFWRF.out.press.02448.pfb

#-----------------------------------------------------------------------------
# Run and Unload the ParFlow output files
#-----------------------------------------------------------------------------

pfwritedb $runname
