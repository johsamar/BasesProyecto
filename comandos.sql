DROP TABLE Resena;
DROP TABLE MomentoEntrega;
DROP TABLE Entrega;
DROP TABLE Pago;
DROP TABLE Factura;
DROP TABLE Pedido;
DROP TABLE Canasta;
DROP TABLE ProductoEnVenta;
DROP TABLE Producto;
DROP TABLE CertificacionXFinca;
DROP TABLE Finca;
DROP TABLE CuentaConsignacion;
DROP TABLE Productor;
DROP TABLE Distribuidor;
DROP TABLE Cliente;
DROP TABLE Categoria; 
DROP TABLE Certificacion;

CREATE TABLE Certificacion(
    IdCertificacion VARCHAR2(4) NOT NULL,
    NombreCertificacion VARCHAR2(40) NOT NULL,
    DescripcionCertificacion VARCHAR2(300) NOT NULL,
    CONSTRAINT PrimaryKeyCertificacion PRIMARY KEY(IdCertificacion)
);

CREATE TABLE Categoria(
    IdCategoria VARCHAR2(5) NOT NULL,
    NombreCategoria VARCHAR2(25) NOT NULL,
    DescripcionCategoria VARCHAR2(180) NOT NULL,
    CONSTRAINT PrimaryKeyCategoria PRIMARY KEY(IdCategoria)
);

CREATE TABLE Cliente(
    IdCliente VARCHAR2(10) NOT NULL,
    IdentificacionCliente VARCHAR2(10) NOT NULL,
    NombreCliente VARCHAR2(40) NOT NULL,
    TelefonoCliente VARCHAR2(10) NOT NULL,
    CorreoCliente VARCHAR2(40) NOT NULL,
    TipoCliente VARCHAR2(20) NOT NULL,
    DepartamentoCliente VARCHAR2(15) NOT NULL,
    MunicipioCliente VARCHAR2(15) NOT NULL,
    DireccionCliente VARCHAR2(30) NOT NULL,
    CONSTRAINT PrimaryKeyCliente PRIMARY KEY(IdCliente),
    CONSTRAINT UniqueIdentificacionCliente UNIQUE(IdentificacionCliente),
    CONSTRAINT UniqueTelefonoCliente UNIQUE(TelefonoCliente),
    CONSTRAINT CheckTipoCliente CHECK(TipoCliente='PERSONA' OR TipoCliente='ESTABLECIMIENTO')
);

CREATE TABLE Distribuidor(
    IdDistribuidor VARCHAR2(10) NOT NULL,
    CedulaDistribuidor VARCHAR2(25) NOT NULL,
    NombreDistribuidor VARCHAR2(25) NOT NULL,
    ApellidoDistribuidor VARCHAR2(25) NOT NULL,
    CelularDistribuidor VARCHAR2(10) NOT NULL,
    CorreoDistribuidor VARCHAR2(40) NOT NULL,
    CONSTRAINT PrimaryKeyDistribuidor PRIMARY KEY(IdDistribuidor),
    CONSTRAINT UniqueCedulaDistribuidor UNIQUE(CedulaDistribuidor)
);

CREATE TABLE Productor(
    IdProductor VARCHAR2(10) NOT NULL,
    NombreProductor VARCHAR2(25) NOT NULL,
    ApellidoProductor VARCHAR2(25) NOT NULL,
    CedulaProductor VARCHAR2(15) NOT NULL,
    CelularProductor VARCHAR2(12) NOT NULL,
    CorreoProductor VARCHAR2(40) NOT NULL,
    DireccionProductor VARCHAR2(40) NOT NULL,
    CONSTRAINT PrimaryKeyProductor PRIMARY KEY(IdProductor),
    CONSTRAINT UniqueCedulaProductor UNIQUE(CedulaProductor),
    CONSTRAINT UniqueCelularProductor UNIQUE(CelularProductor)
); 

CREATE TABLE CuentaConsignacion(
    IdCuenta VARCHAR2(10) NOT NULL,
    CodigoBancario VARCHAR2(3) NOT NULL,
    NumeroDeCuenta VARCHAR2(19) NOT NULL,
    IdProductor VARCHAR2(10) NOT NULL,
    CONSTRAINT PrimaryKeyCuentaConsignacion PRIMARY KEY (IdCuenta),
    CONSTRAINT ForeignKeyCuentaProducor FOREIGN KEY(IdProductor) REFERENCES Productor(IdProductor) ON DELETE CASCADE,
    CONSTRAINT UniqueNumeroCuenta UNIQUE(NumeroDeCuenta)
);

