program ej1;
type
  empleado = record
    numero: integer;
    apellido: string;
    nombre: string;
    edad: integer;
    dni: integer;
  end;
  archivoEmpleados = file of empleado;

procedure cargarEmpleado(var e: empleado);
begin
  writeln('Ingrese el apellido del empleado');
  readln(e.apellido);
  if (e.apellido <> 'fin') then begin
    writeln('Ingrese el nombre del empleado');
    readln(e.nombre);
    writeln('Ingrese el numero de empleado');
    readln(e.numero);
    writeln('Ingrese la edad del empleado');
    readln(e.edad);
    writeln('Ingrese el DNI del empleado');
    readln(e.dni);
  end;
end;

procedure listarEmpleado(e: empleado);
begin
  if (e.apellido <> 'fin') then begin
    writeln(e.numero);
    writeln(e.nombre);
    writeln(e.apellido);
    writeln(e.edad);
    writeln(e.dni);
  end;
end;

procedure opcion1(var empleados: archivoEmpleados);
var
  e: empleado;
  nombre: string;
begin
  writeln('Ingrese un nombre o apellido determinado');
  readln(nombre);
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.apellido = nombre) or (e.nombre = nombre) then  
      listarEmpleado(e);
  end;
end;

procedure opcion2(var empleados: archivoEmpleados);
var
  e: empleado;
begin
  while (not eof(empleados)) do begin
    read(empleados, e);
    listarEmpleado(e);
  end;
end;

procedure opcion3(var empleados: archivoEmpleados);
var
  e: empleado;
begin
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.edad > 70) then
      listarEmpleado(e);
  end;
end;

procedure opcion4(var empleados: archivoEmpleados);
var
  e, ref: empleado;
  esta: boolean;
begin
  esta := false;
  cargarEmpleado(e);
  while (e.apellido <> 'fin') do begin
    while (e.apellido <> 'fin') and (not eof(empleados)) and (not esta) do begin // comprueba si existe un empleado con el mismo numero de empleado que se quiere insertar
      read(empleados, ref);
      if (e.numero = ref.numero) then
        esta := true;
    end;
    if (not esta) then begin
      write(empleados, e);
      cargarEmpleado(e);
    end;
  end;
end;

procedure opcion5(var empleados: archivoEmpleados);
var
  e: empleado;
  numero, edad: integer;
  fin: boolean;
begin
  fin := false;
  writeln('Ingrese el numero del empleado del que quiera modificar la edad');
  readln(numero);
  while (not eof(empleados)) and (not fin) do begin
    read(empleados, e);
    if (e.numero = numero) then begin
      writeln('Ingrese a la edad que quiera actualizar al empleado con numero ', numero);
      readln(edad);
      e.edad := edad;
      fin := true;
    end;
    seek(empleados, filePos(empleados)-1);
    write(empleados, e);
  end;
end;

procedure opcion6(var empleados: archivoEmpleados);
var
  textoEmpleados: text;
  e: empleado;
begin
  assign(textoEmpleados, 'todos_empleados.txt');
  rewrite(textoEmpleados);
  while (not eof(empleados)) do begin
    read(empleados, e);
    with e do
      writeln(textoEmpleados, numero, ' ', apellido, ' ', nombre, ' ', dni, ' ', edad);
  end;
  close(textoEmpleados);
end;  

procedure opcion7(var empleados: archivoEmpleados);
var
  e: empleado;
  textoEmpleados: text;
begin
  assign(textoEmpleados, 'faltaDNIEmpleado.txt');
  rewrite(textoEmpleados);
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.dni = 0) then begin
      with e do
        writeln(textoEmpleados, numero, ' ', apellido, ' ', nombre, ' ', dni, ' ', edad);
    end;
  end;
  close(textoEmpleados);
end;

procedure opcion8(var empleados: archivoEmpleados);
var
  num: integer;
  e, ultimoEmp: empleado;
begin
  reset(empleados);
  seek(empleados, fileSize(empleados)-1);
  read(empleados, ultimoEmp);
  writeln('Ingrese el numero de empleado a eliminar');
  readln(num);
  seek(empleados, 0);
  read(empleados, e);
  while (not eof(empleados)) and (e.numero <> num) do begin
    read(empleados, e);
  if (e.numero = num) then begin
    seek(empleados, filePos(archivo)-1);
    write(empleados, ultimoEmp);
    seek(empleados, fileSize(archivo)-1);
    truncate(empleados);
  end
  else
    writeln('No se encontro el empleado con codigo ', num);
end;

var
  empleados: archivoEmpleados;
  accion: integer;
begin
  assign(empleados, 'empleados.dat');
  reset(empleados); // se abre el archivo
  writeln('Ingrese la accion que se quiera hacer: 1. Listar ciertos empleados, 2. Listar todos los empleados, 3. Listar los proximos a jubilarse, 4. Añadir empleados, 5. Modificar la edad de un empleado, 6. Exportar archivo a texto, 7. Exportar empleados que no tienen DNI cargado, 8. Eliminar un empleado');
  readln(accion);
  case accion of
    1: opcion1(empleados);
    2: opcion2(empleados);
    3: opcion3(empleados);
    4: opcion4(empleados);
    5: opcion5(empleados);
    6: opcion6(empleados);
    7: opcion7(empleados);
    8: opcion8(empleados);
  end;
  close(empleados);
end.