program ej8;
const valorAlto = 'ZZZ';
type
  distribucion = record
    nombre: string;
    lanzamiento: integer;
    kernel: integer;
    desarrolladores: integer;
    descripcion: string;
  end;
  archivo = file of distribucion;

procedure leer(var distribuciones: archivo; var d: distribucion);
begin
  if (not eof(distribuciones)) then
    read(distribuciones, d)
  else
    d.nombre := valorAlto;
end;

function ExisteDistribucion(var distribuciones: archivo; nombre: string): boolean;
var
  d, cabecera: distribucion;
  esta: boolean;
begin
  reset(distribuciones);
  esta := false;
  read(distribuciones, cabecera);
  leer(distribuciones, d);
  while (d.nombre <> valorAlto) and (not esta) do begin
    if (d.nombre = nombre) then
      esta := true
    else
      leer(distribuciones, d);
  end;
  close(distribuciones);
  ExisteDistribucion := esta;
end;

procedure leerDistribucion(var distribuciones: archivo; var d: distribucion);
begin
  writeln('Ingrese el nombre de la distribucion');
  readln(d.nombre);
  while (ExisteDistribucion(distribuciones, d.nombre)) do begin
    writeln('La distribucion ya existe. Ingrese otro nombre para agregar');
    readln(d.nombre);
  end;
  writeln('Ingrese el año de lanzamiento de la distribucion');
  readln(d.lanzamiento);
  writeln('Ingrese la version del kernel de la distribucion');
  readln(d.kernel);
  writeln('Ingrese la cantidad de desarrolladores de la distribucion');
  readln(d.desarrolladores);
  writeln('Ingrese la descripcion de la distribucion');
  readln(d.descripcion);
end;

procedure AltaDistribucion(var distribuciones: archivo);
var
  d_nueva, cabecera: distribucion;
begin
  reset(distribuciones);
  leerDistribucion(distribuciones, d_nueva);
  read(distribuciones, cabecera);
  if (cabecera.desarrolladores = 0) then begin
    seek(distribuciones, fileSize(distribuciones));
    write(distribuciones, d_nueva);
  end
  else begin
    seek(distribuciones, (cabecera.desarrolladores * -1));
    read(distribuciones, cabecera); // cabecera nueva
    seek(distribuciones, filePos(distribuciones)-1);
    write(distribuciones, d_nueva);
    seek(distribuciones, 0);
    write(distribuciones, cabecera);
  end;
  close(distribuciones);
end;

procedure BajaDistribucion(var distribuciones: archivo; distribucion: string);
var
  d, cabecera: distribucion;
  esta: boolean;
begin
  reset(distribuciones);
  if (ExisteDistribucion(distribuciones, distribucion)) then begin
    read(distribuciones, cabecera);
    leer(distribuciones, d);
    while (d.nombre <> distribucion) do
      leer(distribuciones, d);
    end;
    seek(distribuciones, filePos(distribuciones)-1);
    d.desarrolladores := 0;
  end
  else
    writeln('No hay distribucion con nombre ', distribucion);
  close(distribuciones);
end;

var
  distribuciones: archivo;
begin
  assign(distribuciones, 'distribuciones.dat');
  AltaDistribucion(distribuciones);
  BajaDistribucion(distribuciones);
end.