using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;

namespace FuncTodo
{
    public static class TodoApi
    {
        [FunctionName("TodoApi")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            
            string userId = req.Query["userId"];
            string url = String.IsNullOrEmpty(userId) ?  "https://jsonplaceholder.typicode.com/todos" : $"https://jsonplaceholder.typicode.com/todos/{userId}";
            dynamic todoTask;

            log.LogInformation("Reading api...");

            using (HttpClient endPoint = new HttpClient())
            using (HttpResponseMessage response = await endPoint.GetAsync(url, HttpCompletionOption.ResponseHeadersRead))
            using (HttpContent result = response.Content)
            {
                var data = await result.ReadAsStringAsync();
                todoTask = JsonConvert.DeserializeObject(data);
                
            }
            
            return new OkObjectResult(todoTask);
        }
    }
}
