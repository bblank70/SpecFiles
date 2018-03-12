
#If help is needed with this code call/text/email, Brian Blank @ (608)-316-6373; brian_blank@virent.com

#This portion of the code defines variables and paths of csv files
#After the code is run, the user will have to write a csv file to capture the summary
#change the path line to target the location of csv files you wish to summarize.

path<-directory
filenames<-list.files(path)
summary <- data.frame(ID=character(),col1=numeric(),col2=numeric(),col3=numeric(),stringsAsFactors=FALSE)

#This portion of the code initiates a a looping function; there are some important things in here related to syntax that need to be consistent.

	for (i in filenames){
		full = paste(path,i,sep="/")


#This establishes specfile as a call to each csv file

		Specfile<-read.csv(full, header= FALSE)
		
#This code calculates the average and total adsorbance of each csv file/spectra
		AvgA<-mean(Specfile[[2]])
		TotalA<-sum(Specfile[[2]])
		
#This is the spectral window for oxygenate peak related to acetone and acetic acid

		oxygenateH<-1200
		oxygenateL<-1170
		
#This code will extract the oxygenate portion of each csv file and store the maximum in this region in the variable Norm_Oxygenate

		oxygenate<-subset(Specfile, Specfile[[1]]>oxygenateL & Specfile[[1]]<oxygenateH)
		Norm_Oxygenate<-max(oxygenate[[2]])/AvgA
		
#This code extracts the date from each file name and converts from a character string to a time string.

		parsedate<-sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(full))
		Time<-as.POSIXct(parsedate, format = "%a %b %e %H-%M-%S %Y")
		
#This is the spectral window for water peak 

		waterH<-1490
		waterL<-1400
		
#This code will extract the water portion of each csv file and store the maximum in this region in the variable Norm_Water

		water<-subset(Specfile, Specfile[[1]]>waterL & Specfile[[1]]<waterH)
		Norm_Water<-max(water[[2]])/AvgA
		
#This code generates a logical response (T/F) based on a threshold critera of minimum  total spectral adsorbance		
	Threshold<-if (TotalA >110){
	Product = TRUE
	} else{
	Product = FALSE
	}
		
#This code tacks each individual file through the loop onto the end of the previous loop iteration. 

	temp_summary<-data.frame(Time, Norm_Water, Norm_Oxygenate, TotalA, AvgA, Product)
	summary<-rbind.data.frame(summary, temp_summary)

	
	
#For loop closure
}


#This will trim the summarry data frame to a new dataframe that meets the threshold product criteria
#Product = TRUE

trim_summary<-subset(summary, summary$Product == TRUE)
t0<-as.POSIXct(min(trim_summary[,1], na.rm= TRUE), format = "%Y-%m-%d %H:%M:%S")

#defining t= zero
temp_minutes<-c(trim_summary$Time-t0)
minutes<-temp_minutes/60
t0summary<-cbind.data.frame(trim_summary, minutes)

#builds plots for user to evaluate
plot(summary$Time, summary$Norm_Water)
plot(summary$Time, summary$Norm_Oxygenate)
plot(t0summary$minutes, t0summary$Norm_Water)
plot(t0summary$minutes, t0summary$Norm_Oxygenate)

