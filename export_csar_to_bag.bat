@echo off
setlocal enabledelayedexpansion

echo Exporting CUBE surfaces only (Depth, Uncertainty bands)
set /p folder=Enter the path to the folder containing CSAR files: 

set carisBatch="C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

set "bands=--include-band Depth,Uncertainty"


for %%F in ("%folder%\*.csar") do (
    set "input=%%F"
    set "output=%%~dpnF.bag"
    set "metadata=%%~dpnF.bag.xml"
    echo Processing !input! to !output! with bands: !bands!
    set "abstract=%%~nF"
    rem Extract resolution (number between 'c' and 'm') from filename, default to 1 if not found
    set "resolution=1"
    for /f "tokens=2 delims=c" %%a in ("%%~nF") do (
        for /f "tokens=1 delims=m" %%b in ("%%a") do (
            set "resolution=%%b"
        )
    )
    call %carisBatch% --run ExportRaster --output-format BAG !bands! --abstract "!abstract!" --legal-constraints "unrestricted" --status ONGOING --vertical-datum "Mean Sea Level" --party-name "John Smith" --party-position "Project Manager" --party-organization CARIS --party-role PROCESSOR --notes "Additional notes" --security-constraints UNCLASSIFIED "!input!" "!output!"
    echo Exporting coverage metadata to !metadata!"
    call %carisBatch% --run ExportCoverageMetadata --metadata-profile BAG --uncertainty-type UNKNOWN --status ONGOING --vertical-datum "Mean Sea Level" --party-name "John Smith" --party-position "Project Manager" --party-organization CARIS --party-role PROCESSOR --legal-constraints TRADEMARK --abstract data --notes "Additional notes" --security-constraints UNCLASSIFIED "!input!" "!metadata!"
)

echo Done!
pause
