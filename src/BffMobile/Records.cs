// -----------------------------------------------------------------------
// <copyright file="Records.cs" company="Universidad Católica del Uruguay">
// Copyright (c) Análisis y diseño de aplicaciones II. Derechos reservados.
// </copyright>
// -----------------------------------------------------------------------

using System.Text.Json.Serialization;

namespace Ucu.Andis.BffMobile;

sealed record DetailRecord(
    [property: JsonPropertyName("product_name")] string ProductName,
    [property: JsonPropertyName("status")] string Status);
