<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    internal protected void Application_BeginRequest(object sender, EventArgs e)
    {
        var url = ConfigurationManager.AppSettings["OrchardURL"];
        if (Request.RawUrl.ToLower().StartsWith("/images/"))
        {
            if (Request.RawUrl.ToLower().Contains(".aspx?"))
            {
                Response.ContentType = "image/png";
                var newUrl = url + Request.RawUrl;
                var wr = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(newUrl);
                wr.KeepAlive = false;
                wr.PreAuthenticate = true;
                wr.Method = "GET";
                wr.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1)";
                var resp = (System.Net.HttpWebResponse)wr.GetResponse();
                using (var str = resp.GetResponseStream())
                {
                    var buffer = new byte[1 * 1024 * 1024];
                    var read = str.Read(buffer, 0, buffer.Length);
                    while (read > 0)
                    {
                        Response.OutputStream.Write(buffer, 0, read);
                        read = str.Read(buffer, 0, buffer.Length);
                    }
                }
                Response.End();
            }
        }
        else if (Request.Path.ToLower().StartsWith("/service/")
            || Request.Path.ToLower().StartsWith("/layar/ccc.aspx")
            || Request.Path.ToLower().StartsWith("/checkCCC/ccccheck"))
        {
            string txt = "";
            var newUrl = url + Request.RawUrl;
            var wr = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(newUrl);
            wr.KeepAlive = false;
            wr.PreAuthenticate = true;
            wr.Headers.Set("Pragma", "no-cache");
            wr.ContentType = "text/text";
            wr.Method = "GET";
            wr.Headers.Add("Translate", "t");
            wr.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1)";
            var resp = (System.Net.HttpWebResponse)wr.GetResponse();
            using (var str = resp.GetResponseStream())
            {
                using (var reader = new System.IO.StreamReader(str))
                {
                    txt = reader.ReadToEnd();
                    Response.Write(txt);
                }
            }
            Response.End();
        }
        else
        {
            Response.RedirectPermanent(url + Request.RawUrl);
        }
    }

    void Application_Error(object sender, EventArgs e)
    {
    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }

</script>
