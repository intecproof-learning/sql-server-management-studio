using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
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
                //var paginas = context.
                //usp_ObtenerPaginasGetSalesAllClientsReport(100);

                ObjectParameter x = new ObjectParameter("totalItems", typeof(int));
                context.
usp_ObtenerPaginasGetSalesAllClientsReport_V2(100, x);

                //int pag = paginas.First().Value;
                int pag = 0;

                for (int i = 0; i < pag; i++)
                {
                    var result =
                        context.
                        ufn_GetSalesAllClientsReport(i * 100, 100);

                    foreach (var item in result)
                    {
                        Console.WriteLine(item.customerName);
                    }

                    Console.WriteLine("Oprima enter para pasar a la siguiente página");
                    Console.ReadLine();
                    Console.Clear();
                }
            }


            //using (AdventureWorks2019Entities context =
            //    new AdventureWorks2019Entities())
            //{
            //    try
            //    {
            //        context.usp_Ocurrencia("asdasdasd", "");
            //    }
            //    catch (Exception ex)
            //    {
            //        Console.WriteLine(ex.Message);
            //    }
            //}

            Console.ReadLine();
        }
    }
}
