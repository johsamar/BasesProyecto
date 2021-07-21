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
    IdentificacionCliente VARCHAR2(15) NOT NULL,
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

------------------- CLIENTE ---------------------

INSERT INTO Cliente VALUES('000000001C','425695796','Mariana Calle','3168945678','mariana.calle@yahoo.com','PERSONA','CALDAS','SALAMINA','KRA 15 #32-45');
INSERT INTO Cliente VALUES('000000002C','7496345894','Marcos Yaroide','321654987','marcos.yaroide@gmail.com','PERSONA','CALDAS','DORADA','KRA 54 #78-96');
INSERT INTO Cliente VALUES('000000003C','74586471249-1','MercaCentro','3265897486','marcacentro@hotmail.com','ESTABLECIMIENTO','CALDAS','DORADA','KRA 54 #78-96');
INSERT INTO Cliente VALUES('000000004C','95368415664-1','El Ahorro','3205698746','elahorro@gmail.com','ESTABLECIMIENTO','CALDAS','SALAMINA','KRA 4 #7-8');
INSERT INTO Cliente VALUES('000000005C','256489758','Marcela Rey','3225689741','marcela.rey@hotmail.com','PERSONA','CALDAS','PENSILVANIA','KRA 8 #25-8');
INSERT INTO Cliente VALUES('000000006C','6899557425','Gaby Meza','3135698745','marcacentro@hotmail.com','ESTABLECIMIENTO','CALDAS','DORADA','KRA 28 #15-8');
INSERT INTO Cliente VALUES('000000007C','1025698746','Yair Millar','3115266987','yair.millar@hotmail.com','PERSONA','CALDAS','DORADA','KRA 54 #78-96');
INSERT INTO Cliente VALUES('000000008C','1026354987','Federico Gevy','3225649874','federico.gevy@hotmail.com','PERSONA','CALDAS','VITERBO','KRA 4 #3-15');
INSERT INTO Cliente VALUES('000000009C','10359526387','Nathan Ruslan','3236549526','nathan.Rusla@hotmail.com','PERSONA','CALDAS','BELALCÁZAR','KRA 3 #3-32');
INSERT INTO Cliente VALUES('000000010C','1056897426','Karla Vallesteros','3156489526','karla.vallesteros@hotmail.com','PERSONA','CALDAS','RISARALDA','KRA 5 #2-15');

INSERT INTO Cliente VALUES('000000011C','25658974','Bartolomé West','3506258947','bartolome.west@hotmail.com','PERSONA','CALDAS','SAMANÁ','KRA 85 #78-56');
INSERT INTO Cliente VALUES('000000012C','625899741','Nora Allen','3236598746','nora.allen@gmail.com','PERSONA','CALDAS','PENSILVANIA','KRA 47 #89-25');
INSERT INTO Cliente VALUES('000000013C','1025405977','Oliver Queen','3256987461','oliver.queen@hotmail.com','PERSONA','CALDAS','DORADA','KRA 12 #58-10');
INSERT INTO Cliente VALUES('000000014C','1023654115','Maria Ramón','3226985136','maria.ramon@yahoo.com','PERSONA','CALDAS','FILADELFIA','KRA 11 #25-2');
INSERT INTO Cliente VALUES('000000015C','1466840254','Luisa Lane','3112065894','luisa.lane@hotmail.com','PERSONA','CALDAS','DORADA','KRA 7 #2-1');
INSERT INTO Cliente VALUES('000000016C','15668216161','Clark Kent','3205692839','clark.kent@hotmail.com','PERSONA','CALDAS','DORADA','KRA 16 #5-9');
INSERT INTO Cliente VALUES('000000017C','1053845697','Alexander Luthor','3256985947','alexander.lutor@hotmail.com','PERSONA','CALDAS','DORADA','KRA 54 #78-96');
INSERT INTO Cliente VALUES('000000018C','5546134316','Felicia Humo','3221684760','felicia.humo@hotmail.com','PERSONA','CALDAS','RIOSUCIO','KRA 58 #2-3');
INSERT INTO Cliente VALUES('000000019C','1246654451','Laura Lanza','3205695418','laura.lanza@hotmail.com','PERSONA','CALDAS','LA MERCED','KRA 2 #8-8');
INSERT INTO Cliente VALUES('000000020C','1235465467','Marcos Mordo','3215069874','marcos.mordo@hotmail.com','PERSONA','CALDAS','MARMATO','KRA 5 #2-89');

