@echo off

for %%f in (*.csv) do (
java -cp "F:\Program Files\Weka-3-6\weka.jar" weka.core.converters.CSVLoader %%~nf.csv > ..\weka\%%~nf.arff)