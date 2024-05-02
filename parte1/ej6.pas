program ej6;
type
  prenda = record // se dispone
    cod_prenda: integer;
    descripcion: string;
    colores: string;
    tipo_prenda: string;
    stock: integer;
    precio_unitario: real;
  end;
  archivo = file of prenda; // se dispone

procedure leer(var arch: archivo; var p: prenda);
begin
  if (not eof(arch)) then
    read(arch, p)
  else
    p.cod_prenda := valorAlto;
end;

procedure bajas(var maestro, obsoletos: archivo);
var
  p_borrar, p: prenda;
  esta: boolean;
begin
  reset(maestro);
  reset(obsoletos);
  leer(obsoletos, p_borrar);
  while (p_borrar.cod_prenda <> valorAlto) do begin
    esta := false;
    leer(maestro, p);
    while (p.cod_prenda <> valorAlto) and (not esta) do begin
      if (p.cod_prenda = p_borrar.cod_prenda) then begin
        esta := true;
        p.stock := 0;
        seek(maestro, filePos(maestro)-1);
        write(maestro, p);
      end
      else
        leer(maestro, p);
    end;
    seek(maestro, 0);
    leer(obsoletos, p_borrar);
  end;
  close(maestro);
  close(obsoletos);
end;

procedure generarNuevoArchivo(var maestro, nuevoArchivo: archivo)
var
  p: prenda;
begin
  rewrite(nuevoArchivo);
  reset(maestro);
  leer(maestro, p);
  while (p.cod_prenda <> valorAlto) do begin
    if (p.codigo > 0) then
      write(nuevoArchivo, p);
    leer(maestro, p);
  end;
end;

var
  maestro, obsoletos, nuevoArchivo: archivo;
begin
  assign(maestro, 'prendas.dat');
  assign(obsoletos, 'prendas_actualizacion.dat');
  bajas(maestro, obsoletos);
  generarNuevoArchivo(maestro, nuevoArchivo);
  assign(nuevoArchivo, 'prendas.dat');
end.