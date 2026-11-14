#!/bin/sh
# Filtro de Doxygen para los .md. GitHub dibuja las fórmulas escritas como $…$ y
# en bloques ```math, pero Doxygen no las reconoce: además, convierte \% en %, y
# en TeX % empieza un comentario. El filtro las pasa a la sintaxis de Doxygen,
# \f$…\f$ y \f[…\f], cuyo contenido llega a MathJax sin cambios. Los bloques de
# código y el código en línea no se tocan.
#
# Además, Doxygen enlaza solo cada mención de ARCHITECTURE.md, PATTERNS.md o
# README.md a la página del archivo, que está vacía, y no a la del documento.
# El filtro les antepone %, que Doxygen no muestra, para que no las enlace;
# los enlaces explícitos a esos documentos siguen funcionando.
#
# README.md no está en el sitio: los enlaces a README.md, y a sus secciones,
# pasan al README en GitHub.
#
# En los avisos de GitHub, como > [!TIP], la línea > vacía que sigue al tipo
# GitHub la ignora, pero Doxygen la muestra como un renglón vacío al principio
# del recuadro. El filtro la quita.
#
# Doxygen convierte en enlace toda URL, aunque esté en código en línea, como
# `http://localhost`; GitHub no. El filtro le antepone %, que Doxygen no
# muestra, para que quede como código. Lo mismo hace con ARCHITECTURE.md,
# PATTERNS.md y README.md en código en línea: Doxygen los enlazaría a la página
# vacía del archivo.
#
# En los enlaces a secciones, como [*worker*](PATTERNS.md#…) o [*sidecar*](#…),
# Doxygen muestra el texto sin procesar, con los asteriscos. El filtro cambia la
# cursiva de ese texto por <em>…</em>, que Doxygen sí respeta.
#
# Las rayas de las aclaraciones, —así—, las cambia por guiones de no separación
# el workflow hyphens.yaml, pero en un commit propio, que no vuelve a publicar
# el sitio. El filtro hace el mismo cambio, para que el sitio no dependa de ese
# commit.
#
# Si el texto alternativo de una imagen ocupa más de una línea, Doxygen corta el
# pie de la figura en el salto y muestra el resto como texto suelto, repetido.
# El filtro une esas líneas.
#
# Doxygen no reconoce una cursiva pegada a un guion de no separación, como
# ‑*on premises*‑, y muestra los asteriscos; GitHub sí la reconoce. El filtro
# cambia esa cursiva por <em>…</em>, también cuando todavía está pegada a una
# raya.
perl -0777 -pe '
  my @parts = split /(^```[^\n]*\n.*?^```[^\n]*$)/ms;
  for my $i (0 .. $#parts) {
    if ($i % 2) {
      $parts[$i] =~ s/^```math[^\n]*\n(.*?)^```[^\n]*$/\\f[\n$1\\f]/ms;
    } else {
      $parts[$i] =~ s/^(> \[!\w+\]\n)>[ \t]*\n/$1/mg;
      $parts[$i] =~ s{!\[([^\]]*)\]\(}{my $a = $1; $a =~ s/[ \t]*\n[ \t]*/ /g; "![$a]("}ge;
      my @spans = split /(`[^`\n]*`)/, $parts[$i];
      for my $j (0 .. $#spans) {
        if ($j % 2) {
          $spans[$j] =~ s{(?<!%)(https?://)}{%$1}g;
          $spans[$j] =~ s/(?<![\w\/%])((?:ARCHITECTURE|PATTERNS|README)\.md)(?![\w#])/%$1/g;
          next;
        }
        $spans[$j] =~ s/\$([^\s\$](?:[^\$\n]*[^\s\$])?)\$/\\f\$$1\\f\$/g;
        $spans[$j] =~ s/(?<![\w\/%(.\[])((?:ARCHITECTURE|PATTERNS|README)\.md)(?![\w)#])/%$1/g;
        $spans[$j] =~ s{\[([^\[\]]*)\](?=\((?:#|[\w-]+\.md#))}{my $t = $1; $t =~ s/(?<!\*)\*([^*\s](?:[^*]*[^*\s])?)\*(?!\*)/<em>$1<\/em>/g; "[$t]"}ge;
        $spans[$j] =~ s/(?<=‑|—)\*([^*\n]+?)\*/<em>$1<\/em>/g;
        $spans[$j] =~ s/(?<!\*)\*([^*\s][^*\n]*?)\*(?=‑|—)/<em>$1<\/em>/g;
        $spans[$j] =~ s{\]\(README\.md(#[^)\s]+)?\)}{](https://github.com/ucudal/ANDIS_Patterns_and_Microservices_Demo/blob/main/README.md$1)}g;
      }
      $parts[$i] = join "", @spans;
    }
  }
  $_ = join "", @parts;
  s/(?<![ |])—|—(?![ |])/‑/g;
' "$1"
