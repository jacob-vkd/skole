using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
namespace project
{

    public static class Program
    {
        /*
        // Note: This sample requires the database to be created before running.
        Console.WriteLine($"Database path: {db.DbPath}.");

        // Create
        Console.WriteLine("Inserting a new Task");
        db.Add(new Task {Name = "Test Task"});
        db.SaveChanges();

        // Read
        Console.WriteLine("Querying for a Task");
        var Task = db.Tasks
            .OrderBy(b => b.TaskId)
            .First();

        // Update
        Console.WriteLine("Updating the task and adding a todo");
        db.Tasks.Add(
            new Task { Name = "Test Task"});
        db.SaveChanges();

        // Delete
        Console.WriteLine("Delete the Task");
        db.Remove(Task);
        db.SaveChanges();

        */

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
    }
}