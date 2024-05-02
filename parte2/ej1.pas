program ej1;
const valorAlto = 9999;
type
  producto = record
    codigo: integer;
    nombre: string;
    precio: real;
    stock_actual: integer;
    stock_minimo: integer;
  end;
  det = record
    codigo: integer;
    unidades: integer;
  end;
  master = file of producto;
  detalle = file of det;

procedure leerMaestro(var maestro: master; var p: producto);
begin
  if (not eof(maestro)) then
    read(maestro, p)
  else
    p.codigo := valorAlto;
end;

procedure leerDetalle(var detalle: detail; var p: det);
begin
  if (not eof(detalle)) then
    read(detalle, p)
  else
    p.codigo := valorAlto;
end;

procedure actualizarMaestro(var maestro: master; var detalle: detail);
var
  p: producto;
  diario: det;
  esta: boolean;
begin
  reset(maestro);
  reset(detalle);
  leerDetalle(detalle, diario);
  while (diario.codigo <> valorAlto) do begin
    esta := false;
    leerMaestro(maestro, p);
    while (p.codigo <> valorAlto) and (not esta) do begin
      if (p.codigo = diario.codigo) then
        esta := true
      else
        leerMaestro(maestro, p);
    end;
    if (esta) then begin
      seek(maestro, filePos(maestro)-1);
      p.stock_actual := p.stock_actual - diario.unidades;
      write(maestro, p);
    end;
    leerDetalle(detalle, diario);
    seek(maestro, 0); // reinicia la posicion
  end;
  close(maestro);
  close(detalle);
end;

var
  maestro: master;
  detalle: detail;
begin
  assign(maestro, 'stock_productos.dat');
  assign(detalle, 'dia1.dat');
  actualizarMaestro(maestro, detalle);
end.
