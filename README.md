# Multiresolution Analysis of Acoustic Data (MAAD)
The present codes report basic instructions to run the Multiresolution Analysis of Acoustic Diversity (MAAD) on audio. Written by Juan Sebastian Ulloa Museum national d'Histoire naturelle and Universite Paris-Saclay October 2017.

Supporting information for article: Ulloa, J.S., Aubin, T., Llusia, D., Bouveyron, C., Sueur, J., 2018. Estimating animal acoustic diversity in tropical environments using unsupervised multiresolution analysis. Ecological Indicators 90, 346–355. https://doi.org/10.1016/j.ecolind.2018.03.026


Basic system requirements are:
  - Matlab R2014b or later with ScatNet (v 0.2) toolbox. Scatnet toolbox can be downloaded from http://www.di.ens.fr/data/software/scatnet/download/
  - R version 3.3.2 (2016-10-31) or later with package HDclassif (v 2.0.2)

To run the analysis you need to switch between two software environments. For preprocessing, detection and characterisation of ROIs, and visualisation you need to use a Matlab console. For the clustering step, you need to use the R console. Check the step by step instructions document to run a guided analysis (step_by_step_instructions.pdf).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License http://www.gnu.org/licenses/. While due care has been taken and it is believed accurate, its use is solely the responsibilities of the user.

**IMPORTANT NOTE**: A new freeware Python module is under development, please check the following link for updates on this project: 
https://github.com/scikit-maad/scikit-maad
