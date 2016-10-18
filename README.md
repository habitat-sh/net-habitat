# Net-Habitat

A research spike investigating isolated .Net framework enronments for running Habitat applications.

## Discusion

This readme is intended to explain the structure of the repo. For discussion around research approaches and outcomes see [discusion.md](discusion.md).

## framework

This is an "XCopied" .net framework directory. We want to load core framework libraries from this location instead of the global `%WINDIR%\Microsoft.Net\Framework` location.

Due to size, these files are ignored by git. The `Copy-Framework.ps1` bootstrapping script will populate this folder from a preinstalled runtime if it has not already been populated.

## net-apps

Contains individual .net applications intended to consume the framework in this repo. Ideally we want at least a simple cli and a asp.net web app represented here.

The top level `net-apps` folder contains a Visual Studio 2015 `.sln` file. The apps are created and built inside of Visual Studio.

## scripts

Powershell scripts to automate various tasks. Some may mimic what will eventually be done in Habitat and others may simply exist as convenience functionsn to automate tasks required for the research effort.

### Copy-Framework

This copies the officially installed 32 bit .net v4 Frameork folder to the local repo framework directory.

### Invoke-Cli

Invokes the CLI app and alters the .net `COMPLUS_InstallRoot` to use our isolated framework.

