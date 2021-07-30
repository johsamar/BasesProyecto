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
    DepartamentoProductor VARCHAR2(15) NOT NULL,
    MunicipioProductor VARCHAR2(15) NOT NULL,
    DireccionProductor VARCHAR2(40) NOT NULL,
    CONSTRAINT PrimaryKeyProductor PRIMARY KEY(IdProductor),
    CONSTRAINT UniqueCedulaProductor UNIQUE(CedulaProductor),
    CONSTRAINT UniqueCelularProductor UNIQUE(CelularProductor)
); 

CREATE TABLE CuentaConsignacion(
    IdCuenta VARCHAR2(10) NOT NULL,
    CodigoBancario VARCHAR2(4) NOT NULL,
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
    Superficie NUMBER(5) NOT NULL,
    CONSTRAINT PrimaryKeyFinca PRIMARY KEY(IdFinca)
);

CREATE TABLE CertificacionXFinca(
    IdCertificacion VARCHAR2(4) NOT NULL,
    IdFinca VARCHAR2(10) NOT NULL,
    FechaDeCertificacion DATE NOT NULL,
    Vigencia DATE NOT NULL,
    CONSTRAINT ForeignKeyCertificacionxFinca FOREIGN KEY(IdCertificacion) REFERENCES Certificacion(IdCertificacion),
    CONSTRAINT ForeignKeyFincaxCertificacion FOREIGN KEY(IdFinca) REFERENCES Finca(IdFinca),
    CONSTRAINT PrimaryKeyFincaxCertificacion PRIMARY KEY (IdCertificacion, IdFinca) 
);

CREATE TABLE Producto(
    IdProducto VARCHAR2(10) NOT NULL,
    NombreProducto VARCHAR2(25) NOT NULL,
    IdCategoria VARCHAR2(5) NOT NULL,
    CONSTRAINT PrimaryKeyProducto PRIMARY KEY(IdProducto),
    CONSTRAINT ForeignKeyProductoCategoria FOREIGN KEY(IdCategoria) REFERENCES Categoria(IdCategoria)
);

CREATE TABLE ProductoEnVenta(
    IdProductoEnVenta VARCHAR2(10) NOT NULL,
    IdProductor VARCHAR2(10) NOT NULL,
    IdFinca VARCHAR2(10) NULL,
    IdProducto VARCHAR2(10) NOT NULL,
    PrecioProducto NUMBER(8) NOT NULL,
    Descripcion VARCHAR2(200) NOT NULL,
    Fecha DATE NOT NULL,
    Cantidad NUMBER(3) NOT NULL,
    EstadoProducto VARCHAR2(15) NOT NULL,
    CONSTRAINT PrimaryKeyProductVent PRIMARY KEY(IdProductoEnVenta),
    CONSTRAINT ForeignKeyProductVentProdtr FOREIGN KEY(IdProductor) REFERENCES Productor(IdProductor),
    CONSTRAINT ForeignKeyProductVentFnca FOREIGN KEY(IdFinca) REFERENCES Finca(IdFinca),
    CONSTRAINT ForeignKeyProductVentPrdto FOREIGN KEY(IdProducto) REFERENCES Producto(IdProducto),
    CONSTRAINT CheckProductVentCant CHECK(Cantidad>0),
    CONSTRAINT CheckEstadoProdctVenta CHECK(EstadoProducto='DISPONIBLE' OR EstadoProducto='AGOTADO' OR EstadoProducto='NO DISPONIBLE')
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
    CONSTRAINT PrimaryKeyPedidoXCanasta PRIMARY KEY (IdCanasta, IdProductoEnVenta),
    CONSTRAINT CheckPedidoCantidad CHECK(CantidadPedida>0)
);

CREATE TABLE Factura(
    IdFactura VARCHAR2(10) NOT NULL,
    IdCanasta VARCHAR2(10) NOT NULL,
    IdCliente VARCHAR2(10) NOT NULL,
    CostoEnvio VARCHAR2(10) NOT NULL,
    --IVA NUMBER(3) NOT NULL,
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
    CONSTRAINT ForeingKeyPagoFactura FOREIGN KEY (IdFactura) REFERENCES Factura(IdFactura),
    CONSTRAINT CheckMetodoPago CHECK(MetodoPago='TARJETA' or MetodoPago='EFECTIVO')
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
    CONSTRAINT CheckEstadoEntrega CHECK(EstadoEntrega='PREPARANDO' OR EstadoEntrega='DESPACHADO' OR EstadoEntrega='DISTRIBUCION' OR EstadoEntrega='ENTREGADO'),
    CONSTRAINT MomentoXEntrega PRIMARY KEY (IdEntrega, UbicacionEntrega)
);

