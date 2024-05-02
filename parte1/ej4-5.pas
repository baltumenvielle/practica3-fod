program ej4y5;
const valorAlto = 9999;
type
  reg_flor = record
    nombre: String[45];
    codigo: integer;
  end;
  tArchFlores = file of reg_flor;

procedure leer(var flores: tArchFlores; var f: reg_flor);
begin
  if (not eof(flores)) then
    read(flores, f)
  else
    f.codigo := valorAlto;
end;

procedure agregarFlor(var flores: tArchFlores; nombre: string; codigo: integer);
var
  f, cabecera: reg_flor;
begin
  f.nombre := nombre;
  f.codigo := codigo;
  reset(flores);
  read(flores, cabecera);
  if (cabecera.codigo = 0) then begin
    seek(flores, fileSize(flores));
    write(flores, f);
  end
  else begin
    seek(flores, (cabecera.codigo * -1));
    read(flores, cabecera); // toma la cabecera nueva
    seek(flores, filePos(flores)-1);
    write(flores, f); // escribe el nuevo registro
    seek(flores, 0);
    write(flores, cabecera); // actualiza la cabecera
  end;
  close(flores);
end;

procedure leerFlores(var flores: tArchFlores);
var
  nombre: string;
  codigo: integer;
begin
  writeln('Ingrese el nombre de la flor');
  readln(nombre);
  if (nombre <> 'ZZZ') then begin
    writeln('Ingrese el codigo de la flor');
    readln(codigo);
    agregarFlor(flores, nombre, codigo);
  end;
end;

procedure listarContenido(var flores: tArchFlores);
var
  f: reg_flor;
begin
  reset(flores);
  seek(flores, 1); // va directamente al primer elemento
  leer(flores, f);
  while (f.codigo <> valorAlto) do begin
    if (f.codigo > 0) then
      writeln(f.nombre);
    leer(flores, f);
  end;
  close(flores);
end;

procedure eliminarFlor(var flores: tArchFlores; f_borrar: reg_flor);
var
  f, cabecera: reg_flor;
  esta: boolean;
  pos: integer;
begin
  pos := 1;
  esta := false;
  reset(flores);
  read(flores, cabecera);
  leer(flores, f);
  while (f.codigo <> valorAlto) and (not esta) do begin
    if (f.codigo = f_borrar.codigo) and (f.nombre = f_borrar.nombre) then
      esta := true
    else begin
      leer(flores, f);
      pos := pos + 1;
    end;
  end;
  if (esta) then begin
    seek(flores, filePos(flores)-1);
    write(flores, cabecera); // se escribe la cabecera en el registro eliminado
    cabecera.codigo := pos * -1;
    seek(flores, 0);
    write(flores, cabecera);
    writeln('Se eliminó la flor');    
  end
  else
    writeln('No se encontro la flor a eliminar');
end;

var
  flores: tArchFlores;
  flor: reg_flor;
begin
  assign(flores, 'flores.dat');
  write
  leerFlores(flores);
  listarContenido(flores);
  flor.codigo := 999;
  flor.nombre := 'Cannabis';
  eliminarFlor(flores, flor);
end.