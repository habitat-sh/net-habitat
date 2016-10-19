# .net Isolation Research Goals

We want to provide the ability to build and run .net applications without concerns of the version of Windows or preinstalled .net framework versions.

The goal of this research is to determine to what extent can we isolate a .net framework Habitat package that has no dependency on any MSI or OS installed framework.

## Pointing to a different framework location on disk

An undocumented way to do this is to use the `COMPLUS_InstallRoot` environment variable and set it to a directory other than `$WINDIR%\Microsoft.Net\Framwork` (or Framework64).

The challenge here is you need an immediary to actually set the variable before invoking the process. There really is no other way that I can find to set it or configure it in the app itself. One reason might be because by the time the app is invoked, the runtime is already activated from the default location.

We can certainly get away with this via `hab pkg exec`. One thing to consider is that if `hab pkg exec` is NOT called, one should expect most .net apps to work against the default framework bits installed.

## GAC (Global Assembly Cache) redirection

Most .net code (BCL and user app code) does not live in the framework directory but lives in separate .Net assemblies. The BCL lives in the GAC as well as many popular .net based frameworks and sometimes (but rarely) user/app code too.

There is [a reference on the web](https://github.com/dotnet/coreclr/blob/32f0f9721afb584b4a14d69135bea7ddc129f755/Documentation/project-docs/clr-configuration-knobs.md) to several "undocumented" environment variables that impact various aspects of the CLR. The `COMPLUS_InstallRoot` mentioned above is included. It also mentions a `COMPLUS_AssemblyPath2` for specifying an alternate GAC location. I have not been succesful using that nor have I found any other way to redirect the GAC to a different location.

### Using `DEVPATH`

When .net attempts to resolve a needed assembly at run time, it follows [a known set of rules](https://msdn.microsoft.com/en-us/library/yx7xezcf(v=vs.110).aspx) to determe where to load the assembly from.

The GAC is the first place it looks. There is only one [documented](https://msdn.microsoft.com/en-us/library/cskzh7h6(v=vs.110).aspx) way to change this order by urning on `developmentMode`:

```
<configuration>
  <runtime>
    <developmentMode developerInstallation="true"/>
  </runtime>
</configuration>
```
and then setting the `DEVPATH` environment variable to the folder you prefer to load assemblies from.

According to the [documentation](https://msdn.microsoft.com/en-us/library/tyshaw37(v=vs.110).aspx) of the `developmentMode` config element, creating this GAC overridable location is the ONLY thing impacted by `developmentMode`.

Based on this we can determine all GAC based assemblies that a .net app depends on and copy those to the application local `bin` at build time.

I have confirmed that this works. If you build and run the .net cli app in this repo, you should not find any assemblies loaded from the system GAC.

## `COMPLUS_version` and msvcr120_clr0400.dll

As noted above, after applying the appropriate `COMPLUS_InstallRoot`, turning on `developmentMode` and setting the `DEVPATH`, one can see all asseblies being loaded from the isolated framework location. To further test anisolated framework scenario, I copied this repo and its v4 .net runtime bits to a vanilla 2008R2 machine with no v4 .net runtime installed. After invoking the net-cli.exe, .net immediately crashed.

Ther are two other items that must be set when transporting isolated .net runtime to a machine that does not have that version installed.

1. The native version of .net will try to determine the version of .net to be invoked. On 2008R2 this is v2. So it will then try to locate the framework bits in `/net-habitat/framework/v2.0.50727` which does not exist. Setting `COMPLUS_version` to v4.0.30319 will allow the correct framework directory to be loaded on a non v4 installed machine.

2. The clr C runtime dll `msvcr120_clr0400.dll` which lives in `%WINDIR%\system32` and `%WINDIR%\syswow64`. This file can be copied to the root of this repo or under `framework`/`framework64`.

After following both steps above, the executable ran on 2008R2.

## A note about discovering GAC'd assemblies

I don't think reflection will be a reliable method for discovering assemblies. The reason being that reflection will only find assemblies currently loaded and that means you'd have to "prime" the app to follow all code paths.

You could create a tree by traversing the [`GetReferencedAssemblies`](https://msdn.microsoft.com/en-us/library/system.reflection.assembly.getreferencedassemblies(v=vs.80).aspx) method of all loaded asseblies which theoretically should find everything. This API is available for .NET 2.0 and greater runtimes.

Another option is to scan project files for referenced assemblies.

I'm sure there are other methods as well we can experiment with.

[Steve] While I believe autodiscovering dependencies is going to be a big helper, there will always be a way that's hidden by conditional logic or some other pattern that is not discoverable at build time.  Ultimately, it becomes the plan author's responsibility to describe build and runtime dependencies.  