CREATE TABLE Finca(
    IdFinca VARCHAR2(10) NOT NULL,
    NombreFinca VARCHAR2(25) NOT NULL,
    DepartamentoFinca VARCHAR2(15) NOT NULL,
    MunicipioFinca VARCHAR2(15) NOT NULL,
    Vereda VARCHAR2(20) NOT NULL,
    GPS VARCHAR2(50) NOT NULL,
    Superficie VARCHAR2(5) NOT NULL,
    CONSTRAINT PrimaryKeyFinca PRIMARY KEY(IdFinca)
);

CREATE TABLE CertificacionXFinca(
    IdCertificacion VARCHAR2(4) NOT NULL,
    IdFinca VARCHAR2(10) NOT NULL,
    FechaDeCertificacion DATE NOT NULL,
    Vigencia DATE NOT NULL,
    CONSTRAINT ForeignKeyCertificacionxFinca FOREIGN KEY(IdCertificacion) REFERENCES Certificacion(IdCertificacion),
    CONSTRAINT ForeignKeyFincaxCertificacion FOREIGN KEY(IdFinca) REFERENCES Finca(IdFinca)
);

CREATE TABLE Producto(
    IdProducto VARCHAR2(10) NOT NULL,
    NombreProducto VARCHAR2(25) NOT NULL,
    PrecioProducto NUMBER(8) NOT NULL,
    IdCategoria VARCHAR2(5) NOT NULL,
    CONSTRAINT PrimaryKeyProducto PRIMARY KEY(IdProducto),
    CONSTRAINT ForeignKeyProductoCategoria FOREIGN KEY(IdCategoria) REFERENCES Categoria(IdCategoria)
);

CREATE TABLE ProductoEnVenta(
    IdProductoEnVenta VARCHAR2(10) NOT NULL,
    IdProductor VARCHAR2(10) NOT NULL,
    IdFinca VARCHAR2(10) NOT NULL,
    IdProducto VARCHAR2(10) NOT NULL,
    Fecha DATE NOT NULL,
    Cantidad NUMBER(3) NOT NULL,
    EstadoProducto VARCHAR2(10) NOT NULL,
    CONSTRAINT PrimaryKeyProductVent PRIMARY KEY(IdProductoEnVenta),
    CONSTRAINT ForeignKeyProductVentProdtr FOREIGN KEY(IdProductor) REFERENCES Productor(IdProductor),
    CONSTRAINT ForeignKeyProductVentFnca FOREIGN KEY(IdFinca) REFERENCES Finca(IdFinca),
    CONSTRAINT ForeignKeyProductVentPrdto FOREIGN KEY(IdProducto) REFERENCES Producto(IdProducto),
    CONSTRAINT CheckProductVentCant CHECK(Cantidad>0),
    CONSTRAINT CheckEstadoProdctVenta CHECK(EstadoProducto='MADURO' OR EstadoProducto='VERDE' OR EstadoProducto='AGOTADO')
);

CREATE TABLE Canasta(
    IdCanasta VARCHAR2(10) NOT NULL,
    IdCliente VARCHAR2(10) NOT NULL,
    EstadoCanasta VARCHAR2(15) NOT NULL,
    CONSTRAINT PrimaryKeyCanasta PRIMARY KEY(IdCanasta),
    CONSTRAINT ForeignKeyCanastaCliente FOREIGN KEY(IdCliente) REFERENCES Cliente(IdCliente),
    CONSTRAINT CheckEstadoCanasta CHECK(EstadoCanasta='LLENANDO' OR EstadoCanasta='FACTURANDO' OR EstadoCanasta='COMPRADA')
);

CREATE TABLE Pedido(
    IdCanasta VARCHAR2(10) NOT NULL,
    IdProductoEnVenta VARCHAR2(10) NOT NULL,
    FechaPedido VARCHAR2(10) NOT NULL,
    CantidadPedida NUMBER(3) NOT NULL,
    CONSTRAINT ForeignKeyPedidoCanasta FOREIGN KEY(IdCanasta) REFERENCES Canasta(IdCanasta),
    CONSTRAINT ForeignKeyPedidoProductVent FOREIGN KEY(IdProductoEnVenta) REFERENCES ProductoEnVenta(IdProductoEnVenta),
    CONSTRAINT CheckPedidoCantidad CHECK(CantidadPedida>0)
);

