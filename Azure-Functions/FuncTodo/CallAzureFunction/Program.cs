using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace CallAzureFunction
{
    class Program
    {
        readonly static string _funcUrl = "https://slsfun01.azurewebsites.net/api/TodoApi?code=";
        static void Main(string[] args)
        {
            string code = ConfigurationManager.AppSettings["funcCode"];
            
            Console.Clear();
            Console.WriteLine("Select the task:");
            Console.WriteLine("Get all tasks, insert 0 : 0");
            Console.WriteLine("Get specific tasks, insert id : [1-9]");
            var task = Convert.ToInt32(Console.ReadLine());
            if (task == 0)
            {
                Run($"{_funcUrl}{code}");
            }
            else 
            {
                Run($"{_funcUrl}{code}&userid={task}");
            }

            
            Console.ReadLine();
        }
        public static async void Run(string url)
        {

            using (HttpClient endPoint = new HttpClient())
            using (HttpResponseMessage response = await endPoint.GetAsync(url, HttpCompletionOption.ResponseHeadersRead))
            using (HttpContent result = response.Content)
            {
                var data = await result.ReadAsStringAsync();
                //dynamic todoTask = JsonConvert.DeserializeObject(data);
                Console.WriteLine(data);
            }
                            
            Console.ReadLine();
        }
    }
}
