using System;
using System.Xml;
using System.Web.Management;

namespace net_cli
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Console.Out.WriteLine(Environment.GetEnvironmentVariable("COMPLUS_InstallRoot"));
            System.Console.Out.WriteLine(Environment.GetEnvironmentVariable("DEVPATH"));
            var x = new WmiWebEventProvider();
            var y = new XmlDataDocument();
            foreach (var asm in AppDomain.CurrentDomain.GetAssemblies())
            {
                Console.Out.WriteLine(asm.FullName);
                Console.Out.WriteLine(asm.CodeBase);
            }

            Console.In.ReadLine();
        }
    }
}
