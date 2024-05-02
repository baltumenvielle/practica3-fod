program ej2;
const valorAlto = 9999;
type
  mesa = record
    codigo_localidad: integer;
    numero: integer;
    votos: integer;
  end;
  localidad = record
    codigo: string;
    votos: integer;
  end;
  archivoMesas = file of mesa;
  archivoLocalidades = file of localidad;

procedure leerLocalidad(var localidades: archivoLocalidades; var l: localidad);
begin
  if (not eof(localidades)) then
    read(localidades, l)
  else
    l.codigo := valorAlto;
end;

procedure leerMesa(var mesas: archivoMesas; var m: mesa);
begin
  if (not eof(mesas)) then
    read(mesas, m)
  else
    m.codigo_localidad := valorAlto;
end;

procedure inicializarLocalidades(var localidades: archivoLocalidades);
var
  aux: integer;
  l: localidad;
begin
  rewrite(localidades);
  writeln('Ingrese el codigo de la localidad');
  readln(aux);
  while (aux <> -1) do begin
    l.codigo := aux;
    l.votos := 0;
    write(localidades, l);
    writeln('Ingrese el codigo de la localidad');
    readln(aux);
  end;
  close(localidades);
end;

procedure contabilizarVotos(var mesas: archivoMesas; var localidades: archivoLocalidades);
var
  m: mesa;
  l: localidad;
begin
  reset(mesas);
  reset(localidades);
  leerMesa(mesas, m);
  while (m.codigo_localidad <> valorAlto) do begin
    seek(localidades, 0);
    leerLocalidad(localidades, l);
    while (l.codigo <> valorAlto) and (l.codigo <> m.codigo_localidad) do
      leerLocalidad(localidades, l);
    if (l.codigo = m.codigo_localidad) then
      l.votos := l.votos + m.votos;
    leerMesa(mesas, m);
  end;
  close(mesas);
  close(localidades);
end;

function votosTotales(var localidades: archivoLocalidades): integer;
var
  suma: integer;
  l: localidad;
begin
  reset(localidades);
  leerLocalidad(localidades, l);
  suma := 0;
  while (l.codigo <> valorAlto) do begin
    writeln('Cantidad de votos en la localidad con codigo ', l.codigo,': ', l.votos);
    suma := suma + l.votos;
    leerLocalidad(localidades, l);
  end;
  close(localidades);
  votosTotales := suma;
end;

var
  localidades: archivoLocalidades;
  mesas: archivoMesas;
begin
  assign(localidades, 'localidades.dat');
  assign(mesas, 'mesas.dat');
  inicializarLocalidades(localidades);
  contabilizarVotos(mesas, localidades);
  writeln('La cantidad de votos totales es de: ', votosTotales(localidades));
end.