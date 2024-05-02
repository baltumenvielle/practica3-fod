program ej7;
const valorAlto = 9999;
type
  especie = record
    codigo: integer;
    nombre: string;
    familia: string;
    descripcion: string;
    zona: string;
  end;
  archivo = file of especie;

procedure leer(var especies: archivo; var e: especie);
begin
  if (not eof(especies)) then
    read(especies, e)
  else
    e.codigo := valorAlto;
end;

procedure eliminarAve(var especies: archivo; codigo: integer);
var
  e: especie;
  esta: boolean;
begin
  reset(especies);
  esta := false;
  leer(especies, e);
  while (e.codigo <> valorAlto) and (not esta) do begin
    if (e.codigo = codigo) then
      esta := true
    else
      leer(especies, e);
  end;
  if (esta) then begin
    seek(especies, filePos(especies)-1);
    e.codigo := -1;
    write(especies, e);
  end
  else
    writeln('No se encontro la especie con codigo ', codigo);
end;

procedure compactar(var especies: archivo);
var
  a, ultimo: especie;
  pos, tamanio: integer;
begin
  reset(especies);
  tamanio := fileSize(especies);
  pos := 0;
  leer(especies, a);
  while (a.codigo <> valorAlto) and (pos < tamanio) do begin
    if (a.codigo = -1) then begin
      pos := filePos(especies)-1; // pos actual
      seek(especies, tamanio);
      read(especies, ultimo); // lee el ultimo
      seek(especies, pos);
      write(especies, ultimo); // ultimo registro en eliminado
      tamanio := tamanio - 1;
    end;
    leer(especies, a);
    pos := pos + 1;
  end;
  seek(especies, tamanio);
  truncate(especies);
end;

var 
  especies: archivo;
  codigo: integer;
begin
  assign(especies, 'especies.dat');
  writeln('Ingrese el codigo de la especie del ave para eliminar');
  readln(codigo);
  while (codigo <> 500000) do begin
    eliminarAve(especies, codigo);
    writeln('Ingrese el codigo de la especie del ave para eliminar');
    readln(codigo);
  end;
  compactar(especies);
  close(especies);
end.