INSERT INTO Cliente VALUES('000000021C','56974123258-1','Supermercado del Centro','3256489210','supermercadodelcentro@gmail.com','ESTABLECIMIENTO','CALDAS','DORADA','KRA 2 #45-8');
INSERT INTO Cliente VALUES('000000022C','12365974174-1','SuperMarketPlace','3216549632','supermarketplace@hotmail.com','ESTABLECIMIENTO','CALDAS','RIOSUCIO','KRA 5 #5-15');
INSERT INTO Cliente VALUES('000000023C','36521689471-1','SuperInter','3136589742','superinter@gmail.com','ESTABLECIMIENTO','CALDAS','LA MERCED','KRA 8 #13-5');
INSERT INTO Cliente VALUES('000000024C','56973365145-1','El Punto A','3203695140','elpuntoa@gmail.com','ESTABLECIMIENTO','CALDAS','FILADELFIA','KRA 4 #86-23');
INSERT INTO Cliente VALUES('000000025C','13659755264-1','Tienda la Esquina','3503201569','tiendaesqina@hotmail.com','ESTABLECIMIENTO','CALDAS','ANSERMA','KRA 5 #14-5');
INSERT INTO Cliente VALUES('000000026C','26968745675-1','Tienda el Centro','3206598746','tiendaelcentro@yahoo.com','ESTABLECIMIENTO','CALDAS','MARULANDA','KRA 24 #78-9');
INSERT INTO Cliente VALUES('000000027C','36925814741-1','Tienda la Izquierda','3205698720','tiendaizquiera@hotmail.com','ESTABLECIMIENTO','CALDAS','RIOSUCIO','KRA 62 #3-2');
INSERT INTO Cliente VALUES('000000028C','75315985264-1','Tienda 4 esquinas','3102589164','tienda4esquinas@gmail.com','ESTABLECIMIENTO','CALDAS','NEIRA','KRA 15 #2-13');
INSERT INTO Cliente VALUES('000000029C','95123698745-1','Tienda el tercio','3236509874','tiendaeltercio@hotmail.com','ESTABLECIMIENTO','CALDAS','PALESTINA','KRA 5 #2-11');
INSERT INTO Cliente VALUES('000000030C','32159874625-1','SuperCentro','3256484796','supercentro@gmail.com','ESTABLECIMIENTO','CALDAS','CHINCHINÁ','KRA 47 #5-13');

INSERT INTO Cliente VALUES('000000031C','275658974','Beatriz Suarez','3215896431','beatriz.suarez@hotmail.com','PERSONA','CALDAS','CHINCHINÁ','KRA 5 #10-5');
INSERT INTO Cliente VALUES('000000032C','6258899741','Ignacio Sánchez','3115206947','ignacio.sanchez@gmail.com','PERSONA','CALDAS','PENSILVANIA','KRA 4 #5-10');
INSERT INTO Cliente VALUES('000000033C','102405977','Miguel Reyes','3114685069','miguel.reyes@hotmail.com','PERSONA','CALDAS','MANIZALES','KRA 4 #4-10');
INSERT INTO Cliente VALUES('000000034C','102364115','Daniel Medina','3224581030','daniel.medina@yahoo.com','PERSONA','CALDAS','MANIZALES','KRA 23 #4-20');
INSERT INTO Cliente VALUES('000000035C','146680254','Bruno Díaz','3142506958','bruno.diaz@hotmail.com','PERSONA','CALDAS','PALESTINA','KRA 7 #21-125');
INSERT INTO Cliente VALUES('000000036C','1566816161','Selena Kyle','3152039988','selena.kyle@hotmail.com','PERSONA','CALDAS','SALAMINA','KRA 7 #5-8');
INSERT INTO Cliente VALUES('000000037C','1053844316','Alexis Pinzón','3005891060','alexis.pinzon@hotmail.com','PERSONA','CALDAS','RIOSUCIO','KRA 58 #24-3');
INSERT INTO Cliente VALUES('000000039C','124665451','Amanda Salgado','3205554101','amanda.salgado@hotmail.com','PERSONA','CALDAS','PÁCORA','KRA 24 #18-8');
INSERT INTO Cliente VALUES('000000040C','123546467','Franchezca Michaels','3256641520','franchezca.michaels@hotmail.com','PERSONA','CALDAS','MANIZALES','KRA 5 #2-89');

