# Public-API-2000-Flow-Certification-Testing

Analysis of 6 manufacturers' pressure-vacuum flow certification protocols, detailed within the documents "API2000FlowCertTG_Rpt1of2.pdf" and "API2000FlowCertTG_Rpt2of2.pdf".

An overview of the report (1 of 2) is given in the following video:

[![flow cert video 1](http://img.youtube.com/vi/qMuXS676pfA/0.jpg)](http://www.youtube.com/watch?v=qMuXS676pfA)

An overview of the report addendum (2 of 2) is given in the following video:

[![flow cert video 2](http://img.youtube.com/vi/81tRPgeHrpA/0.jpg)](https://www.youtube.com/watch?v=81tRPgeHrpA)

## instructions

If you don't know how to use git to clone repositories, you can access this repository with the following methods:

* You can view the PDFs in your browser by clicking their filename in the list of files above.
* You can download this entire repository by clicking the green "Clone or download" button and then selecting "Download zip" from the menu.

![clone button img](https://onedebos.files.wordpress.com/2019/07/images6088675361067318569.jpeg)

## requirements

In order to perform the analysis within SCFH_Anova.R, the following R packages are required:

readxl (Microsoft Excel), emmeans, EMSaov, here

## directory

* flow-cert.Rproj: R Project file for organizing files
* API2000FlowCertTG_Rpt1of2.pdf: document detailing the process and results of the analysis
* API2000FlowCertTG_Rpt2of2.pdf: addendum to the report
* API2000FlowCertTG_Rpt2of2_PwrPt.pdf: explanation of the report addendum
* SCFH_Anova.R: analysis script file, analysis outputs in plots and tabular form (csv) - the plots are shown and explained in the document
* FlowData.xlsx: anonymized data collected from manufacturers, cleaned up and formatted for analysis

The following files contain the analysis outputs generated in the script file and displayed in the document:

* AOV_Pressure.csv
* AOV_Vacuum.csv
* Consensus_Pressure.csv
* Consensus_Vacuum.csv
* vendor_vs_consensus_Pressure.csv
* vendor_vs_consensus_Vacuum.csv
