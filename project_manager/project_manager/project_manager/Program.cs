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

        static void seedTasksToTeams()
        {
            using var db = new Projectcontext();
            Console.WriteLine("ADDING Tester Task");

            Task TestErpModule = new Task
            {
                Name = "Test Erp Module",
                Todos = new List<Todo>
                {
                    new Todo { Name = "Program test sofware"},
                    new Todo { Name = "Fix exception" },
                    new Todo { Name = "Check for sql injection" }
                }

            };

            db.Add(new Task
            {

            });

        }




        static void seedWorkers()
        {
            using var db = new Projectcontext();
            Console.WriteLine("ADDING Frontend Team with workers");

            Task ProgramFrontPage = new Task
            {
                Name = "Program the Frontpage",
                Todos = new List<Todo>
                {
                    new Todo { Name = "Program javascript for frontpage"},
                    new Todo { Name = "Check font colours" },
                    new Todo { Name = "Check mobile dimensions" }
                }

            };

            Team Frontend = new Team
            {
                Name = "Frontend",
                CurrentTask = ProgramFrontPage
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

            Task ProgramBackend= new Task
            {
                Name = "Program the Backend",
                Todos = new List<Todo>
                {
                    new Todo { Name = "Program new accounting module"},
                    new Todo { Name = "Fix error from unit test" },
                    new Todo { Name = "Check HR module for error reported by testing" }
                }

            };

            Console.WriteLine("ADDING Backend Team with workers");
            Team Backend = new Team
            {
                Name = "Backend",
                CurrentTask= ProgramBackend
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

            Task TestErpModule = new Task
            {
                Name = "Test Erp Module",
                Todos = new List<Todo>
                {
                    new Todo { Name = "Program test sofware"},
                    new Todo { Name = "Fix exception" },
                    new Todo { Name = "Check for sql injection" }
                }

            };

            Team Testers = new Team
            {
                Name = "Testers",
                CurrentTask = TestErpModule,
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