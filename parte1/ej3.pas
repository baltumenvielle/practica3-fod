program ej3;
type
  novela = record
    codigo: integer;
    genero: string;
    nombre: string;
    duracion: real;
    director: string;
    precio: real;
  end;
  archivoNovelas = file of novela;

procedure leerNovela(var n: novela);
begin
  writeln('Ingrese el codigo de la novela');
  readln(n.codigo);
  if (n.codigo <> -1) then begin
    writeln('Ingrese el genero de la novela');
    readln(n.genero);
    writeln('Ingrese el nombre de la novela');
    readln(n.nombre);
    writeln('Ingrese la duracion de la novela');
    readln(n.duracion);
    writeln('Ingrese el director de la novela');
    readln(n.director);
    writeln('Ingrese el precio de la novela');
    readln(n.precio);
  end;
end;

procedure crearArchivo(var novelas: archivoNovelas);
var
  n: novela
begin
  rewrite(novelas);
  n.codigo := 0;
  write(novelas, n);
  leerNovela(n);
  while (n.codigo <> -1) do begin
    write(novelas, n);
    leerNovela(n);
  end;
  close(novelas);
end;

procedure agregarNovela(var novelas: archivoNovelas);
var
  n: novela;
  aux: novela;
begin
  reset(novelas);
  read(novelas, aux);
  leerNovela(n);
  if (aux.codigo = 0) then begin
    seek(novelas, fileSize(novelas));
    write(novelas, n);
  end
  else begin
    seek(novelas, aux.codigo * -1);
    read(novelas, aux);
    seek(novelas, filePos(novelas)-1);
    write(novelas, n);
    seek(novelas, 0);
    write(novelas, aux);
  end;
  close(novelas);
end;

procedure modificarNovela(var novelas: archivoNovelas);
var
  n: novela;
  codigo: integer;
begin
  reset(novelas);
  writeln('Ingrese el codigo de una novela para modificar su contenido (no se debe modificar su codigo)');
  readln(codigo);
  read(novelas, n);
  while (not eof(novelas)) and (n.codigo <> codigo) do
    read(novelas, n);
  if (n.codigo = codigo) then begin
    leerNovela(n);
    seek(novelas, filePos(novelas)-1);
    write(novelas, n);
  end;
  else
    writeln('No se encontro la novela con codigo ', codigo);
  close(novelas);
end;

procedure eliminarNovela(var novelas: archivoNovelas);
var
  n, aux: novela;
  codigo: integer;
  ok: boolean;
begin
  reset(novelas);
  ok := false;
  writeln('Ingrese el codigo de una novela para eliminarla');
  readln(codigo);
  read(novelas, aux);
  while (not eof(novelas)) and (not ok) do
    read(novelas, n);
  if (n.codigo = codigo) then begin
    ok := true;
    seek(novelas, filePos(novelas)-1);
    write(novelas, aux);
    aux.codigo := (filePos(novelas)-1) * -1;
    seek(novelas, 0);
    write(novelas, aux);
  end
  else
    writeln('No se encontro la novela con codigo ', codigo);
  close(novelas);
end;

procedure listarNovelas(var novelas: archivoNovelas);
var
  n: novela;
  novelasTexto: text;
begin
  assign(novelasTexto, 'novelas.txt');
  rewrite(novelasTexto);
  reset(novelas);
  while (not eof(novelas)) do begin
    read(novelas, n);
    if (n.codigo > 0) then begin
      writeln(novelasTexto, n.codigo, ' ', n.duracion:1:1, ' ', n.precio:1:1);
      writeln(novelasTexto, n.genero);
      writeln(novelasTexto, n.nombre);
      write(novelasTexto, n.director);
    end;
  end;
  close(novelas);
  close(novelasTexto);
end;

var
  novelas: archivoNovelas;
  nombre: string;
  accion: integer;
begin
  writeln('Ingrese el nombre del archivo que contiene las novelas');
  readln(nombre);
  assign(novelas, nombre);
  writeln('Elija una de las siguientes opciones: 1. Crear y cargar el archivo de novelas, 2. Agregar una novela, 3. Modificar una novela, 4. Eliminar cierta novela, 5. Listar en un archivo todas las novelas');
  readln(accion);
  case accion of
    1: crearArchivo(novelas);
    2: agregarNovela(novelas);
    3: modificarNovela(novelas);
    4: eliminarNovela(novelas);
    5: listarNovelas(novelas);
end.