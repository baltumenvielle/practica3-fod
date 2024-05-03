program ej3;
const valorAlto = 9999;
type
  fech = record
    dia: integer;
    mes: integer;
    anio: integer;
  end;
  log = record
    cod_usuario: integer;
    fecha: fech;
    tiempo_total_de_sesiones_abiertas: real;
  end;
  det = record
    cod_usuario: integer;
    fecha: fech;
    tiempo_sesion: real;
  end;
  master = file of log;
  detail = file of det;
  vectorDetalles = array [1..5] of detail;
  vectorRegistros = array [1..5] of det;

procedure leerMaestro(var maestro: master; var l: log);
begin
  if (not eof(maestro)) then
    read(maestro, l);
  else
    d.cod_usuario := valorAlto;
end;

procedure leerDetalle(var detalle: detail; var d: det);
begin
  if (not eof(detalle)) then
    read(detalle, d)
  else
    d.cod_usuario := valorAlto;
end;

procedure minimo(var v: vectorDetalles; var r: vectorRegistros; var min: det);
var
  i, pos, minimo: integer;
begin
  minimo := 9999;
  for i:=1 to 5 do begin
    if (r[i].codigo < minimo) then begin
      minimo := r[i].codigo;
      pos := i;
    end;
  end;
  min := r[pos];
  leerDetalle(v[pos], r[pos]);
end;

procedure generarMaestro(var maestro: master; var v: vectorDetalles; var r: vectorRegistros);
var
  i: integer;
  l: log;
  min: det;
begin
  rewrite(maestro);
  for i:=1 to 5 do
    reset(v[i]);
  minimo(v, r, min);
  while (min.codigo <> valorAlto) do begin
    leerMaestro(maestro, l);
    while (l.cod_usuario <> valorAlto) and (l.cod_usuario <> min.cod_usuario) do
      leerMaestro(maestro, l);
    seek(maestro, filePos(maestro)-1);
    l.tiempo_total_de_sesiones_abiertas := l.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
    write(maestro, l);
    minimo(v, r, min);
  end;
  close(maestro);
  close(detalle);
end;

var
  maestro: master;
  v: vectorDetalles;
begin
  assign(maestro, 'log_semanal.dat');
  assign(v[1], 'maquina1.dat');
  assign(v[2], 'maquina2.dat');
  assign(v[3], 'maquina3.dat');
  assign(v[4], 'maquina4.dat');
  assign(v[5], 'maquina5.dat');
  generarMaestro(maestro, v);
end.