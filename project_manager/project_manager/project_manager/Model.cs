using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;


public class Projectcontext : DbContext
{
    public DbSet<Todo> Todos { get; set; }
    public DbSet<Task> Tasks { get; set; }
    internal DbSet<Team>? Teams { get; set; }
    internal DbSet<Worker>? Workers { get; set; }
    internal DbSet<WorkerTeam>? WorkerTeams { get; set; }

    public string DbPath { get; }

    public Projectcontext()
    {
        var folder = Environment.SpecialFolder.LocalApplicationData;
        var path = Environment.GetFolderPath(folder);
        DbPath = System.IO.Path.Join(path, "project.db");

    }

    // The following configures EF to create a Sqlite database file in the
    // special "local" folder for your platform.
    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlite($"Data Source={DbPath}");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        

        modelBuilder.Entity<WorkerTeam>()
                    .HasKey(o => new { o.TeamId, o.WorkerId });
    }
}


public class Task
{
    public int TaskId { get; set; }
    public string Name { get; set; }
    public List<Todo> Todos { get; set; }

}

public class Todo
{
    public int TodoId { get; set; }
    public string Name { get; set; }
    public bool IsComplete { get; set; }

}

public class Team
{
    public int TeamId { get; set; }
    public string Name { get; set; }
    public List<Worker>? Workers { get; set; }
    public Task? CurrentTask { get; set; }
    public List<Task> Tasks { get; set; }


}

public class Worker
{
    public int WorkerId { get; set; }
    public string Name { get; set; }
    public List<Team> Teams { get; set; }
    public Todo? CurrentTodo { get; set; }
    public List <Todo>? Todos { get; set; }

}

public class WorkerTeam
{
    public int WorkerTeamId { get; set; }
    public int WorkerId { get; set; }
    public Worker? Worker { get; set; }
    public int TeamId { get; set; }
    public Team? Team { get; set; }

}
