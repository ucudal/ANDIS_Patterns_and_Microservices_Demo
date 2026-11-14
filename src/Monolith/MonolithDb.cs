// -----------------------------------------------------------------------
// <copyright file="MonolithDb.cs" company="Universidad Católica del Uruguay">
// Copyright (c) Análisis y diseño de aplicaciones II. Derechos reservados.
// </copyright>
// -----------------------------------------------------------------------

using Microsoft.EntityFrameworkCore;

namespace Ucu.Andis.Monolith;

public class MonolithDb : DbContext
{
    public MonolithDb(DbContextOptions<MonolithDb> options)
        : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<Product> Products => Set<Product>();
    public DbSet<Order> Orders => Set<Order>();
}
