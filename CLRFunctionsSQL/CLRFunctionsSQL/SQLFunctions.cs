using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public static class SQLFunctions
{

    [Microsoft.SqlServer.Server.SqlFunction]
    public static int Ocurrencias(string str, string stre)
    {
        if (String.IsNullOrEmpty(str) == true ||
            String.IsNullOrEmpty(stre) == true)
            return 0;

        string[] s = new string[1];
        s[0] = stre;
        return str.Split(s, StringSplitOptions.None).Count() -1;
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static int PrimerCaracter(string str)
    {
        if (String.IsNullOrEmpty(str) == true)
            return 0;

        char primeraLetra = str[0];
        return str.Where(s => s == primeraLetra).Count();
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static string ObtenerHoraActualISO()
    {
        return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
    }
}