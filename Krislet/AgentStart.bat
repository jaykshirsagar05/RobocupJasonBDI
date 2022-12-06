cd .. 
start ./rcssserver-14.0.3-win/rcssserver.exe 
start ./rcssmonitor-14.1.0-win/rcssmonitor.exe

cd ./Krislet
start java -cp .;jason-2.3.jar Krislet -team BDI

cd ..
cd ./Krislet_old
start java Krislet -team Krislet
cd .. 

cd ./Krislet
@REM start java -cp .;jason-2.3.jar Krislet -team BDI -asl attacker.asl
@REM start java Krislet -team Carleton
@REM ping localhost
@REM ping localhost
@REM start java Krislet -team Carleton
@REM ping localhost
@REM start java Krislet -team Carleton
@REM ping localhost
@REM start java Krislet -team Carleton
@REM ping localhost
@REM start java Krislet -team Carleton
@REM ping localhost
@REM start java Krislet -team University
@REM ping localhost
@REM start java Krislet -team University
@REM ping localhost
@REM start java Krislet -team University
@REM ping localhost
@REM start java Krislet -team University
@REM ping localhost
@REM start java Krislet -team University
@REM ping localhost
