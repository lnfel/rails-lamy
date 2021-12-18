@echo off

setlocal enableDelayedExpansion
cls
:: Initialize local environment variables

:: General
Set downloads_path=%USERPROFILE%\Downloads\
Set /p downloads_path="Downloads directory [default %USERPROFILE%\Downloads\]: "

:: Check downloads_path
if not exist %downloads_path% (
	echo %downloads_path% folder does not exist.
	exit /b 1
)

:: Winrar
Set item[0]=winrar
Set link[0]=https://www.rarlab.com/rar/winrar-x64-602.exe
Set filename[0]=winrar-x64-602.exe
Set dir[0]=%ProgramFiles%\WinRAR\
Set bin[0]=
Set extract[0]="%downloads_path%winrar-x64-602.exe" /S
Set app[0]=WinRAR.exe
Set method[0]=Installing

:: Ruby
Set item[1]=ruby
Set link[1]=https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.3-1/rubyinstaller-devkit-3.0.3-1-x64.exe
Set filename[1]=rubyinstaller-devkit-3.0.3-1-x64.exe
Set dir[1]=C:\Ruby30-x64\
Set bin[1]=bin\
Set extract[1]="%downloads_path%%filename[1]%" /verysilent /tasks='assocfiles,modpath'
Set app[1]=ruby.exe
Set method[1]=Installing

:: SQLite
Set item[2]=sqlite
Set link[2]=https://www.sqlite.org/2021/sqlite-dll-win64-x64-3370000.zip
Set filename[2]=sqlite-dll-win64-x64-3370000.zip
Set dir[2]=C:\Windows\System32\
Set bin[2]=
Set extract[2]="%dir[0]%%app[0]%" x -ibck %downloads_path%%filename[2]% *.* %dir[2]%
Set app[2]=sqlite3.dll
Set method[2]=Extracting

:: Nodejs
Set item[3]=nodejs
Set link[3]=https://nodejs.org/dist/v16.13.1/node-v16.13.1-x64.msi
Set filename[3]=node-v16.13.1-x64.msi
Set dir[3]=C:\Program Files\nodejs\
Set bin[3]=
Set extract[3]=msiexec.exe /i "%downloads_path%%filename[3]%" /passive
Set app[3]=node.exe
Set method[3]=Installing

:: Begin Setup
:: https://ss64.com/nt/for_l.html
for /L %%i in (0,1,3) do (
	echo [36mChecking[0m !item[%%i]!
	echo Checking !dir[%%i]!!bin[%%i]!!app[%%i]!
	if exist !dir[%%i]!!bin[%%i]!!app[%%i]! (
		echo [32mFound[0m !item[%%i]!
	) else (
		echo [33mDownloading[0m !item[%%i]!
		powershell -c "Invoke-WebRequest -Uri '!link[%%i]!' -OutFile '%downloads_path%!filename[%%i]!'"
		echo [32mDownloaded[0m !item[%%i]!

		echo [33m!method[%%i]![0m !item[%%i]!
		echo Runnning command: !extract[%%i]!
		!extract[%%i]!
		echo [32mInstalled[0m !item[%%i]!
	)
)

:: Setup MYSYS2 (Required for Ruby Devkit)
::call ridk install
::call ridk enable
::echo [32mEnabled[0m environment variables for MSYS2
call ridk exec pacman -S --needed --noconfirm autoconf autogen automake-wrapper diffutils file gawk grep libtool m4 make patch sed texinfo texinfo-tex wget mingw-w64-x86_64-binutils mingw-w64-x86_64-crt-git mingw-w64-x86_64-gcc mingw-w64-x86_64-gcc-libs mingw-w64-x86_64-headers-git mingw-w64-x86_64-libmangle-git mingw-w64-x86_64-libwinpthread-git mingw-w64-x86_64-make mingw-w64-x86_64-tools-git mingw-w64-x86_64-winpthreads-git pkgconf mingw-w64-x86_64-pkgconf
echo [32mInstalled[0m MSYS2 and MINGW development toolchain

:: Install npm packages
call npm install --global yarn
echo [32mInstalled[0m Yarn

:: Install Rails
call gem install rails --no-document
echo [32mInstalled[0m Rails

:: Verify Installations
::echo Ruby Version
::call ruby -v
::echo Node version
::call node -v
::echo Yarn version
::call yarn -v
::echo Rails version
:: Rails is dumb, it defaults to quitting the command prompt after running --version or --help
::call rails --version

:: Directory array
::Set directory[0]=

::for /L %%i in (0,1,0) do (
::	echo [36mChecking[0m !directory[%%i]!
::	for /F "Skip=2Tokens=1-2*" %%A in ('Reg Query HKCU\Environment /V PATH 2^>Nul') do (
::		Set user_path=%%C
::		echo !user_path!
::		echo !PATH! | find /C /I "!directory[%%i]!" > nul || SETX Path !user_path!!directory[%%i]!;
::	)
::)

pause