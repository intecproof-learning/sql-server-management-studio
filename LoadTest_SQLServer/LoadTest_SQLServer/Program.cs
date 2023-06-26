using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LoadTest_SQLServer
{
    internal class Program
    {
        static void Main(string[] args)
        {
            while (true)
            {
                Random rnd = new Random();
                int query = rnd.Next(1, 3);

                using (AdventureWorksEntities2 context =
                    new AdventureWorksEntities2())
                {
                    //Llamamos al SP de la CTE
                    if (query == 1)
                    {
                        var beids = context.Person
                            .Select(p => p.BusinessEntityID)
                            .ToList();

                        //Console.WriteLine(beids.Max());
                        //Console.WriteLine(beids.Min());

                        var result =
                        context.usp_GetSalesByClientReport_LoadTest
                        (rnd.Next(beids.Min(), beids.Max() + 1))
                        .ToList();
                    }
                    //Llamamos al SP de ProductVendors
                    else
                    {
                        var productIDs = context.Product
                            .Select(p => p.ProductID)
                            .ToList();

                        //Console.WriteLine(productIDs.Max());
                        //Console.WriteLine(productIDs.Min());

                        var result =
                        context.usp_GetProductVendors_LoadTest
                        (rnd.Next(productIDs.Min(), productIDs.Max() + 1))
                        .ToList();
                    }
                }
            }

            Thread.Sleep(500);
        }
    }
}