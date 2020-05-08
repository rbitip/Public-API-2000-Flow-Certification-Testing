# Public-API-2000-Flow-Certification-Testing

Analysis of 6 manufacturers' pressure-vacuum flow certification protocols, detailed within the document "FlowCertTestingProgramFinalRpt_050820.pdf".

An overview of the report is given in the following video:

[![flow cert video](http://img.youtube.com/vi/qMuXS676pfA/0.jpg)](http://www.youtube.com/watch?v=qMuXS676pfA)

## instructions

If you don't know how to use git to clone repositories, you can access this repository with the following methods:

* You can view the PDF in your browser by clicking "FlowCertTestingProgramFinalRpt_050820.pdf" in the list of files above.
* You can download this entire repository by clicking the green "Clone or download" button and then selecting "Download zip" from the menu. ![clone button img](https://onedebos.files.wordpress.com/2019/07/images6088675361067318569.jpeg)

## requirements

In order to perform the analysis within SCFH_Anova.R, the following R packages are required:

readxl (Microsoft Excel), emmeans, EMSaov, here

## directory

* flow-cert.Rproj: R Project file for organizing files
* FlowCertTestingProgramFinalRpt_050820.pdf: document detailing the process and results of the analysis
* SCFH_Anova.R: analysis script file, analysis outputs in plots and tabular form (csv) - the plots are shown and explained in the document
* FlowData.xlsx: anonymized data collected from manufacturers, cleaned up and formatted for analysis

The following files contain the analysis outputs generated in the script file and displayed in the document:

* AOV_Pressure.csv
* AOV_Vacuum.csv
* Consensus_Pressure.csv
* Consensus_Vacuum.csv
* vendor_vs_consensus_Pressure.csv
* vendor_vs_consensus_Vacuum.csv
