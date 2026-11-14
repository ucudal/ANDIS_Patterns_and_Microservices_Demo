// -----------------------------------------------------------------------
// <copyright file="Program.cs" company="Universidad Católica del Uruguay">
// Copyright (c) Análisis y diseño de aplicaciones II. Derechos reservados.
// </copyright>
// -----------------------------------------------------------------------

using Ucu.Andis.Common;
using Ucu.Andis.MessagingBridge;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddSingleton<RabbitMq>();
builder.Services.AddSingleton<LegacyBroker>();
builder.Services.AddHostedService<OrdersToErpBridge>();
builder.Services.AddHostedService<ErpToOrdersBridge>();
builder.Build().Run();

/// <summary>
/// Representa el Messaging Bridge, que conecta dos infraestructuras de mensajería:
/// RabbitMQ, la de la aplicación, y ActiveMQ, la del ERP.
/// </summary>
/// <remarks>
/// Ni Orders ni el ERP cambian: cada uno sigue hablando con su propio broker, y
/// ninguno sabe que el otro existe.
/// </remarks>
partial class Program { }