CREATE TABLE Factura(
    IdFactura VARCHAR2(10) NOT NULL,
    IdCanasta VARCHAR2(10) NOT NULL,
    IdCliente VARCHAR2(10) NOT NULL,
    CostoEnvio VARCHAR2(10) NOT NULL,
    IVA NUMBER(3) NOT NULL,
    TotalPagar NUMBER(8) NOT NULL,
    CONSTRAINT PrimaryKeyFactura PRIMARY KEY(IdFactura),
    CONSTRAINT ForeingKeyFactCanasta FOREIGN KEY (IdCanasta) REFERENCES Canasta(IdCanasta),
    CONSTRAINT ForeingKeyFactCliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE Pago(
    IdPago VARCHAR2(10) NOT NULL,
    IdFactura VARCHAR2(10) NOT NULL,
    FechaPago DATE NOT NULL,
    MetodoPago VARCHAR2(25) NOT NULL,
    ValorPago NUMBER(8) NOT NULL,
    CONSTRAINT PrimaryKeyPago PRIMARY KEY(IdPago),
    CONSTRAINT ForeingKeyPagoFactura FOREIGN KEY (IdFactura) REFERENCES Factura(IdFactura)
);

CREATE TABLE Entrega(
    IdEntrega VARCHAR2(10) NOT NULL,
    IdFactura VARCHAR2(10) NOT NULL,
    IdDistribuidor VARCHAR2(10) NOT NULL,
    CONSTRAINT PrimaryKeyEntrega PRIMARY KEY(IdEntrega),
    CONSTRAINT ForeingKeyEntregaFact FOREIGN KEY (IdFactura) REFERENCES Factura(IdFactura),
    CONSTRAINT ForeingKeyEntregaDstrib FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor)
);

CREATE TABLE MomentoEntrega(
    IdEntrega VARCHAR2(10) NOT NULL,
    UbicacionEntrega VARCHAR2(50) NOT NULL,
    TiempoEstimado VARCHAR2(20) NOT NULL,
    EstadoEntrega VARCHAR2(20) NOT NULL,
    CONSTRAINT ForeingKeyEntregaMomento FOREIGN KEY (IdEntrega) REFERENCES Entrega(IdEntrega),
    CONSTRAINT CheckEstadoEntrega CHECK(EstadoEntrega='PREPARANDO' OR EstadoEntrega='DESPACHADO' OR EstadoEntrega='DISTRIBUCION' OR EstadoEntrega='ENTREGADO')
);

CREATE TABLE Resena(
    IdResena VARCHAR2(10) NOT NULL,
    Descripcion VARCHAR2(10) NOT NULL,
    Calificacion VARCHAR2(10) NOT NULL,
    FechaResena VARCHAR2(10) NOT NULL,
    IdFactura VARCHAR2(10) NOT NULL,
    IdProductoEnVenta VARCHAR2(10) NOT NULL,
    IdCliente VARCHAR2(10) NOT NULL,
    CONSTRAINT PrimaryKeyResena PRIMARY KEY(IdResena),
    CONSTRAINT CheckCalResena CHECK(Calificacion>=0 AND Calificacion<=5),
    CONSTRAINT ForeignKeyResenaFact FOREIGN KEY(IdFactura) REFERENCES Factura(IdFactura),
    CONSTRAINT ForeignKeyResenaPrdtoVent FOREIGN KEY(IdProductoEnVenta) REFERENCES ProductoEnVenta(IdProductoEnVenta),
    CONSTRAINT ForeignKeyResenaCliente FOREIGN KEY(IdCliente) REFERENCES Cliente(IdCliente)
);

------------------ CERTIFICACION ------------------
INSERT INTO Certificacion VALUES('0000','BPM','Buenas Practicas De Manofactura');
INSERT INTO Certificacion VALUES('0001', 'AA', 'Productos con mejor tamaño');
INSERT INTO Certificacion VALUES('0010','Productos Organicos', 'Comida orgánica o Alimento orgánico es un término que define los alimentos destinados al consumo que han sido producidos sin productos químicos y procesados sin aditivos');
INSERT INTO Certificacion VALUES('0011','Tierras Fértiles', 'Son las tierras aptas para la produccion agraria');
INSERT INTO Certificacion VALUES('0100','Producto de Alta calidad','significa que le fueron incorporadas diferentes características, con la capacidad de satisfacer las necesidades del consumidor y de brindarle satisfacción al cliente, al mejorar el producto y liberarlo de cualquier deficiencia o defecto');
INSERT INTO Certificacion VALUES('0101','Exportacion','Productos que estan avalados con calidad de exportacion');


