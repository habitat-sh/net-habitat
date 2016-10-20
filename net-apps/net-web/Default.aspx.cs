using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace net_web
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write(Environment.GetEnvironmentVariable("COMPLUS_InstallRoot"));
            Response.Write("<br/>");
            Response.Write(Environment.GetEnvironmentVariable("DEVPATH"));
            foreach (var asm in AppDomain.CurrentDomain.GetAssemblies())
            {
                Response.Write("<br/>");
                Response.Write(asm.FullName);
                Response.Write("<br/>");
                try { Response.Write(asm.CodeBase); } catch { }
            }
        }
    }
}