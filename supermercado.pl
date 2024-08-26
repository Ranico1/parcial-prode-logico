
%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).

% Punto 1

descuento(arroz(Marca), 1.50) :- 
    precioUnitario(arroz(Marca), _).

descuento(salchicha(Marca,_), 0.50) :-
    Marca \= vienisima. 

descuento(lacteos(_,leche), 2).
descuento(lacteos(Marca, queso), 2) :- 
    primeraMarca(Marca). 

descuento(Producto, Descuento) :- 
    precioUnitario(Producto, Precio),
    forall(precioUnitario(_, OtroPrecio), Precio > OtroPrecio),
    Descuento is Precio * 0.5.   

% Punto 2

clienteCompulsivo(Cliente) :- 
    compro(Cliente, _,_ ),
    forall(compro(Cliente, Producto,_), calidadConDescuento(Producto)).

calidadConDescuento(Producto) :-
    descuento(Producto,_), 
    esPrimeraMarca(Producto).

esPrimeraMarca(Producto) :-
    marcaProducto(Producto, Marca),
    primeraMarca(Marca).

marcaProducto(arroz(Marca), Marca).
marcaProducto(lacteo(Marca,_), Marca).
marcaProducto(salchicas(Marca, _), Marca). 


% Punto 3
totalAPagar(Cliente, MontoApagar) :-
    compro(Cliente,Producto,Cantidad),
    listaComprada(Producto, Cantidad, MontoApagar). 

listaComprada(Producto, Cantidad, MontoApagar) :- 
    findall(Precio, valor(Producto,Cantidad,Precio), ListaDePrecios),
    sumlist(ListaDePrecios, MontoApagar).

valor(Producto, Cantidad, Precio) :- 
    precioUnitario(Producto, PrecioUnitario),
    descuento(Producto, Descuento), 
    Precio is Cantidad * (PrecioUnitario - Descuento). 

valor(Producto, Cantidad, Precio) :-
    not(descuento(Producto, _)),
    precioUnitario(Producto, PrecioUnitario),
    Precio is Cantidad * PrecioUnitario. 


% Punto 4

clienteFiel(Cliente, Marca) :- 
    compro(Cliente,_ ,_), 
    marcaProducto(_, Marca),
    forall(compro(Cliente, Producto,_), marcaProducto(Producto,Marca)). 

     

% Punto 5
duenio(laSerenisima, gandara).
duenio(gandara, vacalín).

provee(Empresa, ListaProvee) :-
    duenio(Empresa, Subordinada), 
    findall(Producto, productosDe(Empresa,Producto), Productos).

productosDe(Empresa, Producto) :-
    marcaProducto(Producto, Empresa).

productoDe(Empresa, Producto) :-
    marcaProducto(Producto, Marca),
    duenio(Empresa, Marca).




