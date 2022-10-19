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
            seedWorkers();

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

        static void seedWorkers()
        {
            using var db = new Projectcontext();
            Console.WriteLine("ADDING Frontend Team with workers");

            Team Frontend = new Team
            {
                Name = "Frontend"
            };
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Frontend,
                Worker = new Worker { Name = "Steen Secher" }
            });
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Frontend,
                Worker = new Worker { Name = "Ejvind Møller" }
            });
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Frontend,
                Worker = new Worker { Name = "Konrad Sommer" }
            });

            Console.WriteLine("ADDING Backend Team with workers");
            Team Backend = new Team
            {
                Name = "Backend"
            };

            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Backend,
                Worker = new Worker { Name = "Konrad Sommer" }
            });
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Backend,
                Worker = new Worker { Name = "Sofus Lotus" }
            });
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Backend,
                Worker = new Worker { Name = "Remo Lademann" }
            });

            Console.WriteLine("ADDING Testers Team with workers");
            Team Testers = new Team
            {
                Name = "Testers"
            };

            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Testers,
                Worker = new Worker { Name = "Ella Fanth" }
            });
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Testers,
                Worker = new Worker { Name = "Anna Dam" }
            });
            db.WorkerTeams.Add(new WorkerTeam
            {
                Team = Testers,
                Worker = new Worker { Name = "Steen Secher" }
            });

            db.SaveChanges();
        }

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