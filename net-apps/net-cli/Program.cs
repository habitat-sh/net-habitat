using System;
using System.Web.Management;

namespace net_cli
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Console.Out.WriteLine(Environment.GetEnvironmentVariable("COMPLUS_InstallRoot"));
            var x = new WmiWebEventProvider();
            foreach (var asm in AppDomain.CurrentDomain.GetAssemblies())
            {
                Console.Out.WriteLine(asm.FullName);
                Console.Out.WriteLine(asm.CodeBase);
            }
        }
    }
}
