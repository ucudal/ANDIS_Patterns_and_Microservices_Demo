// -----------------------------------------------------------------------
// <copyright file="Product.cs" company="Universidad Católica del Uruguay">
// Copyright (c) Análisis y diseño de aplicaciones II. Derechos reservados.
// </copyright>
// -----------------------------------------------------------------------

using System.ComponentModel.DataAnnotations.Schema;

namespace Ucu.Andis.ProductsService.Models;

[Table("products")]
public class Product
{
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string? Name { get; set; }

    [Column("price")]
    public double Price { get; set; }

    /// <summary>
    /// Obtiene o establece las unidades disponibles.
    /// </summary>
    /// <remarks>
    /// Saga: lo cambian las reservas y las compensaciones -ver
    /// <c>StockReservations</c>- y <c>PUT /products/{id}/stock</c>.
    /// </remarks>
    [Column("stock")]
    public int Stock { get; set; }
}
