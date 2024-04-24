program ej2;
type
  asistente = record
    numero: integer;
    nombre: string;
    email: string;
    telefono: integer;
    dni: integer;
  end;
  archivoAsistentes = file of asistente;

procedure leerAsistente(var a: asistente);
begin
  writeln('Ingrese el numero de asistente');
  readln(a.numero);
  if (a.numero <> -1) then begin
    writeln('Ingrese el nombre del asistente');
    readln(a.nombre);
    writeln('Ingrese el email del asistente');
    readln(a.email);
    writeln('Ingrese el telefono del asistente');
    readln(a.telefono);
    writeln('Ingrese el DNI del asistente');
    readln(a.dni);
  end;
end;

procedure cargarAsistentes(var asistentes: archivoAsistentes);
var
  a: asistente;
begin
  rewrite(asistentes);
  leerAsistente(a);
  while (a.numero <> -1) do begin
    write(asistentes, a);
    leerAsistente(a);
  end;
  close(asistentes);
end;

procedure eliminarAsistentes(var asistentes: archivoAsistentes);
var
  a: asistente;
begin
  reset(asistentes);
  read(asistentes, a);
  while (not eof(asistentes)) do begin
    while (a.numero > 1000) do
      read(asistentes, a);
    a.nombre := '@';
    seek(asistentes, filePos(asistentes)-1);
    write(asistentes, a);
  end;
  close(asistentes);
end;

var
  asistentes: archivoAsistentes;
begin
  assign(asistentes, 'asistentes.dat');
  cargarAsistentes(asistentes);
  eliminarAsistentes(asistentes);
end.