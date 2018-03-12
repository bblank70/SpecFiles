# SpecFiles
This is a script developed for R to process a time series of IR data


The script was developed for a Thermo/Nicolet IR. The time series was split into SPA files and then converted to CSV. 
R will read a directory filled with one time series and extract date/time from the file name, total adsorption, average adsorption, 
Oxygenate adsorption, and Water adsorption of each spectra. It constructs a dataframe of these values and then evaluates if a threshold 
signal has been observed in the IR. The first row identified above this threshold will be set at 0 time for the purpose of the experiment 
and a new dataframe will be generated which binds the columns mentioned previously with an additional column for time until/since the
threshold will/has happen(ed). Four summary plots will be generated.