INSERT INTO Cliente VALUES('000000041C','85269820120-1','Super Estación','3256502144','superestacion@gmail.com','ESTABLECIMIENTO','RISARALDA','DOSQUEBRADAS','KRA 2 #45-8');
INSERT INTO Cliente VALUES('000000042C','56985300140-1','La Tiena de Ruby','3256478000','latiendaderuby@hotmail.com','ESTABLECIMIENTO','RISARALDA','PEREIRA','KRA 5 #5-15');
INSERT INTO Cliente VALUES('000000043C','42366514775-1','La Esquina de Rut','3115497899','laesquinaderut@gmail.com','ESTABLECIMIENTO','RISARALDA','GUATICA','KRA 8 #13-5');
INSERT INTO Cliente VALUES('000000044C','25801366957-1','La tienda de Juan','3504788871','latiendadejuan@gmail.com','ESTABLECIMIENTO','RISARALDA','APÍA','KRA 4 #86-23');
INSERT INTO Cliente VALUES('000000045C','10355000144-1','Perla 3 esqinas','3256480011','perla3esqinas@hotmail.com','ESTABLECIMIENTO','RISARALDA','LA VIRGINIA','KRA 5 #14-5');
INSERT INTO Cliente VALUES('000000046C','56325001014-1','La mongo tienda','3206509866','lamongotienda@yahoo.com','ESTABLECIMIENTO','RISARALDA','PEREIRA','KRA 24 #78-9');
INSERT INTO Cliente VALUES('000000047C','10236025014-1','JavaMarket','3221450133','javamarket@hotmail.com','ESTABLECIMIENTO','RISARALDA','LA VRGINIA','KRA 62 #3-2');
INSERT INTO Cliente VALUES('000000048C','59601014452-1','El Zoomeet','3213236501','elzooomeet@gmail.com','ESTABLECIMIENTO','RISARALDA','DOSQUEBRADAS','KRA 15 #2-13');
INSERT INTO Cliente VALUES('000000049C','25600133658-1','Market Teams','3251026958','marketteams@hotmail.com','ESTABLECIMIENTO','RISARALDA','PEREIRA','KRA 5 #2-11');
INSERT INTO Cliente VALUES('000000050C','14500012667-1','La gran esquina','3502206687','lagranesqina@gmail.com','ESTABLECIMIENTO','RISARALDA','PEREIRA','KRA 47 #5-13');

INSERT INTO Cliente VALUES('000000051C','1231313355','Paolo Franco','3220059847','paolo.franco@hotmail.com','PERSONA','RISARALDA','PEREIRA','KRA 5 #10-5');
INSERT INTO Cliente VALUES('000000052C','5456145774','Pedro Pascal','3210256974','pedro.pascal@gmail.com','PERSONA','RISARALDA','PEREIRA','KRA 4 #5-10');
INSERT INTO Cliente VALUES('000000053C','1002032377','Judas Tadeo','3002552147','judas.tadeo@hotmail.com','PERSONA','RISARALDA','APÍA','KRA 4 #4-10');
INSERT INTO Cliente VALUES('000000054C','4551515151','Pablo Escobar','3256981024','pablo.escobar@yahoo.com','PERSONA','RISARALDA','APÍA','KRA 23 #4-20');
INSERT INTO Cliente VALUES('000000055C','454634144','Andrea Serna','3142556958','andrea.serna@hotmail.com','PERSONA','RISARALDA','DOSQUEBRADAS','KRA 7 #21-125');
INSERT INTO Cliente VALUES('000000056C','12121252515','Camila Calvo','3152037988','camila.calvo@hotmail.com','PERSONA','RISARALDA','LA VRGINIA','KRA 7 #5-8');
INSERT INTO Cliente VALUES('000000057C','10255424474','Armando Casas','3151029854','armando.casas@hotmail.com','PERSONA','RISARALDA','LA VRGINIA','KRA 4 #10-6');
INSERT INTO Cliente VALUES('000000058C','100055544','Cristina Llaves','3005881060','cristina.llaves@hotmail.com','PERSONA','RISARALDA','DOSQUEBRADAS','KRA 58 #24-3');
INSERT INTO Cliente VALUES('000000059C','100005558647','Bill Windows','3209554101','bill.windows@hotmail.com','PERSONA','RISARALDA','LA VRGINIA','KRA 24 #18-8');
INSERT INTO Cliente VALUES('000000060C','102010247','Lebron Jordan','3256648520','lebron.jordan@hotmail.com','PERSONA','RISARALDA','DOSQUEBRADAS','KRA 5 #2-89');

