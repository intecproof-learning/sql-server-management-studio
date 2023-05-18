using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ManejoErroresSQL
{
    internal class Program
    {
        static void Main(string[] args)
        {
            using (AdventureWorks2019Entities context =
                new AdventureWorks2019Entities())
            {
                try
                {
                    context.usp_Ocurrencia("asdasdasd", "");
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }

            Console.ReadLine();
        }
    }
}
