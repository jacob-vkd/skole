using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
namespace project
{

    public static class Program
    {

        static void Main()
        {
            seedTasks();

            using (Projectcontext context = new())
            {
                var tasks = context.Tasks.Include(task => task.Todos);
                foreach (var task in tasks)
                {
                    Console.WriteLine($"Task: { task.Name}");
                    foreach (var todo in task.Todos)
                    {
                        Console.WriteLine($"- {todo.Name}");
                    }

                }
            }

            printIncompleteTasksAndTodos();
        }

        static void seedTasks()
        {
            using var db = new Projectcontext();
            Console.WriteLine("ADDING TASK");
            db.Add(new Task
            {
                Name = "Produce software",
                Todos = new List<Todo>
            {
                new Todo { Name = "Write Code"},
                new Todo { Name = "Compile Source" },
                new Todo { Name = "Test program" }
            }
            });
            db.SaveChanges();

            Console.WriteLine("ADDING TASK");
            db.Add(new Task
            {
                Name = "Brew Coffee",
                Todos = new List<Todo>
            {
                new Todo { Name = "Pour Water"},
                new Todo { Name = "Pour coffee" },
                new Todo { Name = "Turn on" }
            }
            });
            db.SaveChanges();
        }
/*
        static void seedTeams()
        {
            using var db = new Projectcontext();
            Console.WriteLine("ADDING ADMIN USER");
            db.WorkerTeams.Add(new WorkerTeam
            {
                Workers = new List<Worker> { Name = "Korner" },
                Group = new Group { Name = "Administrator" }
            }) ;
            db.SaveChanges();
        }
*/
        static void printIncompleteTasksAndTodos()
        {
            Console.WriteLine("PRINTING INCOMPLETE TASKS");
            Console.WriteLine(" ");
            using (Projectcontext context = new())
            {

                var tasks = context.Tasks
                    .Include(task => task.Todos)
                    .Where(task => task.Todos.Any(task => task.IsComplete == false));

                foreach (var task in tasks)
                {
                    Console.WriteLine($"Task: { task.Name}");
                    foreach (var todo in task.Todos)
                    {
                        Console.WriteLine($"- {todo.Name}");
                    }

                }

            }
            Console.WriteLine(" ");
            Console.WriteLine("DONE PRINTING INCOMPLETE TASKS");

        }
    }
}