CREATE TABLE Resena(
    IdResena VARCHAR2(10) NOT NULL,
    Descripcion VARCHAR2(300) NOT NULL,
    Calificacion NUMBER(10) NOT NULL,
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
INSERT INTO Categoria VALUES('0101A','Dulces','Productos derivados de endulzante procesados o no, panela, bocadiño, arequipe');
INSERT INTO Categoria VALUES('0111A','Lacteos','Productos derivados de la leche');
INSERT INTO Categoria VALUES('1011A','Salud y Belleza','Plantas medicinales o productos naturales');
INSERT INTO Categoria VALUES('1111A','Procesados','Productos agricolas con valor agregado, han soportado cambios o han pasado por algun grado de procesamiento industrial antes de llegar a nuestra mesa para que los podamos consumir.');
INSERT INTO Categoria VALUES('0000B','Especias','Son una serie de aromas de origen vegetal que se usan para preservar o dar sabor a los alimentos.');


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

--------------- DISTRIBUIDOR ---------------------
INSERT INTO Distribuidor VALUES('000000001D','1023674584','Marco','Polo','3256640102','marco.polo@hotmail.com');
INSERT INTO Distribuidor VALUES('000000002D','1023674585','André','Weiss','3256640102','andré.weiss@hotmail.com');
INSERT INTO Distribuidor VALUES('000000003D','1023674586','Fidel','Hammil','3256640102','fidel.hammil@hotmail.com');
INSERT INTO Distribuidor VALUES('000000004D','1023674587','Nathan','Gonzalez','3256640102','nathan.gonzalez@hotmail.com');
INSERT INTO Distribuidor VALUES('000000005D','1023674588','Leonel','Fernandez','3256640102','leonel.fernandez@hotmail.com');
INSERT INTO Distribuidor VALUES('000000006D','1023674589','Carlos','Salazar','3256640102','carlos.salazar@hotmail.com');
INSERT INTO Distribuidor VALUES('000000007D','1023674590','Mario','Sanchez','3256640102','mario.sanchez@hotmail.com');
INSERT INTO Distribuidor VALUES('000000008D','1023674591','Diego','Rios','3256640102','diego.rios@hotmail.com');
INSERT INTO Distribuidor VALUES('000000009D','1023674592','Mauricio','Cabezas','3256640102','mauricio.cabezas@hotmail.com');

-------------- PRODUCTOR ---------------------
INSERT INTO  Productor VALUES('000000001P','Carlos','Santana','1025549870','3256669999','carlos.santana@hotmail.com','QUINDÍO','PIJAO','KRA 5 #2-89'); 
INSERT INTO  Productor VALUES('000000002P','Henri','Suarez','1025575870','3256670999','henri.suarez@gmail.com','QUINDÍO','QUIMBAYA','KRA 6 #2-58'); 
INSERT INTO  Productor VALUES('000000003P','Tobias','Camil','1025577870','3256671999','tobias.camil@gmail.com','QUINDÍO','SALENTO','KRA 7 #2-23'); 
INSERT INTO  Productor VALUES('000000004P','Carmen','Rigo','1025541870','3256667299','carmen.rigo@gmail.com','QUINDÍO','SALENTO','KRA 8 #2-46'); 
INSERT INTO  Productor VALUES('000000005P','Diana','Paniagua','1125549870','3257369999','diana.paniagua@gmail.com','QUINDÍO','QUIMBAYA','KRA 9 #2-95'); 
INSERT INTO  Productor VALUES('000000006P','Fabricio','Summer','1225549870','3257469999','fabricio.summer@gmail.com','QUINDÍO','CALARCA','KRA 10 #2-01'); 
INSERT INTO  Productor VALUES('000000007P','Amelia','Aguiluz','1325549870','3256749999','amelia.aguiluz@gmail.com','QUINDÍO','SALENTO','KRA 11 #2-36'); 
INSERT INTO  Productor VALUES('000000008P','Erick','Rodriguez','1425549870','3257569999','erick.rodriguez@gmail.com','QUINDÍO','PIJAO','KRA 12 #2-54'); 
INSERT INTO  Productor VALUES('000000009P','Tadeo','Perez','1525549870','3256769999','tadeo.perez@gmail.com','QUINDÍO','MONTENEGRO','KRA 13 #2-89'); 
INSERT INTO  Productor VALUES('000000010P','Pedro','Osorio','1625549870','3257769999','pedro.osorio@gmail.com','QUINDÍO','SALENTO','KRA 14 #2-41'); 
INSERT INTO  Productor VALUES('000000011P','Miguel','Chavez','1025549871','3257869999','miguel.chavez@hotmail.com','CALDAS','SAN JOSE','KRA 2 #5-89'); 
INSERT INTO  Productor VALUES('000000012P','Ricardo','Juarez','1025549872','3256889999','ricardo.juarez@hotmail.com','CALDAS','VITERBO','KRA 16 #8-89'); 
INSERT INTO  Productor VALUES('000000013P','Cristina','Solano','1025549873','3256899999','cristina.solano@hotmail.com','CALDAS','RISARALDA','KRA 17 #2-89'); 
INSERT INTO  Productor VALUES('000000014P','Gabriela','Benjumea','1025549874','3256909999','Gabriela.benjumea@hotmail.com','CALDAS','MARULANDA','KRA 18 #2-89'); 
INSERT INTO  Productor VALUES('000000015P','Rosalin','Betancourt','1025549875','3256919999','rosalin.betan@hotmail.com','CALDAS','PENSILVANIA','KRA 19 #2-89'); 
INSERT INTO  Productor VALUES('000000016P','Rodrigo','Diaz','1025549876','3256929999','rodrigo.diaz@hotmail.com','CALDAS','NEIRA','KRA 20 #2-89'); 
INSERT INTO  Productor VALUES('000000017P','Danilo','Urie','1025549877','3256939999','danilo.urie@hotmail.com','CALDAS','VITERBO','KRA 21 #2-89'); 
INSERT INTO  Productor VALUES('000000018P','Gabriel','Ferrer','1025549878','3256949999','gabriel.ferrer@hotmail.com','CALDAS','BELALCAZAR','KRA 22 #2-89'); 
INSERT INTO  Productor VALUES('000000019P','David','Jimenez','1025549879','3256959999','david.jimenez@hotmail.com','CALDAS','BELALCAZAR','KRA 23 #2-89'); 
INSERT INTO  Productor VALUES('000000020P','Jhonatan','Torres','1025549880','3256969999','jhonatan.torres@hotmail.com','CALDAS','SAN JOSE','KRA 3 #2-89'); 
INSERT INTO  Productor VALUES('000000021P','Miguel','Chavez','1025549881','3257897999','miguel.chavez@hotmail.com','RISARALDA','APÍA','KRA 15 #5-89'); 
INSERT INTO  Productor VALUES('000000022P','Ricardo','Juarez','1025549882','3256989999','ricardo.juarez@hotmail.com','RISARALDA','GUÁTICA','KRA 16 #8-89'); 
INSERT INTO  Productor VALUES('000000023P','Cristina','Solano','1025549883','3256999999','cristina.solano@hotmail.com','RISARALDA','LA CELIA','KRA 17 #2-89'); 
INSERT INTO  Productor VALUES('000000024P','Gabriela','Benjumea','1025549844','3251009999','Gabriela.benjumea@hotmail.com','RISARALDA','SANTUARIO','KRA 18 #2-89'); 
INSERT INTO  Productor VALUES('000000025P','Rosalin','Betancourt','1025549885','3256101999','rosalin.betan@hotmail.com','RISARALDA','QUINCHÍA','KRA 19 #2-89'); 
INSERT INTO  Productor VALUES('000000026P','Rodrigo','Diaz','1025549886','3256102999','rodrigo.diaz@hotmail.com','RISARALDA','LA VIRGINIA','KRA 20 #2-89'); 
INSERT INTO  Productor VALUES('000000027P','Danilo','Urie','1025549887','3256102899','danilo.urie@hotmail.com','RISARALDA','SANTUARIO','KRA 21 #2-89'); 
INSERT INTO  Productor VALUES('000000028P','Gabriel','Ferrer','1025549888','3256103999','gabriel.ferrer@hotmail.com','RISARALDA','LA CELIA','KRA 22 #2-89'); 
INSERT INTO  Productor VALUES('000000029P','David','Jimenez','1025549889','3256104999','david.jimenez@hotmail.com','RISARALDA','GUÁTICA','KRA 23 #2-89'); 
INSERT INTO  Productor VALUES('000000030P','Jhonatan','Torres','1025549890','3256105999','jhonatan.torres@hotmail.com','RISARALDA','APÍA','KRA 24 #2-89'); 
INSERT INTO  Productor VALUES('000000031P','Justin','Aguiluz','1325549891','3256106999','justin.aguiluz@gmail.com','QUINDÍO','SALENTO','El Jardin'); 
INSERT INTO  Productor VALUES('000000032P','Molly','Rodriguez','1425549892','3256107999','molly.rodriguez@gmail.com','QUINDÍO','PIJAO','El Paraiso'); 
INSERT INTO  Productor VALUES('000000033P','Hilda','Perez','1525549893','3256108999','maria.perez@gmail.com','QUINDÍO','MONTENEGRO','La Luna'); 
INSERT INTO  Productor VALUES('000000034P','Dolores','Osorio','1625549894','3257108999','dolores.osorio@gmail.com','QUINDÍO','SALENTO','El Eden');
INSERT INTO  Productor VALUES('000000035P','Esteban','Ferrer','1025549895','3256109999','esteban.ferrer@hotmail.com','CALDAS','BELALCAZAR','Agualinda'); 
INSERT INTO  Productor VALUES('000000036P','Gerardo','Jimenez','1025549896','3251109999','gerardo.jimenez@hotmail.com','CALDAS','BELALCAZAR','El Paisaje'); 
INSERT INTO  Productor VALUES('000000037P','Joseph','Torres','1025549897','3256111999','jodeph.torres@hotmail.com','CALDAS','SAN JOSE','Aguamarina'); 
INSERT INTO  Productor VALUES('000000038P','Rigoberto','Diaz','1025549898','3251122999','rigoberto.diaz@hotmail.com','RISARALDA','LA VIRGINIA','Greenday');
INSERT INTO  Productor VALUES('000000039P','Adolfo','Torres','1025549899','3256113999','adolfo.torres@hotmail.com','RISARALDA','APÍA','El Iris'); 


--------------- CUENTA CONSIGNACIÓN ------------------
INSERT INTO CuentaConsignacion VALUES('C001C','1507','3256669999','000000001P');
INSERT INTO CuentaConsignacion VALUES('C002C','1040','3256670999','000000002P');
INSERT INTO CuentaConsignacion VALUES('C003C','1551','3256671999','000000003P');
INSERT INTO CuentaConsignacion VALUES('C004C','1507','3256667299','000000004P');
INSERT INTO CuentaConsignacion VALUES('C005C','1040','3257369999','000000005P');
INSERT INTO CuentaConsignacion VALUES('C006C','1551','3257469999','000000006P');
INSERT INTO CuentaConsignacion VALUES('C007C','1040','3256749999','000000007P');
INSERT INTO CuentaConsignacion VALUES('C008C','1551','3257569999','000000008P');
INSERT INTO CuentaConsignacion VALUES('C009C','1551','3256769999','000000009P');
INSERT INTO CuentaConsignacion VALUES('C010C','1507','3257769999','000000010P');
INSERT INTO CuentaConsignacion VALUES('C011C','1040','3257869999','000000011P');
INSERT INTO CuentaConsignacion VALUES('C012C','1507','3256889999','000000012P');
INSERT INTO CuentaConsignacion VALUES('C013C','1040','3256899999','000000013P');
INSERT INTO CuentaConsignacion VALUES('C014C','1040','3256909999','000000014P');
INSERT INTO CuentaConsignacion VALUES('C015C','1507','3256919999','000000015P');
INSERT INTO CuentaConsignacion VALUES('C016C','1507','3256929999','000000016P');
INSERT INTO CuentaConsignacion VALUES('C017C','1551','3256939999','000000017P');
INSERT INTO CuentaConsignacion VALUES('C018C','1007','03256949999','000000018P');
INSERT INTO CuentaConsignacion VALUES('C019C','1507','3256959999','000000019P');
INSERT INTO CuentaConsignacion VALUES('C020C','1007','03256969999','000000020P');
INSERT INTO CuentaConsignacion VALUES('C021C','1801','3257897999','000000021P');
INSERT INTO CuentaConsignacion VALUES('C022C','1007','03256989999','000000022P');
INSERT INTO CuentaConsignacion VALUES('C023C','1507','3256999999','000000023P');
INSERT INTO CuentaConsignacion VALUES('C024C','1551','3251009999','000000024P');
INSERT INTO CuentaConsignacion VALUES('C025C','1507','3256101999','000000025P');
INSERT INTO CuentaConsignacion VALUES('C026C','1040','3256102999','000000026P');
INSERT INTO CuentaConsignacion VALUES('C027C','1007','03256102899','000000027P');
INSERT INTO CuentaConsignacion VALUES('C028C','1551','3256103999','000000028P');
INSERT INTO CuentaConsignacion VALUES('C029C','1551','3256104999','000000029P');
INSERT INTO CuentaConsignacion VALUES('C030C','1040','3256105999','000000030P');
INSERT INTO CuentaConsignacion VALUES('C031C','1551','3256106999','000000031P');
INSERT INTO CuentaConsignacion VALUES('C032C','1801','3256107999','000000032P');
INSERT INTO CuentaConsignacion VALUES('C033C','1507','3256108999','000000033P');
INSERT INTO CuentaConsignacion VALUES('C034C','1801','3257108999','000000034P');
INSERT INTO CuentaConsignacion VALUES('C035C','1507','3256109999','000000035P');
INSERT INTO CuentaConsignacion VALUES('C036C','1801','3251109999','000000036P');
INSERT INTO CuentaConsignacion VALUES('C037C','1507','3256111999','000000037P');
INSERT INTO CuentaConsignacion VALUES('C038C','1507','3251122999','000000038P');
INSERT INTO CuentaConsignacion VALUES('C039C','1801','3256113999','000000039P');


--------------- FINCA -------------------------

INSERT INTO  Finca VALUES('000000001F','El Jardin','QUINDÍO','SALENTO','La Julia','4.640340, -75.576294',18000); 
INSERT INTO  Finca VALUES('000000002F','El Paraiso','QUINDÍO','PIJAO','La torre','4.341234, -75.700330',16400); 
INSERT INTO  Finca VALUES('000000003F','La Luna','QUINDÍO','MONTENEGRO','El cacho','4.561800, -75.760424',12000); 
INSERT INTO  Finca VALUES('000000004F','El Eden','QUINDÍO','SALENTO','El cuerno','4.648064, -75.570482',22000);
INSERT INTO  Finca VALUES('000000005F','Agualinda','CALDAS','BELALCAZAR','Vacaloka','5.018730, -75.795985',11000); 
INSERT INTO  Finca VALUES('000000006F','El Paisaje','CALDAS','BELALCAZAR','Cuernavaca','4.980006, -75.812760',34000); 
INSERT INTO  Finca VALUES('000000007F','Aguamarina','CALDAS','SAN JOSE','El contento','5.086697, -75.799765',16000); 
INSERT INTO  Finca VALUES('000000008F','Greenday','RISARALDA','LA VIRGINIA','El toreto','4.900485, -75.858790',25000);
INSERT INTO  Finca VALUES('000000009F','El Iris','RISARALDA','APÍA','El agunaldo','5.100078, -75.950973',21000);

INSERT INTO  Finca VALUES('000000010F','El Isis','QUINDÍO','MONTENEGRO','El cazador','5.100078, -75.950973',21000);
INSERT INTO  Finca VALUES('000000011F','El Pascal','QUINDÍO','SALENTO','La caza','4.640340, -75.576294',18000); 

INSERT INTO  Finca VALUES('000000012F','El milimetro','CALDAS','SAN JOSE','El perro feliz','4.412384, -75.790330',16400); 
INSERT INTO  Finca VALUES('000000013F','La Mercuria','CALDAS','RISARALDA','La petunia','4.618080, -75.790424',12000); 
INSERT INTO  Finca VALUES('000000014F','Ostras','CALDAS','MARULANDA','El caharro','4.480684, -75.590482',28000);
INSERT INTO  Finca VALUES('000000015F','La Ortogonal','CALDAS','NEIRA','Aranjueces','5.187380, -75.790985',94000); 
INSERT INTO  Finca VALUES('000000016F','El paisay','CALDAS','VITERBO','El filtro','4.800086, -75.890760',34000); 
INSERT INTO  Finca VALUES('000000017F','La mermeid','CALDAS','BELALCAZAR','El notch','5.866987, -75.790765',16000); 
INSERT INTO  Finca VALUES('000000018F','Sirenas','CALDAS','BELALCAZAR','El paseo','4.004885, -75.890790',55000);
INSERT INTO  Finca VALUES('000000019F','La Finquita','CALDAS','BELALCAZAR','El paseo','4.004585, -75.990690',55000);
INSERT INTO  Finca VALUES('000000020F','El cambio','CALDAS','SAN JOSE','El pueblo','5.000788, -75.990973',35000);

INSERT INTO  Finca VALUES('000000021F','Las Sierras','RISARALDA','APÍA','El pato','5.800778, -75.250973',21000);
INSERT INTO  Finca VALUES('000000022F','La tibia','RISARALDA','GUÁTICA','La garacha','4.840740, -75.256294',18000); 
INSERT INTO  Finca VALUES('000000023F','El peroné','RISARALDA','SAN JOSE','La José','4.841734, -75.250330',16400); 
INSERT INTO  Finca VALUES('000000024F','La home','RISARALDA','LA CELIA','Taciturnia','4.861700, -75.250424',15400); 
INSERT INTO  Finca VALUES('000000025F','El Fasanfurius','RISARALDA','SANTUARIO','Esperanza','4.848764, -75.250482',22000);
INSERT INTO  Finca VALUES('000000026F','Lasso Peeta','RISARALDA','QUINCHÍA','La Pata','4.848764, -75.250482',99000);

------------ CERTIFICACION POR FINCA ------------------

INSERT INTO CertificacionXFinca VALUES('0000','000000001F','24/08/2016','14/07/2024');
INSERT INTO CertificacionXFinca VALUES('0001','000000001F','15/07/2014','14/07/2024');
INSERT INTO CertificacionXFinca VALUES('0010','000000001F','14/12/2015','14/07/2024');

INSERT INTO CertificacionXFinca VALUES('0101','000000002F','14/12/2020','01/08/2024');
INSERT INTO CertificacionXFinca VALUES('0010','000000002F','09/10/2019','01/08/2024');

INSERT INTO CertificacionXFinca VALUES('0000','000000003F','23/05/2015','23/05/2022');
INSERT INTO CertificacionXFinca VALUES('0001','000000003F','13/08/2016','25/03/2023');
INSERT INTO CertificacionXFinca VALUES('0010','000000003F','11/10/2014','23/05/2022');
INSERT INTO CertificacionXFinca VALUES('0101','000000003F','06/06/2017','03/05/2023');

INSERT INTO CertificacionXFinca VALUES('0000','000000004F','23/05/2015','23/05/2022');
INSERT INTO CertificacionXFinca VALUES('0001','000000004F','13/08/2016','25/03/2023');
INSERT INTO CertificacionXFinca VALUES('0010','000000004F','11/10/2015','23/01/2022');
INSERT INTO CertificacionXFinca VALUES('0011','000000004F','02/01/2017','03/03/2023');
INSERT INTO CertificacionXFinca VALUES('0100','000000004F','03/03/2018','03/06/2023');
INSERT INTO CertificacionXFinca VALUES('0101','000000004F','11/09/2018','03/12/2023');

INSERT INTO CertificacionXFinca VALUES('0001','000000005F','16/11/2018','23/05/2022');
INSERT INTO CertificacionXFinca VALUES('0000','000000005F','08/11/2018','23/05/2022');

INSERT INTO CertificacionXFinca VALUES('0101','000000006F','13/09/2017','13/09/2022');

INSERT INTO CertificacionXFinca VALUES('0001','000000007F','14/10/2016','05/07/2024');
INSERT INTO CertificacionXFinca VALUES('0010','000000007F','25/07/2014','09/10/2023');
INSERT INTO CertificacionXFinca VALUES('0000','000000007F','04/04/2015','15/05/2024');

INSERT INTO CertificacionXFinca VALUES('0011','000000008F','14/02/2016','05/07/2023');
INSERT INTO CertificacionXFinca VALUES('0010','000000008F','25/06/2016','09/09/2022');

INSERT INTO CertificacionXFinca VALUES('0000','000000009F','14/10/2016','05/07/2024');
INSERT INTO CertificacionXFinca VALUES('0100','000000009F','25/07/2014','09/10/2023');
INSERT INTO CertificacionXFinca VALUES('0101','000000009F','04/04/2015','15/05/2024');

INSERT INTO CertificacionXFinca VALUES('0001','000000010F','02/05/2020','01/04/2024');

INSERT INTO CertificacionXFinca VALUES('0011','000000011F','13/02/2018','05/07/2024');

INSERT INTO CertificacionXFinca VALUES('0000','000000012F','13/09/2016','05/07/2024');
INSERT INTO CertificacionXFinca VALUES('0001','000000012F','26/08/2014','09/10/2023');
INSERT INTO CertificacionXFinca VALUES('0010','000000012F','08/03/2015','12/05/2024');
INSERT INTO CertificacionXFinca VALUES('0100','000000012F','02/02/2015','15/06/2022');

INSERT INTO CertificacionXFinca VALUES('0000','000000013F','13/12/2018','05/07/2024');
INSERT INTO CertificacionXFinca VALUES('0001','000000013F','06/10/2019','09/10/2025');
INSERT INTO CertificacionXFinca VALUES('0010','000000013F','08/09/2020','12/05/2026');
INSERT INTO CertificacionXFinca VALUES('0011','000000013F','05/06/2021','15/06/2025');
INSERT INTO CertificacionXFinca VALUES('0100','000000013F','07/04/2020','15/07/2025');

INSERT INTO CertificacionXFinca VALUES('0001','000000014F','06/08/2019','09/10/2023');
INSERT INTO CertificacionXFinca VALUES('0000','000000014F','25/01/2020','12/05/2024');
INSERT INTO CertificacionXFinca VALUES('0100','000000014F','20/02/2021','15/06/2022');
INSERT INTO CertificacionXFinca VALUES('0101','000000014F','27/05/2020','15/07/2022');

INSERT INTO CertificacionXFinca VALUES('0001','000000015F','26/07/2019','05/11/2024');
INSERT INTO CertificacionXFinca VALUES('0000','000000015F','21/02/2020','12/05/2024');

INSERT INTO CertificacionXFinca VALUES('0000','000000016F','01/01/2016','03/01/2022');
INSERT INTO CertificacionXFinca VALUES('0001','000000016F','02/03/2016','02/02/2023');
INSERT INTO CertificacionXFinca VALUES('0010','000000016F','03/12/2017','24/08/2022');
INSERT INTO CertificacionXFinca VALUES('0011','000000016F','04/07/2017','09/10/2023');
INSERT INTO CertificacionXFinca VALUES('0100','000000016F','10/09/2018','02/11/2023');
INSERT INTO CertificacionXFinca VALUES('0101','000000016F','15/11/2019','07/02/2023');

INSERT INTO CertificacionXFinca VALUES('0011','000000017F','03/08/2015','09/01/2024');
INSERT INTO CertificacionXFinca VALUES('0100','000000017F','11/07/2017','05/10/2024');
INSERT INTO CertificacionXFinca VALUES('0101','000000017F','14/03/2020','07/03/2024');

INSERT INTO CertificacionXFinca VALUES('0101','000000018F','03/09/2015','09/01/2024');
INSERT INTO CertificacionXFinca VALUES('0000','000000018F','12/08/2017','05/11/2025');
INSERT INTO CertificacionXFinca VALUES('0001','000000018F','11/02/2020','07/09/2023');

--'000000019F' No tiene

INSERT INTO CertificacionXFinca VALUES('0011','000000020F','02/07/2016','14/02/2024');
INSERT INTO CertificacionXFinca VALUES('0000','000000020F','15/11/2017','06/10/2025');
INSERT INTO CertificacionXFinca VALUES('0001','000000020F','17/12/2010','08/08/2023');

INSERT INTO CertificacionXFinca VALUES('0000','000000021F','11/10/2017','06/10/202');
INSERT INTO CertificacionXFinca VALUES('0010','000000021F','13/06/2015','08/08/2021');

INSERT INTO CertificacionXFinca VALUES('0000','000000022F','22/05/2019','03/08/2022');

--'000000023F' No tiene

INSERT INTO CertificacionXFinca VALUES('0000','000000024F','22/05/2020','03/09/2022');
INSERT INTO CertificacionXFinca VALUES('0001','000000024F','03/12/2020','03/12/2022');

INSERT INTO CertificacionXFinca VALUES('0000','000000025F','22/05/2010','13/09/2023');
INSERT INTO CertificacionXFinca VALUES('0101','000000025F','29/11/2018','03/12/2024');
INSERT INTO CertificacionXFinca VALUES('0010','000000025F','21/07/2017','04/09/2022');
INSERT INTO CertificacionXFinca VALUES('0100','000000025F','03/07/2019','12/12/2024');

--'000000026F' No tiene

-- PRODUCTO

--Frutas
INSERT INTO Producto VALUES('P00000001P','Plátano Verde','0001A');
INSERT INTO Producto VALUES('P00000002P','Plátano Maduro','0001A');
INSERT INTO Producto VALUES('P00000003P','Plátano Pinton','0001A');
INSERT INTO Producto VALUES('P00000004P','Maracuyá','0001A');
INSERT INTO Producto VALUES('P00000005P','Tomate de Arbol','0001A');
INSERT INTO Producto VALUES('P00000006P','Manzana','0001A');
INSERT INTO Producto VALUES('P00000007P','Peras','0001A');
INSERT INTO Producto VALUES('P00000008P','Banano','0001A');
INSERT INTO Producto VALUES('P00000009P','Uva','0001A');
INSERT INTO Producto VALUES('P00000010P','Uva Verde','0001A');
INSERT INTO Producto VALUES('P00000011P','Fresa','0001A');
INSERT INTO Producto VALUES('P00000012P','Guanabana','0001A');
INSERT INTO Producto VALUES('P00000013P','Piña','0001A');
INSERT INTO Producto VALUES('P00000014P','Mango','0001A');
INSERT INTO Producto VALUES('P00000015P','Durazno','0001A');
INSERT INTO Producto VALUES('P00000016P','Durazno','0001A');
INSERT INTO Producto VALUES('P00000017P','Pitaya','0001A');
INSERT INTO Producto VALUES('P00000018P','Papaya','0001A');
INSERT INTO Producto VALUES('P00000019P','Aguacate','0001A');
INSERT INTO Producto VALUES('P00000020P','Guayaba','0001A');
INSERT INTO Producto VALUES('P00000021P','Guayaba','0001A');
INSERT INTO Producto VALUES('P00000022P','Naranja','0001A');
INSERT INTO Producto VALUES('P00000023P','Limon','0001A');
INSERT INTO Producto VALUES('P00000024P','Mandarina','0001A');
INSERT INTO Producto VALUES('P00000025P','Coco','0001A');

--0000A VEGETALES

INSERT INTO Producto VALUES('P00000026P','Espinaca','0000A');
INSERT INTO Producto VALUES('P00000027P','Cebolla Larga','0000A');
INSERT INTO Producto VALUES('P00000028P','Col China','0000A');
INSERT INTO Producto VALUES('P00000029P','Repollo Morado','0000A');
INSERT INTO Producto VALUES('P00000030P','Repollo Blanco','0000A');
INSERT INTO Producto VALUES('P00000031P','Calabazas','0000A');
INSERT INTO Producto VALUES('P00000032P','Espárragos','0000A');
INSERT INTO Producto VALUES('P00000033P','Champiñones','0000A');
INSERT INTO Producto VALUES('P00000034P','Ahuyama','0000A');
INSERT INTO Producto VALUES('P00000035P','Zanahoria','0000A');
INSERT INTO Producto VALUES('P00000036P','Pimentón','0000A');
INSERT INTO Producto VALUES('P00000037P','Remolacha','0000A');
INSERT INTO Producto VALUES('P00000038P','Pepino','0000A');
INSERT INTO Producto VALUES('P00000039P','Habichuela','0000A');
INSERT INTO Producto VALUES('P00000040P','Cebolla Cabezona','0000A');

--Tuberculos 0010A
INSERT INTO Producto VALUES('P00000041P','Papa Criolla','0010A');
INSERT INTO Producto VALUES('P00000042P','Papa','0010A');
INSERT INTO Producto VALUES('P00000043P','Yuca','0010A');
INSERT INTO Producto VALUES('P00000044P','Ñame','0010A');
INSERT INTO Producto VALUES('P00000045P','Jengibre','0010A');

--GRANOS 0011A
INSERT INTO Producto VALUES('P00000046P','Maiz','0011A');
INSERT INTO Producto VALUES('P00000047P','Frijol','0011A');
INSERT INTO Producto VALUES('P00000048P','Lentejas','0011A');
INSERT INTO Producto VALUES('P00000049P','Garbanzos','0011A');
INSERT INTO Producto VALUES('P00000050P','Blanquillos','0011A');
INSERT INTO Producto VALUES('P00000051P','Cebada','0011A');
INSERT INTO Producto VALUES('P00000052P','Arroz','0011A');

--'0101A','DulceS'
INSERT INTO Producto VALUES('P00000053P','Panela','0101A');
INSERT INTO Producto VALUES('P00000054P','Miel','0101A');
INSERT INTO Producto VALUES('P00000055P','Dulce de Guayaba','0010A');
INSERT INTO Producto VALUES('P00000056P','Arequipe de Café','0101A');
INSERT INTO Producto VALUES('P00000057P','Arequipe de Chocolate','0101A');
INSERT INTO Producto VALUES('P00000058P','Arequipe de Banano','0101A');
INSERT INTO Producto VALUES('P00000059P','Bocadillo de plátano','0101A');
INSERT INTO Producto VALUES('P00000060P','Cocada de plátano','0101A');
INSERT INTO Producto VALUES('P00000061P','ChocoBoom','0101A');
INSERT INTO Producto VALUES('P00000062P','Caja Dorada','0101A');
INSERT INTO Producto VALUES('P00000063P','Caja Santo Aroma','0101A');
INSERT INTO Producto VALUES('P00000064P','Puro Cacao Nibs','0101A');

--'0111A','Lacteos'
INSERT INTO Producto VALUES('P00000065P','Leche Clarita','0111A');
INSERT INTO Producto VALUES('P00000066P','Leche Esperanza','0111A');
INSERT INTO Producto VALUES('P00000067P','Leche La Vaca','0111A');
INSERT INTO Producto VALUES('P00000068P','Leche La Lechera','0111A');
INSERT INTO Producto VALUES('P00000069P','Leche Manchitas','0111A');
INSERT INTO Producto VALUES('P00000070P','Yogurt Cristiano','0111A');
INSERT INTO Producto VALUES('P00000071P','Yogurt ElCampy','0111A');
INSERT INTO Producto VALUES('P00000072P','Yogurt QueRiko','0111A');
INSERT INTO Producto VALUES('P00000073P','Yogurt MasMejor','0111A');
INSERT INTO Producto VALUES('P00000074P','Kumis Veneko','0011A');
INSERT INTO Producto VALUES('P00000075P','Kumis Muu','0011A');
INSERT INTO Producto VALUES('P00000076P','Kumis QuieoKumis','0011A');
INSERT INTO Producto VALUES('P00000077P','Crema de Leche soy','0011A');
INSERT INTO Producto VALUES('P00000078P','Crema de Leche Muu','0011A');
INSERT INTO Producto VALUES('P00000079P','Crema de Leche LasMas','0011A');
INSERT INTO Producto VALUES('P00000080P','Queso Campesino Quisi','0011A');
INSERT INTO Producto VALUES('P00000081P','Queso Campesino UwU','0011A');
INSERT INTO Producto VALUES('P00000082P','Queso Campesino Mas Vaca','0011A');
INSERT INTO Producto VALUES('P00000083P','Queso Consteño','0011A');
INSERT INTO Producto VALUES('P00000084P','Queso Doble Crema Estira','0011A');
INSERT INTO Producto VALUES('P00000085P','Queso Doble Crema Wuw','0011A');
INSERT INTO Producto VALUES('P00000086P','Queso Doble Crema Vaquita','0011A');

--'1011A','Salud y Belleza'
INSERT INTO Producto VALUES('P00000087P','Honolulu Jabón Artesanal','1011A');
INSERT INTO Producto VALUES('P00000088P','Honolulu Exfoliante café','1011A');
INSERT INTO Producto VALUES('P00000089P','Agua Micelar','1011A');
INSERT INTO Producto VALUES('P00000090P','Aceite de Coco','1011A');
INSERT INTO Producto VALUES('P00000091P','Crema Antifósil','1011A'); 
INSERT INTO Producto VALUES('P00000092P','Shampoo Dilvage','1011A');
INSERT INTO Producto VALUES('P00000093P','Aceite de Aguacate','1011A');
INSERT INTO Producto VALUES('P00000094P','Shampoo de Aguacate','1011A');

--'1111A','Procesados'
INSERT INTO Producto VALUES('P00000095P','Maracuyitos','1111A');
INSERT INTO Producto VALUES('P00000096P','PlatiRicos','1111A');
INSERT INTO Producto VALUES('P00000097P','Marranitas Patachin','1111A');
INSERT INTO Producto VALUES('P00000098P','Aborrajaos Patachin','1111A');
INSERT INTO Producto VALUES('P00000099P','Patachin Toston','1111A');
INSERT INTO Producto VALUES('P00000100P','ChocoRico','1111A');
INSERT INTO Producto VALUES('P00000101P','Tajaditos','1111A');
INSERT INTO Producto VALUES('P00000102P','Pobs','1111A');
INSERT INTO Producto VALUES('P00000103P','Manolito','1111A');
INSERT INTO Producto VALUES('P00000104P','ChocoCofee','1111A');

--'0000B','Especias'
INSERT INTO Producto VALUES('P00000105P','Orégano Escama','0000B');
INSERT INTO Producto VALUES('P00000106P','Tomillo','0000B');
INSERT INTO Producto VALUES('P00000107P','Romero','0000B');
INSERT INTO Producto VALUES('P00000108P','Orégano Fresco','0000B');
INSERT INTO Producto VALUES('P00000109P','Guasca','0000B');
INSERT INTO Producto VALUES('P00000110P','Laurel','0000B');
INSERT INTO Producto VALUES('P00000111P','Menta','0000B');
INSERT INTO Producto VALUES('P00000112P','Cilantro','0000B');
INSERT INTO Producto VALUES('P00000113P','Perejil','0000B');
INSERT INTO Producto VALUES('P00000114P','Ajo','0000B');


------------- PRODUCTO EN VENTA ---------------
--INSERT INTO ProductoEnVenta VALUES('IdProductoEnVenta','IdProductor','IdFinca','IdProducto','Precio','Descripcion','Fecha','Cantidad','EstadoProducto');

-- NO TIENE FINCA
INSERT INTO ProductoEnVenta VALUES('PV00000001','000000001P',NULL,'P00000097P',2000,'RICAS MARRANITAS','11/01/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000002','000000001P',NULL,'P00000098P',2500,'RICOS ABORRAJAOS','11/01/2021',28,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000003','000000001P',NULL,'P00000102P',3000,'RICOS POPS','11/01/2021',10,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000004','000000001P',NULL,'P00000097P',2000,'RICAS MARRANITAS','04/05/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000005','000000001P',NULL,'P00000098P',2500,'RICOS ABORRAJAOS','04/05/2021',28,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000006','000000001P',NULL,'P00000102P',3000,'RICOS POPS','04/05/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000007','000000001P',NULL,'P00000097P',2000,'RICAS MARRANITAS','11/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000008','000000001P',NULL,'P00000098P',2500,'RICOS ABORRAJAOS','11/07/2021',28,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000009','000000001P',NULL,'P00000102P',3000,'RICOS POPS','11/07/2021',10,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000010','000000002P',NULL,'P00000095P',4000,'RICO PLATANITOS DE 35 gr X12','01/06/2021',25,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000011','000000002P',NULL,'P00000095P',6000,'RICOS PLATANITOS DE 50 gr X12','01/06/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000012','000000002P',NULL,'P00000095P',4000,'RICO PLATANITOS DE 35 gr X12','01/07/2021',25,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000413','000000002P',NULL,'P00000095P',6000,'RICOS PLATANITOS DE 50 gr X12','01/07/2021',18,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000412','000000003P',NULL,'P00000096P',6000,'RICOS PLATANITOS SABOR MARACUYÁ X12','01/07/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000014','000000003P',NULL,'P00000096P',6000,'RICOS PLATANITOS SABOR LIMÓN X12','01/07/2021',11,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000015','000000003P',NULL,'P00000096P',6000,'RICOS PLATANITOS SABOR RANCHERO X12','01/07/2021',6,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000016','000000003P',NULL,'P00000096P',6000,'RICOS PLATANITOS SABOR MARACUYÁ X12','01/07/2021',11,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000017','000000003P',NULL,'P00000096P',6000,'RICOS PLATANITOS SABOR LIMÓN X12','01/07/2021',8,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000018','000000003P',NULL,'P00000096P',6000,'RICOS PLATANITOS SABOR RANCHERO X12','01/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000019','000000004P',NULL,'P00000099P',7000,'PATACONES TOSTADOS','01/07/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000020','000000004P',NULL,'P00000099P',7000,'PATACONES TOSTADOS','04/07/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000021','000000004P',NULL,'P00000099P',7000,'PATACONES TOSTADOS','28/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000022','000000005P',NULL,'P00000100P',7000,'RICOS CHOCOLATES','04/06/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000023','000000005P',NULL,'P00000101P',7000,'PATACONES TOSTADODITOS','04/06/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000024','000000005P',NULL,'P00000100P',7000,'RICOS CHOCOLATES','28/07/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000025','000000005P',NULL,'P00000101P',7000,'PATACONES TOSTADODITOS','28/07/2021',15,'AGOTADO');

INSERT INTO ProductoEnVenta VALUES('PV00000026','000000006P',NULL,'P00000106P',7000,'PATACONES TOSTADODITOS','28/02/2021',11,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000027','000000006P',NULL,'P00000104P',7000,'PATACONES TOSTADODITOS','28/02/2021',6,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000028','000000006P',NULL,'P00000106P',7000,'PATACONES TOSTADODITOS','17/07/2021',11,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000029','000000006P',NULL,'P00000104P',7000,'PATACONES TOSTADODITOS','17/07/2021',6,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000030','000000007P',NULL,'P00000057P',5000,'AREQUIPE DELICIOSOS DE CHOCOLATE','14/02/2021',8,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000031','000000007P',NULL,'P00000058P',6000,'AREQUIPE DELICIOSOS DE BANANO','15/02/2021',6,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000032','000000007P',NULL,'P00000059P',4000,'RICO BOCADILLO','22/02/2021',2,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000033','000000007P',NULL,'P00000060P',2000,'COCADA DULCE DE PLÁTANO','28/02/2021',5,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000034','000000007P',NULL,'P00000061P',3000,'RICOS CHOCOLATES','23/02/2021',8,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000035','000000007P',NULL,'P00000057P',2000,'AREQUIPE DELICIOSOS DE CHOCOLATE','14/07/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000036','000000007P',NULL,'P00000058P',3500,'AREQUIPE DELICIOSOS DE BANANO','15/07/2021',6,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000037','000000007P',NULL,'P00000059P',4500,'RICO BOCADILLO','22/07/2021',2,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000038','000000007P',NULL,'P00000060P',4500,'COCADA DULCE DE PLÁTANO','28/07/2021',5,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000039','000000007P',NULL,'P00000061P',5500,'RICOS CHOCOLATES','23/07/2021',8,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000040','000000008P',NULL,'P00000053P',6000,'RICA PANELA PLATA','23/04/2021',8,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000041','000000008P',NULL,'P00000054P',8000,'FULL MIEL DE ABEJA','23/04/2021',7,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000042','000000008P',NULL,'P00000055P',7000,'DELICIOSO DULCE DE GUAYABA','23/04/2021',4,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000043','000000008P',NULL,'P00000056P',5000,'NUEVO SABOR A CAFÉ','23/04/2021',9,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000044','000000008P',NULL,'P00000057P',4500,'RICOS CHOCOLATES','23/04/2021',11,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000441','000000008P',NULL,'P00000054P',8500,'FULL MIEL DE ABEJA','23/07/2021',14,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000442','000000008P',NULL,'P00000055P',6800,'DELICIOSO DULCE DE GUAYABA','23/07/2021',47,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000444','000000008P',NULL,'P00000057P',4000,'RICOS CHOCOLATES','23/07/2021',13,'AGOTADO');

INSERT INTO ProductoEnVenta VALUES('PV00000045','000000027P',NULL,'P00000087P',9000,'BUEN JABÓN ARTESANAL','15/03/2021',13,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000046','000000027P',NULL,'P00000088P',8600,'CAFE EXFOLIADOR','09/04/2021',13,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000047','000000027P',NULL,'P00000087P',8400,'BUEN JABÓN ARTESANAL','15/05/2021',13,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000048','000000027P',NULL,'P00000088P',9000,'CAFE EXFOLIADOR','09/05/2021',13,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000049','000000027P',NULL,'P00000087P',10000,'BUEN JABÓN ARTESANAL','15/07/2021',13,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000050','000000027P',NULL,'P00000088P',9600,'CAFE EXFOLIADOR','09/07/2021',13,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000051','000000028P',NULL,'P00000053P',5500,'LA BUENA PANELA','09/02/2021',8,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000052','000000028P',NULL,'P00000062P',9600,'CAJA DORADA SABROSA DE CHOCOLATE','09/03/2021',6,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000053','000000028P',NULL,'P00000063P',9600,'RICO CAFÉ BUEN AROMA','09/01/2021',3,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000054','000000028P',NULL,'P00000064P',9600,'CHOCOLATINA PURO NIBS','09/05/2021',11,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000055','000000028P',NULL,'P00000089P',9600,'RICA PARA LA PIEL','09/04/2021',9,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000056','000000028P',NULL,'P00000090P',9600,'BUEN ACEITE','09/02/2021',7,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000057','000000028P',NULL,'P00000063P',9600,'RICO CAFÉ BUEN AROMA','09/07/2021',3,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000058','000000028P',NULL,'P00000064P',9600,'CHOCOLATINA PURO NIBS','09/06/2021',11,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000059','000000028P',NULL,'P00000089P',9600,'RICA PARA LA PIEL','09/06/2021',9,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000060','000000029P',NULL,'P00000057P',4000,'RICOS CHOCOLATES','19/02/2021',13,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000061','000000029P',NULL,'P00000060P',4500,'COCADA DULCE DE PLÁTANO','18/04/2021',5,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000062','000000029P',NULL,'P00000061P',2500,'RICOS CHOCOLATES','13/01/2021',8,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000063','000000029P',NULL,'P00000091P',5500,'CREMA ANTI-ARRUGAS','13/04/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000064','000000029P',NULL,'P00000092P',7500,'ANTICASPA','30/04/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000065','000000029P',NULL,'P00000091P',10500,'CREMA ANTI-ARRUGAS','13/07/2021',8,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000066','000000029P',NULL,'P00000092P',4500,'ANTICASPA','25/07/2021',8,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000067','000000030P',NULL,'P00000093P',8500,'BUENO PARA EL CUERPO','15/01/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000068','000000030P',NULL,'P00000094P',8500,'BUENO PARA EL CABELLO','16/01/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000069','000000030P',NULL,'P00000093P',8500,'BUENO PARA EL CUERPO','14/03/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000070','000000030P',NULL,'P00000094P',8500,'BUENO PARA EL CABELLO','18/03/2021',8,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000071','000000030P',NULL,'P00000093P',9500,'BUENO PARA EL CUERPO','21/07/2021',8,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000072','000000030P',NULL,'P00000094P',9500,'BUENO PARA EL CABELLO','24/07/2021',8,'DISPONIBLE');
--Tienen finca Y VIVEN EN ELLA
INSERT INTO ProductoEnVenta VALUES('PV00000073','000000031P','000000001F','P00000065P',5500,'RICA LECHE','06/07/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000074','000000031P','000000001F','P00000080P',4500,'RICO QUESO','06/07/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000075','000000031P','000000001F','P00000065P',5500,'RICA LECHE','13/07/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000076','000000031P','000000001F','P00000080P',4500,'RICO QUESO','13/07/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000077','000000031P','000000001F','P00000065P',5500,'RICA LECHE','20/07/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000078','000000031P','000000001F','P00000080P',4500,'RICO QUESO','20/07/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000079','000000031P','000000001F','P00000065P',6000,'RICA LECHE','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000080','000000031P','000000001F','P00000080P',5000,'RICO QUESO','27/07/2021',10,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000081','000000032P','000000002F','P00000066P',5000,'BUENA LECHE','08/07/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000082','000000032P','000000002F','P00000070P',6500,'RICO YOGURT DE CRISTO','08/07/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000083','000000032P','000000002F','P00000081P',5500,'QUESO CAMPESINO SABROSO','08/07/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000084','000000032P','000000002F','P00000084P',5200,'QUESO DOBLE CREMA SABROSO','08/07/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000085','000000032P','000000002F','P00000066P',5200,'BUENA LECHE','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000086','000000032P','000000002F','P00000070P',6500,'RICO YOGURT DE CRISTO','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000087','000000032P','000000002F','P00000081P',5500,'QUESO CAMPESINO SABROSO','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000088','000000032P','000000002F','P00000084P',5500,'QUESO DOBLE CREMA SABROSO','22/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000089','000000033P','000000003F','P00000067P',4500,'RICA Y DELICIOSA LECHE','22/06/2021',12,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000090','000000033P','000000003F','P00000071P',5500,'BUEN YOGURT','22/06/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000091','000000033P','000000003F','P00000074P',5000,'RICO KUMIS','22/06/2021',12,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000092','000000033P','000000003F','P00000077P',5000,'BUENA CREMA DE LECHE','22/06/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000093','000000033P','000000003F','P00000082P',3500,'SABROSO QUESO CAMPESINO','22/06/2021',12,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000094','000000033P','000000003F','P00000085P',3500,'RICA DOBLECREMA','22/06/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000095','000000033P','000000003F','P00000067P',4500,'RICA Y DELICIOSA LECHE','22/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000096','000000033P','000000003F','P00000071P',6000,'BUEN YOGURT','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000097','000000033P','000000003F','P00000074P',5500,'RICO KUMIS','22/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000098','000000033P','000000003F','P00000077P',5500,'BUENA CREMA DE LECHE','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000099','000000033P','000000003F','P00000082P',4000,'SABROSO QUESO CAMPESINO','22/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000100','000000033P','000000003F','P00000085P',5500,'RICA DOBLECREMA','22/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000101','000000034P','000000004F','P00000068P',4000,'LA GRAN LECHE','12/03/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000102','000000034P','000000004F','P00000072P',5500,'DELICIOSO YOGUT CASERO','18/02/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000103','000000034P','000000004F','P00000068P',4000,'LA GRAN LECHE','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000104','000000034P','000000004F','P00000072P',5500,'DELICIOSO YOGUT CASERO','22/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000105','000000034P','000000004F','P00000075P',5500,'EL MEJOR kUMIS DE LA REGIOS','20/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000106','000000034P','000000004F','P00000078P',5500,'CREMA BIEN CREMOSA','21/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000107','000000034P','000000004F','P00000083P',5500,'QUESO BIEN COSTEÑO 100% REAL','25/07/2021',16,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000108','000000034P','000000004F','P00000086P',5500,'QUESO DOBLE CREMA SABROSO DE LA MEJOR VACA','22/07/2021',18,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000109','000000035P','000000005F','P00000069P',6000,'LA VACA HACE MUUUU','4/06/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000110','000000035P','000000005F','P00000069P',5500,'LA VACA HACE MUUUU VERSION MEJORADA','15/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000111','000000035P','000000005F','P00000069P',5000,'LA VACA HACE MUUUU VERSION MEJORADA','05/07/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000112','000000035P','000000005F','P00000069P',6000,'LA VACA HACE MUUUU VERSION MEJORADA X2','28/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000113','000000035P','000000005F','P00000073P',5000,'NO HAY NADA MAS MEJOR QUE ESTE YOGURT','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000114','000000035P','000000005F','P00000076P',4500,'KUMIS SABE GENIAL','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000115','000000035P','000000005F','P00000079P',3500,'BIEN CREMOSA LA CREMA','22/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000116','000000036P','000000006F','P00000043P',3000,'QUE NO FALTE LA YUCA','22/02/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000117','000000036P','000000006F','P00000044P',1000,'EL ÑAME SUPER BUENO ','22/02/2021',20,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000118','000000036P','000000006F','P00000036P',1500,'PIMENTON ROJITO','22/06/2021',10,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000119','000000036P','000000006F','P00000035P',2500,'ZANANORIAS BUENAS BONITAS Y BARATAS','22/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000120','000000036P','000000006F','P00000035P',2500,'ZANANORIAS BUENAS BONITAS Y BARATAS','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000121','000000036P','000000006F','P00000036P',1500,'PIMENTON ROJITO','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000122','000000036P','000000006F','P00000037P',1500,'REMOLACHA PA LA ENSALADA','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000123','000000036P','000000006F','P00000038P',2000,'PIPINO PA LA ENSALADA','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000124','000000036P','000000006F','P00000043P',3000,'QUE NO FALTE LA YUCA','22/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000125','000000036P','000000006F','P00000044P',1000,'EL ÑAME SUPER BUENO ','22/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000126','000000036P','000000006F','P00000045P',1500,'JENGIBRE SAZONA BIEN','22/07/2021',10,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000127','000000037P','000000007F','P00000035P',2500,'ZANAHORA ZATE ZATE ZATE','22/05/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000128','000000037P','000000007F','P00000032P',1500,'ESPARRADRACOS','22/04/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000129','000000037P','000000007F','P00000033P',4500,'PIZZA CON CHAMPIS QUEDA MEJOR','02/06/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000130','000000037P','000000007F','P00000029P',3500,'COME MAS REPOLLO','20/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000131','000000037P','000000007F','P00000030P',3500,'COME AMS REPOLLO BLANCO','16/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000132','000000037P','000000007F','P00000031P',2500,'MUCHA CALABAZA','22/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000133','000000037P','000000007F','P00000032P',1500,'ESPARRADRACOS','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000134','000000037P','000000007F','P00000033P',4500,'CHAMPI CHAMPI','22/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000135','000000037P','000000007F','P00000034P',1500,'AHUYAMA LA YAMA','22/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000136','000000037P','000000007F','P00000035P',2500,'ZANAHORA ZATE ZATE ZATE','22/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000137','000000038P','000000008F','P00000030P',2500,'REPOLLITO','22/05/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000138','000000038P','000000008F','P00000040P',3500,'CEBOLLA PAL PERICO','15/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000139','000000038P','000000008F','P00000038P',2500,'RICOS PEPINOS','25/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000140','000000038P','000000008F','P00000039P',2000,'LAS HABICUELAS','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000141','000000038P','000000008F','P00000040P',2000,'CEBOLLA CABEZONA LA MAS CABEZONA','22/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000142','000000039P','000000009F','P00000027P',2500,'LARGA LA CEBOLLA','22/03/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000143','000000039P','000000009F','P00000030P',2000,'A LA ORDEN EL REPOLLO','22/06/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000144','000000039P','000000009F','P00000032P',1500,'BUENOS ESPARRAGOS A SU MESA','22/04/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000145','000000039P','000000009F','P00000026P',2000,'ESPINACAS PARA SER POPEYE','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000146','000000039P','000000009F','P00000027P',2000,'LARGA LA CEBOLLA','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000147','000000039P','000000009F','P00000028P',3000,'DE CHINA LA COL CHINA','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000148','000000039P','000000009F','P00000029P',2500,'REPOLLO ENA-MORADO','22/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000149','000000039P','000000009F','P00000030P',3000,'A LA ORDEN EL REPOLLO','25/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000150','000000039P','000000009F','P00000031P',1500,'QUE CALABAZA','22/07/2021',16,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000151','000000039P','000000009F','P00000032P',2000,'BUENOS ESPARRAGOS A SU MESA','22/07/2021',15,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000153','000000010P','000000010F','P00000010P',4500,'UVAS MUY BUENAS','22/03/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000154','000000010P','000000010F','P00000001P',2500,'PLATANO DE CALIDAD','22/03/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000155','000000010P','000000010F','P00000002P',2500,'DULCE PALTANO MADURO','22/03/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000156','000000010P','000000010F','P00000004P',3500,'MARACUYA PA LA SED','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000157','000000010P','000000010F','P00000006P',3500,'RICAS LAS MANZANAS','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000158','000000010P','000000010F','P00000008P',2500,'SABROSOS BANANOS','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000159','000000010P','000000010F','P00000010P',4500,'UVAS MUY BUENAS','22/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000160','000000010P','000000010F','P00000033P',2500,'SE HAY CHAMPIS','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000161','000000010P','000000010F','P00000035P',2000,'LE TENEMOS LA ZANAHORIA','22/08/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000162','000000010P','000000010F','P00000036P',2000,'BUEN PIMENTON','22/08/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000163','000000010P','000000010F','P00000038P',2000,'COMPE AQUI EL PEPINO','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000164','000000010P','000000010F','P00000039P',2500,'SU HAY HABICHUELAS','22/07/2021',16,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000165','000000010P','000000010F','P00000047P',3000,'LOS FRIJOLES NO PUEDEN FALTAR','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000166','000000010P','000000010F','P00000050P',2500,'RICOS BLANQUILLOS','25/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000167','000000010P','000000010F','P00000103P',3000,'DELICIOSOS MANOLITOS','25/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000168','000000010P','000000010F','P00000001P',2500,'PLATANO DE CALIDAD','25/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000169','000000010P','000000010F','P00000002P',2500,'DULCE PALTANO MADURO','20/07/2021',10,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000170','000000011P','000000011F','P00000009P',3500,'SI HAY UVAS','22/06/2021',20,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000171','000000011P','000000011F','P00000028P',2500,'LE TENEMOS COL CHINA','25/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000172','000000011P','000000011F','P00000029P',2500,'EL REPOLLO MORADO','25/05/2021',15,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000173','000000011P','000000011F','P00000030P',2500,'EL REPOLO BLANCO','25/05/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000174','000000011P','000000011F','P00000010P',3000,'UVAS MUY BUENAS VERDES','22/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000175','000000011P','000000011F','P00000011P',2000,'QUE RICA LA FRESA','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000176','000000011P','000000011F','P00000012P',3000,'BUENAS LAS GUANABANAS','22/08/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000177','000000011P','000000011F','P00000013P',3000,'PIÑA PARA LA NIÑA','22/08/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000178','000000011P','000000011F','P00000014P',2500,'COME MANGO','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000179','000000011P','000000011F','P00000015P',3000,'OH DURAZNOS','22/07/2021',16,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000180','000000011P','000000011F','P00000009P',3500,'SI HAY UVAS','22/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000181','000000011P','000000011F','P00000016P',3000,'OTRA VARIEDAD DE DURAZNOS PERO DURAZNOS','22/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000182','000000011P','000000011F','P00000028P',2500,'LE TENEMOS COL CHINA','25/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000183','000000011P','000000011F','P00000029P',2000,'EL REPOLLO MORADO','25/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000184','000000011P','000000011F','P00000030P',2000,'EL REPOLO BLANCO','25/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000185','000000011P','000000011F','P00000031P',2000,'TU CALABAZA','20/07/2021',10,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000186','000000012P','000000012F','P00000019P',2000,'AGUACATES RICOS, MADUROS YA PARA COMER','20/04/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000187','000000012P','000000012F','P00000019P',2000,'AGUACATES RICOS, MADUROS YA PARA COMER','20/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000188','000000012P','000000012F','P00000019P',2000,'AGUACATES RICOS, MADUROS YA PARA COMER','20/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000189','000000012P','000000012F','P00000019P',2000,'AGUACATES RICOS, MADUROS YA PARA COMER','20/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000190','000000012P','000000012F','P00000020P',1500,'LE TENEMOS LAS GUAYABAS','25/07/2021',12,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000191','000000012P','000000012F','P00000021P',2000,'OTRAS VARIEDAD DE GUAYABAS','25/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000192','000000012P','000000012F','P00000022P',2500,'TOMA JUGUITO DE NARANJA','25/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000193','000000012P','000000012F','P00000023P',2200,'LIMON PARA LA LIMONADA','27/07/2021',16,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000194','000000012P','000000012F','P00000024P',2500,'SABROSAS MANDARINAS','26/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000195','000000012P','000000012F','P00000025P',2500,'COMPRA POR TU COCO','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000196','000000012P','000000012F','P00000046P',3000,'SI HAY MAIZ','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000197','000000012P','000000012F','P00000047P',3000,'SI HAY FRIJOLES','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000198','000000012P','000000012F','P00000048P',3000,'QUE RICAS LAS LENTEJAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000199','000000012P','000000012F','P00000049P',2500,'QUE RICOS GARBANZOS','26/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000200','000000013P','000000013F','P00000040P',2000,'CEBOLLA','26/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000201','000000013P','000000013F','P00000004P',3000,'MARACUYA PARA EL JUGO','26/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000202','000000013P','000000013F','P00000005P',3000,'SI HAY TOMATE DE ARBOL','26/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000203','000000013P','000000013F','P00000002P',2000,'PLANTANOS MADUROS A LA ORDEN','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000204','000000013P','000000013F','P00000004P',3000,'MARACUYA PARA EL JUGO','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000205','000000013P','000000013F','P00000005P',3000,'SI HAY TOMATE DE ARBOL','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000206','000000013P','000000013F','P00000008P',2000,'RICOS BANANOS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000207','000000013P','000000013F','P00000031P',2000,'SI HAY CALABAZAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000208','000000013P','000000013F','P00000032P',2000,'COMPRE SUS ESPARRAGOS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000209','000000013P','000000013F','P00000035P',2000,'LAS ZANAHORIAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000210','000000013P','000000013F','P00000040P',1500,'CABEZONA LA CEBOLLA','26/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000211','000000014P','000000014F','P00000108P',1500,'OREGANO DA MEJOR SABOR','26/06/2021',20,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000212','000000014P','000000014F','P00000108P',1500,'OREGANO DA MEJOR SABOR','26/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000213','000000014P','000000014F','P00000110P',1500,'USE LAUREL','26/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000214','000000014P','000000014F','P00000009P',3500,'UVITAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000215','000000014P','000000014F','P00000010P',3500,'LA UVA VERDE','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000216','000000014P','000000014F','P00000012P',2500,'T0ME MAS GUANABANA','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000217','000000014P','000000014F','P00000013P',3500,'PIÑAS PIÑAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000218','000000014P','000000014F','P00000027P',2500,'SI TENEMOS CEBOLLA','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000219','000000014P','000000014F','P00000029P',2000,'RICO REPOLLO','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000220','000000014P','000000014F','P00000031P',1500,'LAS CALABAZAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000221','000000014P','000000014F','P00000033P',4500,'PA LA SOPA DE CHAMPI','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000222','000000014P','000000014F','P00000108P',2000,'OREGANO DA MEJOR SABOR','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000223','000000014P','000000014F','P00000110P',1500,'USE LAUREL','26/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000224','000000015P','000000015F','P00000109P',1500,'BUENAS GUASCAS','26/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000225','000000015P','000000015F','P00000016P',3500,'DURAZNOS','26/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000226','000000015P','000000015F','P00000017P',4000,'BUENAS LAS PITAYAS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000227','000000015P','000000015F','P00000019P',3000,'QUIEN QUIERE AGUACATE','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000228','000000015P','000000015F','P00000020P',1500,'GUAYABA PARA EL JUGO','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000229','000000015P','000000015F','P00000109P',1500,'BUEBAS GUASCAS','26/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000230','000000016P','000000016F','P00000003P',2000,'PLATANOS NI SALADOS NI DILCES','26/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000231','000000016P','000000016F','P00000043P',2500,'QUE ES UN SANCOCHO SIN YUCA','27/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000232','000000016P','000000016F','P00000003P',2000,'PLATANOS NI SALADOS NI DILCES','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000233','000000016P','000000016F','P00000004P',3500,'HAGAN JUGO DE MARACUYA','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000234','000000016P','000000016F','P00000023P',1500,'QUIEN QUIERE LIMONES','26/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000235','000000016P','000000016F','P00000025P',2000,'QUE RICO EL COCO','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000236','000000016P','000000016F','P00000041P',2000,'OTRA PAPA PA LOS CALDOS','26/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000237','000000016P','000000016F','P00000042P',2000,'PAPA PAPA PAPA','26/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000238','000000016P','000000016F','P00000043P',2000,'QUE ES UN SANCOCHO SIN YUCA','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000239','000000017P','000000017F','P00000011P',2500,'MAS FRESA PARA TERESA','27/06/2021',20,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000240','000000017P','000000017F','P00000009P',3500,'LAS MEJORES UVAS QUE VERAS','27/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000241','000000017P','000000017F','P00000010P',3500,'LAS UVAS VERDES','27/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000242','000000017P','000000017F','P00000008P',2000,'SI TENEMOS BANANOS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000243','000000017P','000000017F','P00000009P',3000,'LAS MEJORES UVAS QUE VERAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000244','000000017P','000000017F','P00000010P',3500,'LAS UVAS VERDES','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000245','000000017P','000000017F','P00000011P',2500,'MAS FRESA PARA TERESA','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000246','000000018P','000000018F','P00000004P',3500,'SABROSO MARACUYA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000247','000000018P','000000018F','P00000005P',2500,'TOMATE DE ARBOL','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000248','000000018P','000000018F','P00000006P',3500,'ROJAS LAS MANZANAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000249','000000018P','000000018F','P00000007P',2500,'LAS BUENAS PERAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000250','000000018P','000000018F','P00000042P',2500,'COME LA BUENA PAPA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000251','000000018P','000000018F','P00000044P',1500,'ÑAEM ÑAME','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000252','000000018P','000000018F','P00000045P',1000,'JENJIBRE','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000253','000000018P','000000018F','P00000105P',1500,'VENGA POR EL OREGANO','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000254','000000018P','000000018F','P00000110P',1500,'HAY LAUREL','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000255','000000019P','000000019F','P00000013P',4500,'GRANDES PIÑAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000256','000000019P','000000019F','P00000014P',3500,'JUGOSOS MANGOS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000257','000000019P','000000019F','P00000015P',3500,'RICOS DURAZNOS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000258','000000019P','000000019F','P00000026P',1500,'LA FUERTE ESPINACA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000259','000000019P','000000019F','P00000038P',2000,'PEPINOS BUENOS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000260','000000019P','000000019F','P00000051P',2000,'LE TENEMOS LA CEBADA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000261','000000019P','000000019F','P00000108P',2000,'BUEN OREGANO','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000262','000000020P','000000020F','P00000011P',3500,'PARA LOS FRESAS','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000263','000000020P','000000020F','P00000012P',3000,'CALIDAD DE GANABANA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000264','000000020P','000000020F','P00000034P',2500,'SI TENEMOS AHUYAMA','28/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000265','000000020P','000000020F','P00000035P',2000,'VENGA POR SUS ZANAHORIAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000266','000000020P','000000020F','P00000048P',2500,'LENTEJAS SI HAY','28/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000267','000000020P','000000020F','P00000049P',2500,'HAY GARBANZOS','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000268','000000020P','000000020F','P00000113P',2000,'USEN EL PEREJIL','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000269','000000020P','000000020F','P00000114P',2000,'QUE NO FALTE EL AJO','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000270','000000021P','000000021F','P00000107P',1500,'ME LLAMAN ROMERO','27/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000271','000000021P','000000021F','P00000114P',1000,'VEN POR AJO','27/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000272','000000021P','000000021F','P00000020P',1500,'HAY GUAYABA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000273','000000021P','000000021F','P00000021P',2000,'GUAYABA MAS GUAYABA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000274','000000021P','000000021F','P00000030P',2000,'VEN POR EL REPOLLO','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000275','000000021P','000000021F','P00000044P',1500,'QUE ÑAME','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000276','000000021P','000000021F','P00000107P',1500,'ME LLAMAN ROMERO','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000277','000000021P','000000021F','P00000114P',1000,'VEN POR AJO','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000278','000000022P','000000022F','P00000050P',2500,'CAMPRA TUS BLANQUILLOS','27/02/2021',20,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000279','000000022P','000000022F','P00000112P',1000,'EL CILANTRO BUENO EL CICLANTRO','27/05/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000280','000000022P','000000022F','P00000112P',1000,'EL CILANTRO BUENO EL CICLANTRO','27/06/2021',20,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000281','000000022P','000000022F','P00000005P',2500,'TOMATES TOMATES DE ARBOL','28/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000282','000000022P','000000022F','P00000006P',3500,'SUPERMANZANAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000283','000000022P','000000022F','P00000041P',2000,'PAPA AMARILLA PAPA CRIOLLA','27/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000284','000000022P','000000022F','P00000050P',2500,'CAMPRA TUS BLANQUILLOS','27/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000285','000000022P','000000022F','P00000112P',1000,'EL CILANTRO BUENO EL CICLANTRO','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000286','000000023P','000000023F','P00000012P',2500,'SI HAY LA GUANABANA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000287','000000023P','000000023F','P00000013P',2500,'DELICIOSAS PIÑAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000288','000000023P','000000023F','P00000019P',2000,'EL AGUACATOSO SABROSO','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000289','000000023P','000000023F','P00000020P',2000,'JUGUITO DE GUAYABA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000290','000000023P','000000023F','P00000033P',4500,'LAS CHAMPIS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000291','000000023P','000000023F','P00000043P',2000,'YUQUITA FRITA... QUE RICO','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000292','000000024P','000000024F','P00000026P',1500,'COMO ESPINACA, SERAS POPEYE','27/03/2021',10,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000293','000000024P','000000024F','P00000026P',1500,'COMO ESPINACA, SERAS POPEYE','27/05/2021',12,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000294','000000024P','000000024F','P00000026P',1500,'COMO ESPINACA, SERAS POPEYE','28/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000295','000000024P','000000024F','P00000027P',2500,'CEBOLLA RICA CEBOLLA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000296','000000024P','000000024F','P00000028P',2000,'COL CHINA SI HAY','27/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000297','000000024P','000000024F','P00000039P',2500,'VEN POR LAS HABICHUELAS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000298','000000024P','000000024F','P00000040P',2000,'CEBOLLA CABEZONA','27/07/2021',20,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000299','000000025P','000000025F','P00000001P',2000,'RICOS PLATANOS','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000300','000000025P','000000025F','P00000002P',2000,'PLATANO MADURO DULCE','27/07/2021',18,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000301','000000025P','000000025F','P00000003P',2000,'PLATANOS PINTONES BUEN TAMAÑO','27/07/2021',16,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000302','000000025P','000000025F','P00000024P',2500,'MANDARINAS PARA LA GRIPA','27/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000303','000000025P','000000025F','P00000025P',2500,'QUIEN QUIERE COCO','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000304','000000025P','000000025F','P00000044P',1500,'ÑAME ÑAME','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000305','000000025P','000000025F','P00000046P',3000,'EL MAIZ','27/07/2021',10,'DISPONIBLE');

INSERT INTO ProductoEnVenta VALUES('PV00000306','000000026P','000000026F','P00000036P',2500,'PIMENTONES DE CALIDAD','27/03/2021',10,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000307','000000026P','000000026F','P00000032P',2000,'ESPARRADRAGOS','27/02/2021',10,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000308','000000026P','000000026F','P00000030P',2000,'EL REPOLO BLANCO','27/04/2021',15,'NO DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000309','000000026P','000000026F','P00000040P',2500,'CABEZONA LA CEBOLLA','27/05/2021',18,'AGOTADO');
INSERT INTO ProductoEnVenta VALUES('PV00000310','000000026P','000000026F','P00000033P',3500,'UMMMM CHAMPIÑONES','27/05/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000311','000000026P','000000026F','P00000029P',2000,'LE TENGO EL REPOLLO','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000312','000000026P','000000026F','P00000030P',2000,'EL REPOLO BLANCO','27/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000313','000000026P','000000026F','P00000031P',1500,'COMAN CALABAZAS','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000314','000000026P','000000026F','P00000032P',2000,'ESPARRADRAGOS','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000315','000000026P','000000026F','P00000033P',3500,'UMMMM CHAMPIÑONES','27/07/2021',15,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000316','000000026P','000000026F','P00000034P',2000,'AHUYAMA PA LA GENTE','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000317','000000026P','000000026F','P00000035P',2500,'ZAPOTES ZANAHORIAS','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000318','000000026P','000000026F','P00000036P',2000,'PIMENTONES DE CALIDAD','27/07/2021',10,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000319','000000026P','000000026F','P00000037P',1500,'MORADA LA REMOLACHA','27/07/2021',20,'DISPONIBLE');
INSERT INTO ProductoEnVenta VALUES('PV00000320','000000026P','000000026F','P00000040P',3000,'CABEZONA LA CEBOLLA','27/07/2021',18,'DISPONIBLE');

--CANASTA
INSERT INTO Canasta VALUES('CA00000001','000000001C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000001','PV00000027','20/03/2021',2);--7000
    INSERT INTO Pedido VALUES('CA00000001','PV00000032','20/02/2021',1);--4000
    INSERT INTO Pedido VALUES('CA00000001','PV00000067','20/02/2021',1);--8500

INSERT INTO Canasta VALUES('CA00000002','000000001C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000002','PV00000280','02/07/2021',1);--1000
    INSERT INTO Pedido VALUES('CA00000002','PV00000180','20/07/2021',2);--3500
    INSERT INTO Pedido VALUES('CA00000002','PV00000267','28/07/2021',1);--2500

INSERT INTO Canasta VALUES('CA00000003','000000001C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000003','PV00000320','28/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000003','PV00000290','28/07/2021',2);

INSERT INTO Canasta VALUES('CA00000004','000000002C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000004','PV00000061','13/05/2021',1);--4500
    INSERT INTO Pedido VALUES('CA00000004','PV00000050','28/07/2021',1);--9600

INSERT INTO Canasta VALUES('CA00000005','000000002C','FACTURANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000005','PV00000261','20/07/2021',1);--1000
    INSERT INTO Pedido VALUES('CA00000005','PV00000198','28/07/2021',3);--3000

INSERT INTO Canasta VALUES('CA00000006','000000003C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000006','PV00000167','13/07/2021',3);--3000
    INSERT INTO Pedido VALUES('CA00000006','PV00000132','28/07/2021',2);--25

INSERT INTO Canasta VALUES('CA00000007','000000003C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000007','PV00000045','13/07/2021',3);--9
    INSERT INTO Pedido VALUES('CA00000007','PV00000082','28/07/2021',5);--6.5

INSERT INTO Canasta VALUES('CA00000008','000000004C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000008','PV00000145','28/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000008','PV00000183','28/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000008','PV00000283','28/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000008','PV00000245','28/07/2021',2);

INSERT INTO Canasta VALUES('CA00000009','000000004C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000009','PV00000245','28/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000009','PV00000233','28/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000009','PV00000093','28/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000009','PV00000065','28/07/2021',2);

INSERT INTO Canasta VALUES('CA00000010','000000006C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000010','PV00000045','12/05/2021',1);--9
    INSERT INTO Pedido VALUES('CA00000010','PV00000083','23/06/2021',2);--5.5
    INSERT INTO Pedido VALUES('CA00000010','PV00000283','13/06/2021',3);--2   

INSERT INTO Canasta VALUES('CA00000011','000000008C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000011','PV00000005','12/06/2021',5);--2.5
    INSERT INTO Pedido VALUES('CA00000011','PV00000123','23/06/2021',5);--2.0

INSERT INTO Canasta VALUES('CA00000012','000000008C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000012','PV00000035','12/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000012','PV00000253','23/06/2021',2);

INSERT INTO Canasta VALUES('CA00000013','000000010C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000013','PV00000255','12/06/2021',5);--2.5
    INSERT INTO Pedido VALUES('CA00000013','PV00000303','23/06/2021',5);--2.0

INSERT INTO Canasta VALUES('CA00000014','000000010C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000014','PV00000063','05/03/2021',2);--5.5
    INSERT INTO Pedido VALUES('CA00000014','PV00000099','23/04/2021',2);--4
    INSERT INTO Pedido VALUES('CA00000014','PV00000199','13/04/2021',2);--2.5
    INSERT INTO Pedido VALUES('CA00000014','PV00000209','13/04/2021',3);--2

INSERT INTO Canasta VALUES('CA00000015','000000010C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000015','PV00000163','28/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000015','PV00000198','28/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000015','PV00000299','28/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000015','PV00000168','28/07/2021',3);

INSERT INTO Canasta VALUES('CA00000016','000000011C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000016','PV00000045','27/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000016','PV00000178','27/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000016','PV00000293','27/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000016','PV00000157','27/07/2021',2);

INSERT INTO Canasta VALUES('CA00000017','000000013C','FACTURANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000017','PV00000298','29/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000017','PV00000175','29/07/2021',4);
    INSERT INTO Pedido VALUES('CA00000017','PV00000168','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000017','PV00000012','29/07/2021',1);

INSERT INTO Canasta VALUES('CA00000018','000000013C','FACTURANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000018','PV00000056','29/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000018','PV00000046','29/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000018','PV00000033','29/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000018','PV00000067','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000018','PV00000100','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000018','PV00000150','29/07/2021',2);

INSERT INTO Canasta VALUES('CA00000019','000000015C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000019','PV00000032','15/05/2021',2);--4
    INSERT INTO Pedido VALUES('CA00000019','PV00000067','14/05/2021',2);--8.5
    INSERT INTO Pedido VALUES('CA00000019','PV00000184','13/05/2021',3);--2
    INSERT INTO Pedido VALUES('CA00000019','PV00000254','13/05/2021',3);--1.5   

INSERT INTO Canasta VALUES('CA00000020','000000015C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000020','PV00000018','15/06/2021',3);--6
    INSERT INTO Pedido VALUES('CA00000020','PV00000025','14/06/2021',2);--7
    INSERT INTO Pedido VALUES('CA00000020','PV00000125','13/06/2021',1);--1
    INSERT INTO Pedido VALUES('CA00000020','PV00000250','13/06/2021',2);--2.5

INSERT INTO Canasta VALUES('CA00000021','000000015C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000021','PV00000118','15/07/2021',1);--1.5
    INSERT INTO Pedido VALUES('CA00000021','PV00000225','14/07/2021',1);--3.5
    INSERT INTO Pedido VALUES('CA00000021','PV00000132','13/07/2021',2);--2.5
    INSERT INTO Pedido VALUES('CA00000021','PV00000250','13/07/2021',4);--2.5

INSERT INTO Canasta VALUES('CA00000022','000000015C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000022','PV00000119','28/07/2021',1);--1.5
    INSERT INTO Pedido VALUES('CA00000022','PV00000226','28/07/2021',1);--3.5
    INSERT INTO Pedido VALUES('CA00000022','PV00000133','28/07/2021',2);--2.5
    INSERT INTO Pedido VALUES('CA00000022','PV00000251','28/07/2021',4);--2.5

INSERT INTO Canasta VALUES('CA00000023','000000017C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000023','PV00000300','15/07/2021',1);--2
    INSERT INTO Pedido VALUES('CA00000023','PV00000200','14/07/2021',1);--3.5
    INSERT INTO Pedido VALUES('CA00000023','PV00000100','13/07/2021',2);--5.5
    INSERT INTO Pedido VALUES('CA00000023','PV00000007','13/07/2021',2);--2

INSERT INTO Canasta VALUES('CA00000025','000000017C','FACTURANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000025','PV00000301','23/07/2021',2);--2
    INSERT INTO Pedido VALUES('CA00000025','PV00000201','23/07/2021',2);--2
    INSERT INTO Pedido VALUES('CA00000025','PV00000101','23/07/2021',1);--4
    INSERT INTO Pedido VALUES('CA00000025','PV00000007','23/07/2021',1);--2
    INSERT INTO Pedido VALUES('CA00000025','PV00000105','23/07/2021',2);--5.5

INSERT INTO Canasta VALUES('CA00000026','000000019C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000026','PV00000305','15/07/2021',3);--3
    INSERT INTO Pedido VALUES('CA00000026','PV00000205','14/07/2021',2);--3
    INSERT INTO Pedido VALUES('CA00000026','PV00000105','13/07/2021',2);--5.5

INSERT INTO Canasta VALUES('CA00000027','000000019C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000027','PV00000310','15/06/2021',4);--3.5
    INSERT INTO Pedido VALUES('CA00000027','PV00000215','14/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000027','PV00000115','13/06/2021',2);

INSERT INTO Canasta VALUES('CA00000028','000000020C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000028','PV00000036','15/04/2021',4);--3.5
    INSERT INTO Pedido VALUES('CA00000028','PV00000238','14/04/2021',2);--2
    INSERT INTO Pedido VALUES('CA00000028','PV00000134','13/04/2021',2);--4.5

INSERT INTO Canasta VALUES('CA00000029','000000020C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000029','PV00000137','15/06/2021',4);--2.5
    INSERT INTO Pedido VALUES('CA00000029','PV00000039','14/06/2021',3);--5.5
    
INSERT INTO Canasta VALUES('CA00000031','000000020C','COMPRADA');
--PEDIDOS CANASTA
INSERT INTO Pedido VALUES('CA00000031','PV00000136','15/06/2021',4);--2.5
INSERT INTO Pedido VALUES('CA00000031','PV00000038','14/06/2021',3);--4.5

INSERT INTO Canasta VALUES('CA00000032','000000022C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000032','PV00000056','16/04/2021',6);--9.6
    INSERT INTO Pedido VALUES('CA00000032','PV00000234','16/04/2021',6);--1.5
    INSERT INTO Pedido VALUES('CA00000032','PV00000178','16/04/2021',6);--2.5
    INSERT INTO Pedido VALUES('CA00000032','PV00000012','16/04/2021',8);--4.5
    INSERT INTO Pedido VALUES('CA00000032','PV00000267','16/04/2021',8);--2.5
    INSERT INTO Pedido VALUES('CA00000032','PV00000126','16/04/2021',8);--1.5

INSERT INTO Canasta VALUES('CA00000033','000000022C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000033','PV00000056','16/05/2021',6);--9.6
    INSERT INTO Pedido VALUES('CA00000033','PV00000234','16/05/2021',6);--1.5
    INSERT INTO Pedido VALUES('CA00000033','PV00000178','16/05/2021',6);--2.5
    INSERT INTO Pedido VALUES('CA00000033','PV00000012','16/05/2021',8);--4.5
    INSERT INTO Pedido VALUES('CA00000033','PV00000267','16/05/2021',8);--2.5
    INSERT INTO Pedido VALUES('CA00000033','PV00000126','16/05/2021',10);--1.5

INSERT INTO Canasta VALUES('CA00000034','000000022C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000034','PV00000055','16/06/2021',8);--9.6
    INSERT INTO Pedido VALUES('CA00000034','PV00000233','16/06/2021',8);--3.5
    INSERT INTO Pedido VALUES('CA00000034','PV00000178','16/06/2021',8);--2.5
    INSERT INTO Pedido VALUES('CA00000034','PV00000012','16/06/2021',8);--4.5
    INSERT INTO Pedido VALUES('CA00000034','PV00000267','16/06/2021',8);--2.5
    INSERT INTO Pedido VALUES('CA00000034','PV00000126','16/06/2021',8);--2.5


INSERT INTO Canasta VALUES('CA00000035','000000022C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000035','PV00000055','16/07/2021',8);--9.6
    INSERT INTO Pedido VALUES('CA00000035','PV00000233','16/07/2021',8);--3.5
    INSERT INTO Pedido VALUES('CA00000035','PV00000178','16/07/2021',8);--2.5
    INSERT INTO Pedido VALUES('CA00000035','PV00000012','16/07/2021',8);--4.5
    INSERT INTO Pedido VALUES('CA00000035','PV00000267','16/07/2021',8);--2.5
    INSERT INTO Pedido VALUES('CA00000035','PV00000126','16/07/2021',8);--2.5

INSERT INTO Canasta VALUES('CA00000037','000000022C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000037','PV00000055','29/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000037','PV00000233','29/07/2021',10);

INSERT INTO Canasta VALUES('CA00000038','000000024C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000038','PV00000067','06/06/2021',8);--8.5
    INSERT INTO Pedido VALUES('CA00000038','PV00000145','06/06/2021',8);--2
    INSERT INTO Pedido VALUES('CA00000038','PV00000056','06/06/2021',8);--9.6
    INSERT INTO Pedido VALUES('CA00000038','PV00000019','06/06/2021',8);--7
    INSERT INTO Pedido VALUES('CA00000038','PV00000077','06/06/2021',8);--5.5
    INSERT INTO Pedido VALUES('CA00000038','PV00000187','06/06/2021',8);--2

INSERT INTO Canasta VALUES('CA00000039','000000024C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000039','PV00000067','06/07/2021',8);--8.5
    INSERT INTO Pedido VALUES('CA00000039','PV00000145','06/07/2021',8);--2
    INSERT INTO Pedido VALUES('CA00000039','PV00000056','06/07/2021',8);--9.6
    INSERT INTO Pedido VALUES('CA00000039','PV00000019','06/07/2021',8);--7
    INSERT INTO Pedido VALUES('CA00000039','PV00000077','06/07/2021',8);--5.5
    INSERT INTO Pedido VALUES('CA00000039','PV00000187','06/07/2021',8);--2

INSERT INTO Canasta VALUES('CA00000040','000000024C','FACTURANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000040','PV00000067','28/07/2021',8);--8.5
    INSERT INTO Pedido VALUES('CA00000040','PV00000145','28/07/2021',8);--2
    INSERT INTO Pedido VALUES('CA00000040','PV00000056','28/07/2021',8);--9.6


INSERT INTO Canasta VALUES('CA00000041','000000026C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000041','PV00000037','06/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000041','PV00000167','06/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000041','PV00000020','06/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000041','PV00000154','06/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000041','PV00000087','06/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000041','PV00000190','06/06/2021',5);
    

INSERT INTO Canasta VALUES('CA00000042','000000026C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000042','PV00000037','06/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000042','PV00000167','06/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000042','PV00000020','06/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000042','PV00000154','06/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000042','PV00000087','06/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000042','PV00000190','06/07/2021',5);

INSERT INTO Canasta VALUES('CA00000043','000000026C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000043','PV00000167','28/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000043','PV00000020','26/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000043','PV00000154','26/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000043','PV00000087','26/07/2021',5);


INSERT INTO Canasta VALUES('CA00000044','000000028C','COMPRADA');
  --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000044','PV00000055','06/05/2021',10);
    INSERT INTO Pedido VALUES('CA00000044','PV00000067','06/05/2021',10);
    INSERT INTO Pedido VALUES('CA00000044','PV00000120','06/05/2021',10);
    INSERT INTO Pedido VALUES('CA00000044','PV00000280','06/05/2021',5);

INSERT INTO Canasta VALUES('CA00000045','000000028C','COMPRADA');
  --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000045','PV00000065','06/05/2021',10);
    INSERT INTO Pedido VALUES('CA00000045','PV00000076','06/05/2021',10);
    INSERT INTO Pedido VALUES('CA00000045','PV00000120','06/05/2021',10);
    INSERT INTO Pedido VALUES('CA00000045','PV00000280','06/05/2021',5);

INSERT INTO Canasta VALUES('CA00000046','000000028C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000046','PV00000076','06/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000046','PV00000120','06/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000046','PV00000280','06/07/2021',5);


INSERT INTO Canasta VALUES('CA00000047','000000030C','COMPRADA');
  --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000047','PV00000255','06/06/2021',7);
    INSERT INTO Pedido VALUES('CA00000047','PV00000176','06/06/2021',7);
    INSERT INTO Pedido VALUES('CA00000047','PV00000180','06/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000047','PV00000080','06/06/2021',5);

INSERT INTO Canasta VALUES('CA00000048','000000030C','FACTURANDO');
   --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000048','PV00000176','06/06/2021',7);
    INSERT INTO Pedido VALUES('CA00000048','PV00000180','06/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000048','PV00000080','06/06/2021',5);


INSERT INTO Canasta VALUES('CA00000049','000000031C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000049','PV00000023','04/04/2021',3);
    INSERT INTO Pedido VALUES('CA00000049','PV00000024','04/04/2021',3);
    INSERT INTO Pedido VALUES('CA00000049','PV00000025','04/04/2021',3);  

INSERT INTO Canasta VALUES('CA00000051','000000033C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000051','PV00000123','04/04/2021',2);
    INSERT INTO Pedido VALUES('CA00000051','PV00000134','04/04/2021',2);

INSERT INTO Canasta VALUES('CA00000052','000000033C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000052','PV00000143','04/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000052','PV00000144','04/07/2021',2);


INSERT INTO Canasta VALUES('CA00000053','000000035C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000053','PV00000045','27/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000053','PV00000067','27/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000053','PV00000167','27/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000053','PV00000128','27/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000053','PV00000133','27/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000053','PV00000191','27/07/2021',2);

INSERT INTO Canasta VALUES('CA00000054','000000037C','COMPRADA');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000054','PV00000255','06/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000054','PV00000176','06/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000054','PV00000180','06/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000054','PV00000080','06/06/2021',3);

INSERT INTO Canasta VALUES('CA00000055','000000037C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000055','PV00000245','09/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000055','PV00000126','06/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000055','PV00000183','09/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000055','PV00000084','09/07/2021',1);

INSERT INTO Canasta VALUES('CA00000056','000000039C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000056','PV00000245','09/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000056','PV00000126','06/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000056','PV00000183','09/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000056','PV00000084','09/07/2021',1);


INSERT INTO Canasta VALUES('CA00000059','000000041C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000059','PV00000055','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000076','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000085','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000086','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000092','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000078','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000080','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000059','PV00000093','07/06/2021',5);

INSERT INTO Canasta VALUES('CA00000060','000000041C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000060','PV00000055','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000060','PV00000076','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000060','PV00000085','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000060','PV00000086','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000060','PV00000092','07/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000060','PV00000078','07/06/2021',5);

INSERT INTO Canasta VALUES('CA00000061','000000042C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000061','PV00000055','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000076','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000085','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000086','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000092','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000078','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000080','07/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000061','PV00000093','07/07/2021',7);

INSERT INTO Canasta VALUES('CA00000062','000000042C','FACTURANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000062','PV00000055','27/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000062','PV00000076','27/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000062','PV00000085','27/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000062','PV00000086','27/07/2021',7);
    INSERT INTO Pedido VALUES('CA00000062','PV00000092','27/07/2021',7);
-------------------------------------------------------------------------------------
INSERT INTO Canasta VALUES('CA00000063','000000044C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000063','PV00000028','27/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000063','PV00000086','27/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000063','PV00000165','27/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000063','PV00000286','27/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000063','PV00000192','27/07/2021',5);

INSERT INTO Canasta VALUES('CA00000064','000000044C','COMPRADA');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000064','PV00000028','27/06/2021',8);
    INSERT INTO Pedido VALUES('CA00000064','PV00000086','27/06/2021',8);
    INSERT INTO Pedido VALUES('CA00000064','PV00000165','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000064','PV00000286','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000064','PV00000192','27/06/2021',5);

INSERT INTO Canasta VALUES('CA00000065','000000044C','COMPRADA');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000065','PV00000228','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000065','PV00000186','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000065','PV00000069','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000065','PV00000316','27/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000065','PV00000112','27/06/2021',5);
    

INSERT INTO Canasta VALUES('CA00000066','000000044C','COMPRADA');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000066','PV00000229','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000066','PV00000186','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000066','PV00000065','27/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000066','PV00000316','27/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000066','PV00000118','27/06/2021',5);
    


INSERT INTO Canasta VALUES('CA00000067','000000046C','COMPRADA');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000067','PV00000129','28/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000067','PV00000156','28/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000067','PV00000075','28/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000067','PV00000116','28/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000067','PV00000218','28/06/2021',10);
    

INSERT INTO Canasta VALUES('CA00000068','000000046C','LLENANDO');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000068','PV00000129','29/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000068','PV00000156','29/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000068','PV00000075','29/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000068','PV00000116','29/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000068','PV00000218','29/07/2021',8);

INSERT INTO Canasta VALUES('CA00000069','000000047C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000069','PV00000029','20/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000069','PV00000056','20/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000069','PV00000076','20/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000069','PV00000117','20/06/2021',10);
    INSERT INTO Pedido VALUES('CA00000069','PV00000118','20/06/2021',10);
    

INSERT INTO Canasta VALUES('CA00000070','000000047C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000070','PV00000029','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000070','PV00000056','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000070','PV00000076','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000070','PV00000117','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000070','PV00000118','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000070','PV00000135','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000070','PV00000129','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000070','PV00000111','20/07/2021',10);
    

INSERT INTO Canasta VALUES('CA00000072','000000047C','FACTURANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000072','PV00000135','28/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000072','PV00000129','28/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000072','PV00000111','28/07/2021',8);

INSERT INTO Canasta VALUES('CA00000073','000000048C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000073','PV00000136','28/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000073','PV00000134','28/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000073','PV00000167','28/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000073','PV00000198','28/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000073','PV00000014','28/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000073','PV00000271','28/07/2021',5);

INSERT INTO Canasta VALUES('CA00000074','000000050C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000074','PV00000028','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000074','PV00000156','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000074','PV00000176','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000074','PV00000217','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000074','PV00000218','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000074','PV00000235','20/07/2021',10);
    

INSERT INTO Canasta VALUES('CA00000075','000000050C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000075','PV00000128','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000075','PV00000256','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000075','PV00000076','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000075','PV00000017','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000075','PV00000118','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000075','PV00000035','20/07/2021',10);
    

INSERT INTO Canasta VALUES('CA00000076','000000050C','LLENANDO');
   --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000076','PV00000128','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000076','PV00000256','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000076','PV00000076','20/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000076','PV00000017','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000076','PV00000118','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000076','PV00000035','20/07/2021',5);


INSERT INTO Canasta VALUES('CA00000077','000000052C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000077','PV00000246','21/05/2021',3);
    INSERT INTO Pedido VALUES('CA00000077','PV00000176','21/05/2021',2);
    INSERT INTO Pedido VALUES('CA00000077','PV00000117','21/05/2021',3);
    INSERT INTO Pedido VALUES('CA00000077','PV00000218','21/05/2021',1);
    

INSERT INTO Canasta VALUES('CA00000078','000000052C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000078','PV00000246','22/05/2021',3);
    INSERT INTO Pedido VALUES('CA00000078','PV00000176','22/05/2021',2);
    INSERT INTO Pedido VALUES('CA00000078','PV00000117','22/05/2021',3);
    INSERT INTO Pedido VALUES('CA00000078','PV00000218','22/05/2021',1);
    

INSERT INTO Canasta VALUES('CA00000079','000000054C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000079','PV00000046','21/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000079','PV00000076','21/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000079','PV00000123','21/06/2021',3);
    INSERT INTO Pedido VALUES('CA00000079','PV00000215','21/06/2021',1);
    

INSERT INTO Canasta VALUES('CA00000085','000000054C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000085','PV00000046','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000085','PV00000076','12/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000085','PV00000123','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000085','PV00000215','12/07/2021',1);
    

INSERT INTO Canasta VALUES('CA00000086','000000054C','LLENANDO');
    --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000086','PV00000046','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000086','PV00000076','12/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000086','PV00000123','12/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000086','PV00000215','12/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000086','PV00000006','12/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000086','PV00000176','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000086','PV00000143','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000086','PV00000004','12/07/2021',2);

INSERT INTO Canasta VALUES('CA00000087','000000056C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000087','PV00000246','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000087','PV00000301','12/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000087','PV00000302','12/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000087','PV00000307','12/07/2021',1);
    

INSERT INTO Canasta VALUES('CA00000088','000000056C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000088','PV00000046','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000088','PV00000303','29/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000088','PV00000313','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000088','PV00000203','29/07/2021',5);


INSERT INTO Canasta VALUES('CA00000089','000000058C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000089','PV00000256','16/05/2021',3);
    INSERT INTO Pedido VALUES('CA00000089','PV00000001','16/05/2021',4);
    INSERT INTO Pedido VALUES('CA00000089','PV00000002','16/05/2021',4);
    INSERT INTO Pedido VALUES('CA00000089','PV00000017','16/05/2021',1);

INSERT INTO Canasta VALUES('CA00000090','000000058C','FACTURANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000090','PV00000056','16/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000090','PV00000015','16/07/2021',4);
    INSERT INTO Pedido VALUES('CA00000090','PV00000016','16/07/2021',4);
    INSERT INTO Pedido VALUES('CA00000090','PV00000215','16/07/2021',2);


INSERT INTO Canasta VALUES('CA00000091','000000060C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000091','PV00000036','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000091','PV00000315','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000091','PV00000022','13/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000091','PV00000122','13/06/2021',1);

INSERT INTO Canasta VALUES('CA00000092','000000060C','FACTURANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000092','PV00000046','19/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000092','PV00000017','19/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000092','PV00000119','19/07/2021',1);
    INSERT INTO Pedido VALUES('CA00000092','PV00000217','19/07/2021',1);


INSERT INTO Canasta VALUES('CA00000095','000000061C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000095','PV00000036','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000095','PV00000315','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000095','PV00000022','13/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000095','PV00000122','13/06/2021',1);
    

INSERT INTO Canasta VALUES('CA00000096','000000061C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000096','PV00000037','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000096','PV00000316','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000096','PV00000023','13/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000096','PV00000124','13/06/2021',2);

INSERT INTO Canasta VALUES('CA00000097','000000063C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000097','PV00000236','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000097','PV00000215','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000097','PV00000222','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000097','PV00000122','13/06/2021',8); 

INSERT INTO Canasta VALUES('CA00000098','000000063C','LLENANDO');
    INSERT INTO Pedido VALUES('CA00000098','PV00000236','25/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000098','PV00000215','22/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000098','PV00000222','25/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000098','PV00000122','25/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000098','PV00000037','23/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000098','PV00000316','25/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000098','PV00000023','25/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000098','PV00000124','25/07/2021',5);


INSERT INTO Canasta VALUES('CA00000099','000000065C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000099','PV00000036','12/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000099','PV00000015','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000099','PV00000111','10/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000099','PV00000222','11/06/2021',8);

INSERT INTO Canasta VALUES('CA00000100','000000065C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000100','PV00000236','26/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000100','PV00000043','26/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000100','PV00000051','27/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000100','PV00000052','27/07/2021',8);

INSERT INTO Canasta VALUES('CA00000108','000000066C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000108','PV00000036','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000108','PV00000215','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000108','PV00000102','13/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000108','PV00000107','13/06/2021',8);
    INSERT INTO Pedido VALUES('CA00000108','PV00000108','13/06/2021',8);
    INSERT INTO Pedido VALUES('CA00000108','PV00000109','13/06/2021',8);
    

INSERT INTO Canasta VALUES('CA00000109','000000066C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000109','PV00000036','01/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000109','PV00000215','03/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000109','PV00000102','01/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000109','PV00000107','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000109','PV00000108','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000109','PV00000109','01/07/2021',8);
    

INSERT INTO Canasta VALUES('CA00000110','000000066C','FACTURANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000110','PV00000036','25/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000110','PV00000215','25/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000110','PV00000108','27/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000110','PV00000109','28/07/2021',8);


INSERT INTO Canasta VALUES('CA00000111','000000068C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000111','PV00000236','01/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000111','PV00000217','03/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000111','PV00000122','01/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000111','PV00000137','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000111','PV00000148','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000111','PV00000159','01/07/2021',8);
    

INSERT INTO Canasta VALUES('CA00000112','000000068C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000112','PV00000236','20/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000112','PV00000217','23/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000112','PV00000132','21/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000112','PV00000137','21/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000112','PV00000158','21/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000112','PV00000169','21/07/2021',8);

INSERT INTO Canasta VALUES('CA00000113','000000070C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000113','PV00000038','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000113','PV00000117','03/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000113','PV00000123','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000113','PV00000147','01/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000113','PV00000158','01/07/2021',8);

INSERT INTO Canasta VALUES('CA00000114','000000070C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000114','PV00000038','25/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000114','PV00000117','25/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000114','PV00000123','25/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000114','PV00000147','25/07/2021',8);
    INSERT INTO Pedido VALUES('CA00000114','PV00000158','25/07/2021',8);
    

INSERT INTO Canasta VALUES('CA00000117','000000071C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000117','PV00000138','10/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000117','PV00000227','10/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000117','PV00000125','10/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000117','PV00000145','10/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000117','PV00000058','10/07/2021',5);  

INSERT INTO Canasta VALUES('CA00000118','000000071C','FACTURANDO');
    INSERT INTO Pedido VALUES('CA00000118','PV00000138','10/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000118','PV00000227','10/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000118','PV00000145','10/07/2021',10);
    INSERT INTO Pedido VALUES('CA00000118','PV00000058','10/07/2021',5);

INSERT INTO Canasta VALUES('CA00000121','000000073C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000121','PV00000038','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000121','PV00000027','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000121','PV00000223','29/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000121','PV00000147','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000121','PV00000058','29/06/2021',3);
    

INSERT INTO Canasta VALUES('CA00000122','000000073C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000122','PV00000038','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000122','PV00000027','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000122','PV00000223','29/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000122','PV00000147','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000122','PV00000058','29/06/2021',3);

INSERT INTO Canasta VALUES('CA00000125','000000075C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000125','PV00000028','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000125','PV00000047','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000125','PV00000123','29/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000125','PV00000187','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000125','PV00000068','29/06/2021',3); 

INSERT INTO Canasta VALUES('CA00000126','000000075C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000126','PV00000038','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000126','PV00000067','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000126','PV00000243','29/06/2021',1);


INSERT INTO Canasta VALUES('CA00000127','000000077C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000127','PV00000128','29/06/2021',5);
    INSERT INTO Pedido VALUES('CA00000127','PV00000319','29/06/2021',3);
    

INSERT INTO Canasta VALUES('CA00000128','000000077C','LLENANDO');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000128','PV00000128','29/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000128','PV00000319','29/07/2021',3);
    INSERT INTO Pedido VALUES('CA00000128','PV00000138','29/07/2021',5);
    INSERT INTO Pedido VALUES('CA00000128','PV00000309','29/07/2021',3);

INSERT INTO Canasta VALUES('CA00000132','000000079C','COMPRADA');
--PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000132','PV00000028','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000132','PV00000019','29/06/2021',1);
    INSERT INTO Pedido VALUES('CA00000132','PV00000229','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000132','PV00000119','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000132','PV00000048','29/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000132','PV00000079','29/06/2021',3); 

INSERT INTO Canasta VALUES('CA00000133','000000079C','LLENANDO');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000133','PV00000119','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000133','PV00000048','29/07/2021',2);
    INSERT INTO Pedido VALUES('CA00000133','PV00000079','29/07/2021',3);

INSERT INTO Canasta VALUES('CA00000134','000000080C','COMPRADA');
 --PEDIDOS CANASTA
    INSERT INTO Pedido VALUES('CA00000134','PV00000018','28/06/2021',2);
    INSERT INTO Pedido VALUES('CA00000134','PV00000067','28/06/2021',3);

-------------------------------------------------------------------------------
--FACTURA
INSERT INTO Factura VALUES('F000000001','CA00000001','000000001C', 3000, 29500);
INSERT INTO Factura VALUES('F000000002','CA00000002','000000001C', 2000, 12500);
INSERT INTO Factura VALUES('F000000003','CA00000004','000000002C', 2000, 14100);
INSERT INTO Factura VALUES('F000000004','CA00000006','000000003C', 2000, 14000);
INSERT INTO Factura VALUES('F000000005','CA00000007','000000003C', 3000, 59500);
INSERT INTO Factura VALUES('F000000006','CA00000008','000000004C', 4000, 23000);
INSERT INTO Factura VALUES('F000000007','CA00000010','000000006C', 1000, 27000);
INSERT INTO Factura VALUES('F000000008','CA00000011','000000008C', 3000, 25500);
INSERT INTO Factura VALUES('F000000009','CA00000013','000000010C', 3000, 25500);
INSERT INTO Factura VALUES('F000000010','CA00000014','000000010C', 3000, 35500);
INSERT INTO Factura VALUES('F000000011','CA00000019','000000015C', 4000, 39500);
INSERT INTO Factura VALUES('F000000012','CA00000020','000000015C', 4000, 42000);
INSERT INTO Factura VALUES('F000000013','CA00000021','000000015C', 4000, 24000);
INSERT INTO Factura VALUES('F000000014','CA00000023','000000017C', 2000, 22500);
INSERT INTO Factura VALUES('F000000015','CA00000026','000000019C', 2000, 28000);
INSERT INTO Factura VALUES('F000000016','CA00000027','000000019C', 2000, 30000);
INSERT INTO Factura VALUES('F000000017','CA00000028','000000020C', 2000, 31000);
INSERT INTO Factura VALUES('F000000018','CA00000029','000000020C', 2000, 28500);
INSERT INTO Factura VALUES('F000000020','CA00000032','000000022C',0,171800);
INSERT INTO Factura VALUES('F000000062','CA00000125','000000075C', 4000, 66300);
INSERT INTO Factura VALUES('F000000118','CA00000028','000000020C', 4000, 27500);
INSERT INTO Factura VALUES('F000000019','CA00000032','000000022C',0,168800);
INSERT INTO Factura VALUES('F000000021','CA00000034','000000022C',0,200800);
INSERT INTO Factura VALUES('F000000022','CA00000035','000000022C',0,200800);
INSERT INTO Factura VALUES('F000000023','CA00000038','000000024C',0,273600);
INSERT INTO Factura VALUES('F000000024','CA00000039','000000024C',0,273600);
INSERT INTO Factura VALUES('F000000025','CA00000041','000000026C',0,163500);
INSERT INTO Factura VALUES('F000000026','CA00000042','000000026C',0,163500);
INSERT INTO Factura VALUES('F000000027','CA00000044','000000028C',0,211000);
INSERT INTO Factura VALUES('F000000028','CA00000045','000000028C',0,180000);
INSERT INTO Factura VALUES('F000000029','CA00000047','000000030C',0,81000);
INSERT INTO Factura VALUES('F000000030','CA00000049','000000031C',0,63000);
INSERT INTO Factura VALUES('F000000031','CA00000051','000000033C',2000,15000);
INSERT INTO Factura VALUES('F000000032','CA00000054','000000037C',5000,32000);
INSERT INTO Factura VALUES('F000000033','CA00000059','000000041C',3000,265000);
INSERT INTO Factura VALUES('F000000133','CA00000061','000000042C',0, 371000);
INSERT INTO Factura VALUES('F000000034','CA00000063','000000044C',2000, 139000);
INSERT INTO Factura VALUES('F000000035','CA00000064','000000044C',2000, 139000);
INSERT INTO Factura VALUES('F000000036','CA00000065','000000044C',2000, 78000);
INSERT INTO Factura VALUES('F000000038','CA00000066','000000044C',2000, 78000);
INSERT INTO Factura VALUES('F000000039','CA00000066','000000046C',2000, 294500);
INSERT INTO Factura VALUES('F000000040','CA00000069','000000047C',1000, 131500);
INSERT INTO Factura VALUES('F000000041','CA00000070','000000047C',1000, 241000);
INSERT INTO Factura VALUES('F000000042','CA00000074','000000050C',4000, 151500);
INSERT INTO Factura VALUES('F000000043','CA00000075','000000050C',4000, 146500);
INSERT INTO Factura VALUES('F000000044','CA00000077','000000052C',2000, 20500);
INSERT INTO Factura VALUES('F000000045','CA00000078','000000052C',2000, 24000);
INSERT INTO Factura VALUES('F000000046','CA00000079','000000054C',2000, 46300);
INSERT INTO Factura VALUES('F000000047','CA00000085','000000054C',2000, 46300);
INSERT INTO Factura VALUES('F000000048','CA00000087','000000056C',2000, 26000);
INSERT INTO Factura VALUES('F000000049','CA00000089','000000058C',2000, 36500);
INSERT INTO Factura VALUES('F000000050','CA00000091','000000060C', 0, 22500);
INSERT INTO Factura VALUES('F000000051','CA00000095','000000061C', 0, 22500);
INSERT INTO Factura VALUES('F000000052','CA00000097','000000063C', 500, 50000);
INSERT INTO Factura VALUES('F000000053','CA00000099','000000065C', 500, 91000);
INSERT INTO Factura VALUES('F000000054','CA00000108','000000066C', 1500, 200000);
INSERT INTO Factura VALUES('F000000055','CA00000109','000000066C', 1500, 200000);
INSERT INTO Factura VALUES('F000000056','CA00000111','000000068C', 3000, 114000);
INSERT INTO Factura VALUES('F000000057','CA00000112','000000068C', 3000, 103000);
INSERT INTO Factura VALUES('F000000058','CA00000113','000000070C', 3000, 107000);
INSERT INTO Factura VALUES('F000000059','CA00000114','000000070C', 3000, 107000);
INSERT INTO Factura VALUES('F000000060','CA00000117','000000071C', 4000, 99500);
INSERT INTO Factura VALUES('F000000061','CA00000121','000000073C', 4000, 63300);
INSERT INTO Factura VALUES('F000000063','CA00000127','000000077C', 4000, 16000);
INSERT INTO Factura VALUES('F000000064','CA00000132','000000079C', 4000, 69000);
INSERT INTO Factura VALUES('F000000065','CA00000134','000000080C', 2000, 39500);

--PAGO
INSERT INTO Pago VALUES('PA00000001','F000000001','21/03/2021','TARJETA',29500);
INSERT INTO Pago VALUES('PA00000002','F000000002','28/07/2021','EFECTIVO',12500);
INSERT INTO Pago VALUES('PA00000003','F000000003','28/07/2021','TARJETA',14100);
INSERT INTO Pago VALUES('PA00000004','F000000004','29/07/2021','TARJETA',14000);
INSERT INTO Pago VALUES('PA00000005','F000000005','29/07/2021','TARJETA',59500);
INSERT INTO Pago VALUES('PA00000006','F000000006','28/07/2021','TARJETA',23000);
INSERT INTO Pago VALUES('PA00000007','F000000007','24/06/2021','TARJETA',27000);
INSERT INTO Pago VALUES('PA00000008','F000000008','25/06/2021','EFECTIVO',25500);
INSERT INTO Pago VALUES('PA00000009','F000000009','26/06/2021','TARJETA',25500);
INSERT INTO Pago VALUES('PA00000010','F000000010','15/04/2021','TARJETA',35500);
INSERT INTO Pago VALUES('PA00000011','F000000011','16/05/2021','TARJETA',39500);
INSERT INTO Pago VALUES('PA00000012','F000000012','16/06/2021','TARJETA',42000);
INSERT INTO Pago VALUES('PA00000013','F000000013','16/07/2021','EFECTIVO',24000);
INSERT INTO Pago VALUES('PA00000014','F000000014','17/07/2021','TARJETA',22500);
INSERT INTO Pago VALUES('PA00000015','F000000015','20/07/2021','TARJETA',28000);
INSERT INTO Pago VALUES('PA00000016','F000000016','20/06/2021','TARJETA',30000);
INSERT INTO Pago VALUES('PA00000017','F000000017','19/04/2021','EFECTIVO',31000);
INSERT INTO Pago VALUES('PA00000018','F000000018','20/06/2021','TARJETA',28500);
INSERT INTO Pago VALUES('PA00000020','F000000020','17/04/2021','TARJETA',171800);
INSERT INTO Pago VALUES('PA00000062','F000000062','29/06/2021','TARJETA',300000);
INSERT INTO Pago VALUES('PA00000162','F000000062','29/06/2021','TARJETA',363000);
INSERT INTO Pago VALUES('PA00000118','F000000118','20/06/2021','TARJETA',27500);
INSERT INTO Pago VALUES('PA00000019','F000000019','20/04/2021','TARJETA',168800);
INSERT INTO Pago VALUES('PA00000021','F000000021','17/06/2021','EFECTIVO',200800);
INSERT INTO Pago VALUES('PA00000022','F000000022','20/06/2021','TARJETA',200800);
INSERT INTO Pago VALUES('PA00000023','F000000023','07/06/2021','TARJETA',273600);
INSERT INTO Pago VALUES('PA00000024','F000000024','07/06/2021','TARJETA',273600);
INSERT INTO Pago VALUES('PA00000025','F000000025','08/06/2021','EFECTIVO',163500);
INSERT INTO Pago VALUES('PA00000026','F000000026','08/06/2021','TARJETA',163500);
INSERT INTO Pago VALUES('PA00000027','F000000027','10/06/2021','TARJETA',211000);
INSERT INTO Pago VALUES('PA00000028','F000000028','05/06/2021','TARJETA',180000);
INSERT INTO Pago VALUES('PA00000029','F000000029','10/06/2021','TARJETA',81000);
INSERT INTO Pago VALUES('PA00000030','F000000030','05/04/2021','TARJETA',63000);
INSERT INTO Pago VALUES('PA00000031','F000000031','06/04/2021','EFECTIVO',15000);
INSERT INTO Pago VALUES('PA00000032','F000000032','06/06/2021','EFECTIVO',32000);
INSERT INTO Pago VALUES('PA00000033','F000000033','08/06/2021','EFECTIVO',265000);
INSERT INTO Pago VALUES('PA00000133','F000000133','07/07/2021','TARJETA',300000);
INSERT INTO Pago VALUES('PA00001133','F000000133','10/07/2021','EFECTIVO',71000);
INSERT INTO Pago VALUES('PA00000034','F000000034','27/07/2021','EFECTIVO',139000);
INSERT INTO Pago VALUES('PA00000035','F000000035','28/06/2021','TARJETA',139000);
INSERT INTO Pago VALUES('PA00000036','F000000036','28/06/2021','TARJETA',78000);
INSERT INTO Pago VALUES('PA00000038','F000000038','29/06/2021','TARJETA',78000);
INSERT INTO Pago VALUES('PA00000039','F000000039','29/06/2021','TARJETA',294500);
INSERT INTO Pago VALUES('PA00000040','F000000040','25/06/2021','TARJETA',131500);
INSERT INTO Pago VALUES('PA00000041','F000000041','21/07/2021','TARJETA',241000);
INSERT INTO Pago VALUES('PA00000042','F000000042','22/07/2021','EFECTIVO',151500);
INSERT INTO Pago VALUES('PA00000043','F000000043','22/07/2021','TARJETA',146500);
INSERT INTO Pago VALUES('PA00000044','F000000044','22/05/2021','TARJETA',20500);
INSERT INTO Pago VALUES('PA00000045','F000000045','23/05/2021','TARJETA',24000);
INSERT INTO Pago VALUES('PA00000046','F000000046','22/06/2021','TARJETA',46300);
INSERT INTO Pago VALUES('PA00000047','F000000047','15/07/2021','TARJETA',46300);
INSERT INTO Pago VALUES('PA00000048','F000000048','13/07/2021','TARJETA',26000);
INSERT INTO Pago VALUES('PA00000049','F000000049','18/05/2021','EFECTIVO',36500);
INSERT INTO Pago VALUES('PA00000050','F000000050','10/07/2021','TARJETA',10000);
INSERT INTO Pago VALUES('PA00000150','F000000050','14/06/2021','EFECTIVO',12500);
INSERT INTO Pago VALUES('PA00000051','F000000051','15/06/2021','TARJETA',22500);
INSERT INTO Pago VALUES('PA00000052','F000000052','15/06/2021','TARJETA',50000);
INSERT INTO Pago VALUES('PA00000053','F000000053','13/06/2021','TARJETA',91000);
INSERT INTO Pago VALUES('PA00000054','F000000054','14/06/2021','TARJETA',200000);
INSERT INTO Pago VALUES('PA00000055','F000000055','03/07/2021','TARJETA',100000);
INSERT INTO Pago VALUES('PA00000155','F000000055','05/07/2021','TARJETA',100000);
INSERT INTO Pago VALUES('PA00000056','F000000056','02/07/2021','TARJETA',114000);
INSERT INTO Pago VALUES('PA00000057','F000000057','03/07/2021','TARJETA',103000);
INSERT INTO Pago VALUES('PA00000058','F000000058','03/07/2021','TARJETA',107000);
INSERT INTO Pago VALUES('PA00000059','F000000059','26/07/2021','TARJETA',107000);
INSERT INTO Pago VALUES('PA00000060','F000000060','12/07/2021','EFECTIVO',99500);
INSERT INTO Pago VALUES('PA00000061','F000000061','03/07/2021','TARJETA',63300);
INSERT INTO Pago VALUES('PA00000063','F000000063','02/07/2021','TARJETA',16000);
INSERT INTO Pago VALUES('PA00000064','F000000064','01/07/2021','TARJETA',30000);
INSERT INTO Pago VALUES('PA00000164','F000000064','05/07/2021','EFECTIVO',30000);
INSERT INTO Pago VALUES('PA00001164','F000000064','03/07/2021','TARJETA',9000);
INSERT INTO Pago VALUES('PA00000065','F000000065','05/07/2021','TARJETA',39500);

--ENTREGA
INSERT INTO Entrega VALUES('EN00000001','F000000001','000000001D');
INSERT INTO MomentoEntrega VALUES('EN00000001','4.640340, -75.576294','DOS DIAS','DESPACHADO');
INSERT INTO MomentoEntrega VALUES('EN00000001','4.648064, -75.570482','2 HORAS','DISTRIBUCION');
INSERT INTO MomentoEntrega VALUES('EN00000001','4.648067, -75.570485','0 MINUTOS','ENTREGADO');

INSERT INTO Entrega VALUES('EN00000002','F000000010','000000002D');
INSERT INTO MomentoEntrega VALUES('EN00000002','5.100078, -75.950973','DOS DIAS','PREPARANDO');
INSERT INTO MomentoEntrega VALUES('EN00000002','4.640350, -75.586294','1 HORAS','DISTRIBUCION');

INSERT INTO Entrega VALUES('EN00000003','F000000011','000000003D');
INSERT INTO MomentoEntrega VALUES('EN00000003','5.101078, -74.950973','1 DIA','PREPARANDO');
INSERT INTO MomentoEntrega VALUES('EN00000003','4.540340, -75.587294','6 HORAS','DESPACHADO');

INSERT INTO Entrega VALUES('EN00000004','F000000017','000000004D');
INSERT INTO MomentoEntrega VALUES('EN00000004','5.201075, -75.960973','2 DIAS','PREPARANDO');
INSERT INTO MomentoEntrega VALUES('EN00000004','4.550340, -76.587294','12 HORAS','DESPACHADO');
INSERT INTO MomentoEntrega VALUES('EN00000004','5.201078, -74.850973','3 HORAS','DISTRIBICION');
INSERT INTO MomentoEntrega VALUES('EN00000004','4.540440, -75.987294','0 MINUTOS','ENTREGADO');

INSERT INTO Entrega VALUES('EN00000005','F000000020','000000005D');
INSERT INTO MomentoEntrega VALUES('EN00000005','4.650340, -76.596294','1 DIAS','DESPACHADO');
INSERT INTO MomentoEntrega VALUES('EN00000005','4.648704, -75.560482','5 HORAS','DISTRIBUCION');

INSERT INTO Entrega VALUES('EN00000007','F000000031','000000008D');
INSERT INTO MomentoEntrega VALUES('EN00000007','4.850340, -76.696294','1 DIAS','DESPACHADO');
INSERT INTO MomentoEntrega VALUES('EN00000007','4.548704, -75.360482','5 HORAS','DISTRIBUCION');
INSERT INTO MomentoEntrega VALUES('EN00000007','4.548704, -75.360482','0 MINUTOS','ENTREGADO');

INSERT INTO Entrega VALUES('EN00000009','F000000044','000000009D');
INSERT INTO MomentoEntrega VALUES('EN00000009','4.850340, -76.691294','1 DIAS','DESPACHADO');
INSERT INTO MomentoEntrega VALUES('EN00000009','4.543604, -75.367482','7 HORAS','DISTRIBUCION');
INSERT INTO MomentoEntrega VALUES('EN00000009','5.648704, -75.368482','0 MINUTOS','ENTREGADO');

INSERT INTO Entrega VALUES('EN00000010','F000000045','000000001D');
INSERT INTO MomentoEntrega VALUES('EN00000010','4.930340, -74.681294','2 DIAS','PREPARANDO');
INSERT INTO MomentoEntrega VALUES('EN00000010','4.950340, -76.691294','1 DIAS','DESPACHADO');
INSERT INTO MomentoEntrega VALUES('EN00000010','4.673664, -75.367483','4 HORAS','DISTRIBUCION');
INSERT INTO MomentoEntrega VALUES('EN00000010','5.658704, -75.367482','0 MINUTOS','ENTREGADO');

--RESEÑA
INSERT INTO Resena VALUES('RE00000001','El producto llego en el tiempo esperado, las maracuyas estaban un pcoo ams pequeñas de lo esperado pero tenian muy buena pulpa',4.0,'25/05/2021','F000000045','PV00000246','000000052C');

INSERT INTO Resena VALUES('RE00000002','Geniales las cebollas compren aqui',4.5,'25/05/2021','F000000044','PV00000218','000000052C');

INSERT INTO Resena VALUES('RE00000003','Que buen yuca, el unico problema es que la entrega se demoro mas de lo esperado',4.0,'25/04/2021','F000000017','PV00000238','000000020C');

INSERT INTO Resena VALUES('RE00000004','Muy bueno ese queso, tenia un sabor y una frescura geniales',4.8,'21/04/2021','F000000010','PV00000099','000000010C');

INSERT INTO Resena VALUES('RE00000005','Estan bien las zanahorias',4.0,'21/04/2021','F000000010','PV00000209','000000010C');