------------------- CATEGORIA --------------------
INSERT INTO Categoria VALUES('0000A','Vegetales','partes comestibles de las plantas, como hojas, inflorescencias y tallos');
INSERT INTO Categoria VALUES('0001A','Frutas',' frutos comestibles obtenidos de plantas cultivadas o silvestres que, por su sabor generalmente dulce-acidulado, su aroma intenso y agradable y sus propiedades nutritivas');
INSERT INTO Categoria VALUES('0010A','Tuberculos','Son las Raices de algunas plantas, como las papas, yuca, remolacha');
INSERT INTO Categoria VALUES('0011A','Granos','Un grano es una semilla pequeña, dura y seca, con o sin cáscara o capa de fruta adherida');
INSERT INTO Categoria VALUES('0101A','Dulcen','Productos derivados de endulzante procesados o no, panela, bocadiño, arequipe');
INSERT INTO Categoria VALUES('0111A','Lacteos','Productos derivados de la leche');
INSERT INTO Categoria VALUES('1011A','Salud y Belleza','Plantas medicinales o productos naturales');
INSERT INTO Categoria VALUES('1111A','Procesados','Productos agricolas con valor agregado, han soportado cambios o han pasado por algun grado de procesamiento industrial antes de llegar a nuestra mesa para que los podamos consumir.');

--Cliente
INSERT INTO Cliente VALUES('IdCliente','IdentificacionCliente','NombreCliente','TelefonoCliente','CorreoCliente','TipoCliente','DepartamentoCliente','MunicipioCliente','DireccionCliente');

INSERT INTO Cliente VALUES('010101010C','425695796','Mariana Calle','3168945678','mariana.calle@yahoo.com','PERSONA','CALDAS','SALAMINA','KRA 15 #32-45');
INSERT INTO Cliente VALUES('010101011C','7496345894','Marcos Yaroide','321654987','marcos.yaroide@gmail.com','PERSONA','CALDAS','DORADA','KRA 54 #78-96');
INSERT INTO Cliente VALUES('010101110C','74586471249-1','MercaCentro','321654987','marcacentro@hotmail.com','ESTABLECIMIENTO','CALDAS','DORADA','KRA 54 #78-96');
INSERT INTO Cliente VALUES('010101111C','95368415664-1','El Ahorro','321654987','marcacentro@hotmail.com','ESTABLECIMIENTO','CALDAS','DORADA','KRA 54 #78-96');



--Distribuidor
INSERT INTO Distribuidor VALUES('IdDistribuidor','CedulaDistribuidor','NombreDistribuidor','ApellidoDistribuidor','CelularDistribuidor','CorreoDistribuidor');





--Productor
INSERT INTO  Productor VALUES('IdProductor','NombreProductor','ApellidoProductor','CedulaProductor','CelularProductor','CorreoProductor','DireccionProductor'); 



-- CuentaConsignacion

INSERT INTO CuentaConsignacion VALUES('IdCuenta','CodigoBancario','NumeroDeCuenta','IdProductor');


--Ficna

INSERT INTO Finca VALUES('IdFinca','NombreFinca','DepartamentoFinca','MunicipioFinca','Vereda','GPS','Superficie');





--CertificacionPorFinca
INSERT INTO CertificacionXFinca VALUES('IdCertificacion','IdFinca','FechaDeCertificacion','Vigencia');




--PRODUCTO

INSERT INTO Producto VALUES('IdProducto','NombreProducto','PrecioProducto','IdCategoria');



--PRODUCTO EN VENTA
INSERT INTO ProductoEnVenta VALUES('IdProductoEnVenta','IdProductor','IdFinca','IdProducto','Fecha','Cantidad','EstadoProducto');




--CANASTA

INSERT INTO Canasta VALUES('IdCanasta','IdCliente','EstadoCanasta');


--PEDIDO

INSERT INTO Pedido VALUES('IdCanasta','IdProductoEnVenta','FechaPedido','CantidadPedida');


--FACTURA

INSERT INTO Factura VALUES('IdFactura','IdCanasta','IdCliente','CostoEnvio','IVA','TotalPagar');


--PAGO

INSERT INTO Pago VALUES('IdPago','IdFactura','FechaPago','MetodoPago','ValorPago');


--ENTREGA

INSERT INTO Entrega VALUES('IdEntrega','IdFactura','IdDistribuidor');


--MOMENTOENTREGA

INSERT INTO MomentoEntrega VALUES('IdEntrega','UbicacionEntrega','TiempoEstimado','EstadoEntrega');


--RESEÑA

INSERT INTO Resena VALUES('IdResena','Descripcion','Calificacion','FechaResena','IdFactura','IdProductoEnVenta','IdCliente');