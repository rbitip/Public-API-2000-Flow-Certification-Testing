# Public-API-2000-Flow-Certification-Testing

Data analysis of 6 manufacturers' pressure-vacuum flow certification protocols, detailed within the document "Analysis of Flowgroup Testing Data 04242020.pdf".

## requirements

In order to perform the analysis within SCFH_Anova.R, the following R packages are required:

readxl (Microsoft Excel), emmeans, EMSaov, here

## directory

* flow-cert.Rproj: R Project file for organizing files
* Analysis of Flowgroup Testing Data 04242020.pdf: document detailing the process and results of the analysis
* SCFH_Anova.R: analysis script file, analysis outputs in plots and tabular form (csv) - the plots are shown and explained in the document
* FlowData.xlsx: anonymized data collected from manufacturers, cleaned up and formatted for analysis

The following files contain the analysis outputs generated in the script file and displayed in the document:

* AOV_Pressure.csv
* AOV_Vacuum.csv
* Consensus_Pressure.csv
* Consensus_Vacuum.csv
* vendor_vs_consensus_Pressure.csv
* vendor_vs_consensus_Vacuum.csv
