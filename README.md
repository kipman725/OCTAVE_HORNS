# OCTAVE_HORNS
Helper scripts for AKABAK3 using GNU OCTAVE 

Capabilites:
Draw rectangular horn meshes using horizontal and vertical guiding curves
Guiding curve generation for exponential-conic-conic horns

Software used:
GNU Octave, version 6.4.0
GMESH 4.8.4 
AKABAK 3.1.6 b86 (demo)

Getting started:
1) run exp_conic_conic_example.m this will generate 3 .stl files: horn (quarter horn surface), int (quarter box interface for use with IB boundry), source (quarter square source)
2) open these .stl files in gmesh and export them as version 2 ASIC .msh files
3) these .msh files can be opened in AKABAK3