INSERT INTO Cliente VALUES('000000061C','65652141354-1','SuperTiendita','3256669874','supertiendita@gmail.com','ESTABLECIMIENTO','QUINDÍO','QUIMABAYA','KRA 2 #45-8');
INSERT INTO Cliente VALUES('000000062C','15348646343-1','La Tiena de Lebron','3146668952','latiendadelebron@hotmail.com','ESTABLECIMIENTO','QUINDÍO','MONTENEGRO','KRA 5 #5-15');
INSERT INTO Cliente VALUES('000000063C','45348687497-1','La Esquina de Miguel','3202225147','laesquinademiguel@gmail.com','ESTABLECIMIENTO','QUINDÍO','MONTENEGRO','KRA 8 #13-5');
INSERT INTO Cliente VALUES('000000064C','34831435938-1','La tienda de Laura','3222145500','latiendadelaura@gmail.com','ESTABLECIMIENTO','QUINDÍO','ARMENIA','KRA 4 #86-23');
INSERT INTO Cliente VALUES('000000065C','55663654475-1','Diamante 4 esquians','3214501441','diamante4esqinas@hotmail.com','ESTABLECIMIENTO','QUINDÍO','ARMENIA','KRA 5 #14-5');
INSERT INTO Cliente VALUES('000000066C','12365556843-1','La sql tienda','3502654994','lasqltienda@yahoo.com','ESTABLECIMIENTO','QUINDÍO','QUIMBAYA','KRA 24 #78-9');
INSERT INTO Cliente VALUES('000000067C','89646546846-1','RubyMarket','3006002020','rubymarket@hotmail.com','ESTABLECIMIENTO','QUINDÍO','CIRCASIA','KRA 62 #3-2');
INSERT INTO Cliente VALUES('000000068C','54343643833-1','El gugulteams','3251010101','elgugulteams@gmail.com','ESTABLECIMIENTO','QUINDÍO','CIRCASIA','KRA 15 #2-13');
INSERT INTO Cliente VALUES('000000069C','15546565564-1','Market Live','3210254646','marketlive@hotmail.com','ESTABLECIMIENTO','QUINDÍO','ARMENIA','KRA 5 #2-11');
INSERT INTO Cliente VALUES('000000070C','48936441681-1','La gran Cuadra','3201452233','lagranecuadra@gmail.com','ESTABLECIMIENTO','QUINDÍO','ARMENIA','KRA 47 #5-13');

INSERT INTO Cliente VALUES('000000071C','132558135','Jhon Snow','3156065825','jhon.snow@hotmail.com','PERSONA','QUINDÍO','QUIMBAYA','KRA 5 #10-5');
INSERT INTO Cliente VALUES('000000072C','102565445','Adrian Silva','3235206341','adrian.silva@gmail.com','PERSONA','QUINDÍO','QUIMBAYA','KRA 4 #5-10');
INSERT INTO Cliente VALUES('000000073C','10000256444','Judas Iscariote','3002582581','judas.iscariote@hotmail.com','PERSONA','QUINDÍO','MONTENEGO','KRA 4 #4-10');
INSERT INTO Cliente VALUES('000000074C','1032012558','Paolo Escobar','3022025022','paolo.escobar@yahoo.com','PERSONA','QUINDÍO','APÍA','MONTENEGRO 23 #4-20');
INSERT INTO Cliente VALUES('000000075C','1520265695','Lina Serna','3012020303','lina.serna@hotmail.com','PERSONA','QUINDÍO','CIRCASIA','KRA 7 #21-125');
INSERT INTO Cliente VALUES('000000076C','25266644','Camila Cabello','3013032020','camila.cabello@hotmail.com','PERSONA','QUINDÍO','CIRCASIA','KRA 7 #5-8');
INSERT INTO Cliente VALUES('000000077C','2036554111','Armando Paredes','3506502250','armando.paredes@hotmail.com','PERSONA','QUINDÍO','MONTENEGRO','KRA 4 #10-6');
INSERT INTO Cliente VALUES('000000078C','10266999','Cristina Segura','3012051010','cristina.segura@hotmail.com','PERSONA','QUINDÍO','ARMENIA','KRA 58 #24-3');
INSERT INTO Cliente VALUES('000000079C','302541044','Bill Apple','3165004164','bill.apple@hotmail.com','PERSONA','QUINDÍO','ARMENIA','KRA 24 #18-8');
INSERT INTO Cliente VALUES('000000080C','9620465412','Michael James','3203653232','michael.james@hotmail.com','PERSONA','ARMENIA','DOSQUEBRADAS','KRA 5 #2-89');

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