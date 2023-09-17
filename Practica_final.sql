-- Autor: Manuel Estévez Simonet
-- 16/09/2023

-- Práctica final del módulo "Modelado de datos e introducción a SQL"
/*
 * Enunciado
En KeepCoding queremos gestionar la flota de vehículos de empresa, controlando los modelos de los coches, las marcas y el grupo empresarial de la marca (por ejemplo: VW SEAT, Audi etc. pertenecen al grupo VAN)
De los coches también necesitamos saber el color del coche, su matrícula, el número total de kilómetros que tiene, la compañía aseguradora (Mapfre, MMT, AXA, etc), el número de póliza, fecha de compra etc.
A demás queremos controlar de cada coche las revisiones que se ha pasado al coche sabiendo los Kms que tenía en el momento de la revisión, la fecha de la revisión y el importe de la revisión.
Aparte del script, habrá que entregar una consulta SQL para sacar el siguiente listado de coches activos que hay en KeepCoding:
- Nombre modelo, marca y grupo de coches (los nombre de todos)
- Fecha de compra
- Matricula
- Nombre del color del coche
- Total de kilómetros
- Nombre empresa que está asegurado el coche
- Numero de póliza
Nota: Los importes se debe controlar la moneda (EURO, DÓLAR etc.).
 * */

-- Los pasos que se van ejecutar para crear esta BD en Postgresql, serán:
-- Creación de Schema, Creación de tablas, Relaciones entre tablas, Carga de datos generales, Carga de datos coches y Consulta final propuesta por el enunciado

-- Creación de Schema
create schema if not exists Flota;

-- Creación de tablas
create table Flota.Coches(
	ID_Coche SERIAL primary key,
	Matricula varchar(8) not null,
	Fecha_Compra date not null,
	Color varchar(20) not null,
	Kilometros_Totales int not null,
	Id_Modelo int not null
);

create table Flota.Modelos(
	ID_Modelo SERIAL primary key,
	Modelo varchar(20) not null,
	ID_Marca int not null
);

create table Flota.Marcas(
	ID_Marca SERIAL primary key,
	Marca varchar(20) not null,
	ID_Grupo int not null
);

create table Flota.Grupos_Marcas(
	ID_Grupo SERIAL primary key,
	Grupo varchar(50) not null
);

create table Flota.Revisiones (
	ID_Revision SERIAL primary key,
	Descripcion_Revision varchar(50) not null,
	Kilometros_Revision int not null,
	Fecha_Revision date not null,
	Importe_Revision float not null,
	ID_Moneda int not null,
	ID_Coche int not null
);

-- Creamos una tabla exclusiva de Monedas a petición del Enunciado, por si en un futuro se pudiesen añadir nuevas monedas
create table Flota.Monedas (
	ID_Moneda SERIAL primary key,
	Moneda varchar(30) not null,
	Simbolo varchar(5) not null
);

create table Flota.Polizas (
	ID_Poliza SERIAL primary key,
	Poliza varchar(10) not null,
	Fecha_Alta date not null,
	ID_Coche int not null,
	ID_Aseguradora int not null
);

create table Flota.Aseguradoras (
	ID_Aseguradora SERIAL primary key,
	Aseguradora varchar(20) not null,
	Es_Solo_Virtual boolean not null
);

-- Relaciones entre tablas
alter table Flota.Coches add constraint ID_Modelo foreign key (ID_Modelo) references Flota.Modelos (ID_Modelo);
alter table Flota.Modelos add constraint ID_Marca foreign key (ID_Marca) references Flota.Marcas (ID_Marca);
alter table Flota.Marcas add constraint ID_Grupo foreign key (ID_Grupo) references Flota.Grupos_Marcas (ID_Grupo);
alter table Flota.Revisiones add constraint ID_Coche foreign key (ID_Coche) references Flota.Coches (ID_Coche);
alter table Flota.Revisiones add constraint ID_Moneda foreign key (ID_Moneda) references Flota.Monedas (ID_Moneda);
alter table Flota.Polizas add constraint ID_Coche foreign key (ID_Coche) references Flota.Coches (ID_Coche);
alter table Flota.Polizas add constraint ID_Aseguradora foreign key (ID_Aseguradora) references Flota.Aseguradoras (ID_Aseguradora);

-- Carga de datos generales
-- NOTA: hay que cargarlos en el siguiente orden de dependencia entre datos, para evitar errores tal como violación de clave foranea u otros.
insert into Flota.Grupos_Marcas (Grupo) values ('BMW Group'),('Daimler Group'),('General Motors Group'),('Hyundai Motor Group'),('PSA Peugeot S.A.'),('Renault-Nissan-Mitsubishi Alliance'),('Tata Motors Group'),('Volkswagen Group');
insert into Flota.Marcas (ID_Grupo, Marca) values (1,'BMW'),(1,'Mini'),(1,'Rolls-Royce'),(2,'Mercedes-Benz'),(2,'Smart'),(3,'Baojuin'),(3,'Buick'),(3,'Cadillac'),(3,'Chevrolet'),(3,'Holden'),(3,'Wuling Motors'),(4,'Hyundai'),(4,'Genesis'),(4,'Kia'),(5,'Citroën'),(5,'DS'),(5,'Opel'),(5,'Peugeot'),(5,'Vauxhall'),(6,'Alpine'),(6,'Dacia'),(6,'Datsun'),(6,'Infiniti'),(6,'Lada'),(6,'Mitsubishi'),(6,'Nissan'),(6,'Renault'),(6,'Samsung'),(6,'Venuncia'),(7,'Jaguar'),(7,'Land Rover'),(7,'Tata Motors'),(8,'Audi'),(8,'Bentley'),(8,'Bugatti'),(8,'Lamborghini'),(8,'Porsche'),(8,'Seat'),(8,'Cupra'),(8,'Skoda'),(8,'Volkswagen');
insert into Flota.Modelos (ID_Marca, Modelo) values (6,'A110'),(8,'A3'),(8,'A4'),(8,'A6'),(8,'Q5'),(8,'Q7'),(8,'R8'),(3,'510'),(8,'Continental GT'),(8,'Bentayga'),(1,'3 Series'),(1,'5 Series'),(1,'X3'),(1,'X5'),(1,'7 Series'),(1,'M3'),(1,'M5'),(8,'Chiron'),(8,'Veyron'),(8,'Encore'),(3,'Enclave'),(3,'Regal'),(3,'Escalade'),(3,'CTS'),(3,'XT5'),(3,'Camaro'),(3,'Silverado'),(3,'Equinox'),(5,'C3'),(5,'C4'),(5,'C5'),(5,'Berlingo'),(8,'Ateca'),(8,'Formentor'),(8,'Leon'),(6,'Sandero'),(6,'Duster'),(6,'Logan'),(6,'Redi-Go'),(6,'Go'),(6,'Cross'),(5,'DS3'),(5,'DS7 Crossback'),(4,'G70'),(4,'G80'),(4,'G90'),(3,'Commodore'),(3,'Colorado'),(4,'Sonata'),(4,'Tucson'),(4,'Santa Fe'),(4,'Elantra'),(6,'Q50'),(6,'Q60'),(6,'QX80'),(7,'F-PACE'),(7,'XF'),(7,'XE'),(7,'I-PACE'),(4,'Sportage'),(4,'Sorento'),(4,'Soul'),(4,'Optima'),(6,'Vesta'),(6,'Niva'),(8,'Huracán'),(8,'Aventador'),(8,'Urus'),(7,'Range Rover'),(7,'Discovery'),(7,'Defender'),(2,'C-Class'),(2,'E-Class'),(2,'S-Class'),(2,'GLC'),(2,'GLE'),(2,'AMG GT'),(1,'Cooper'),(1,'Countryman'),(6,'Outlander'),(6,'Pajero'),(6,'Eclipse Cross'),(6,'Altima'),(6,'Maxima'),(6,'Rogue'),(6,'Juke'),(5,'Astra'),(5,'Corsa'),(5,'Insignia'),(5,'208'),(5,'308'),(5,'508'),(5,'2008'),(8,'911'),(8,'Cayenne'),(8,'Panamera'),(8,'Macan'),(6,'Clio'),(6,'Megane'),(6,'Captur'),(1,'Phantom'),(1,'Ghost'),(1,'Wraith'),(6,'SM3'),(6,'SM5'),(6,'SM7'),(8,'Ibiza'),(8,'Leon'),(8,'Ateca'),(8,'Octavia'),(8,'Superb'),(8,'Kodiaq'),(2,'ForTwo'),(2,'ForFour'),(7,'Tiago'),(7,'Nexon'),(7,'Harrier'),(5,'Corsa'),(5,'Astra'),(5,'Insignia'),(8,'Golf'),(8,'Passat'),(8,'Tiguan'),(8,'Polo'),(3,'Hong Guang'),(3,'Rong Guang');
insert into Flota.Monedas (Moneda, Simbolo) values ('Dolar','$'),('Dolar Australiano','A$'),('Euro','€'),('Peso Mexicano','$'),('Peso Colmbiano','$'),('Yen Japones','¥'),('Rupia India','₹'),('Won Surcoreano','₩');
insert into Flota.Aseguradoras (Aseguradora,Es_Solo_Virtual) values ('Acierto',true),('Allianz',false),('AMA',false),('Aro',false),('Atlantis',false),('AXA',false),('Catalana Occidente',false),('Generali',false),('Génesis',false),('Helvetia',false),('Liberty',false),('Línea Directa',true),('Mapfre',false),('MMT',false),('Mutua Madrileña',false),('RACC',false),('Race',false),('Rastreator',true),('Reale',false),('Regal',false),('SegurCaixa Adeslas',false),('Verti',true),('Zurich',false);

-- Carga de datos coches
insert into Flota.Coches (Matricula, Fecha_Compra, Color, Kilometros_Totales, ID_Modelo) values ('1234-AZX','2023-09-15','Rojo',25000,73),('5678-BNM','2023-09-14','Azul',32000,42),('9876-XYZ','2023-09-13','Verde',15000,95),('4321-HJK','2023-09-12','Blanco',28000,11),('8765-QRP','2023-09-11','Negro',19000,61),('2345-XYZ','2023-09-10','Gris',35000,29),('6789-JKL','2023-09-09','Amarillo',22000,105),('5432-QRP','2023-09-08','Naranja',28000,82),('7890-BNM','2023-09-07','Plateado',32000,19),('3456-HJK','2023-09-06','Dorado',21000,53),('8901-JKL','2023-09-05','Negro mate',27000,71),('4567-QRP','2023-09-04','Verde esmeralda',18000,33),('9012-XYZ','2023-09-03','Azul marino',31000,104),('6543-HJK','2023-09-02','Rojo carmesí',24000,77),('2109-XYZ','2023-09-01','Magenta',26000,10),('5432-JKL','2023-08-31','Turquesa',33000,58),('8765-HJK','2023-08-30','Rosa',17000,35),('1234-QRP','2023-08-29','Gris perla',29000,90),('5678-BNM','2023-08-28','Cian',20000,24),('9876-XYZ','2023-08-27','Verde oliva',36000,43),('4321-JKL','2023-08-26','Dorado rosa',23000,99),('8765-BNM','2023-08-25','Púrpura',27000,59),('2345-HJK','2023-08-24','Bronce',31000,14),('6789-QRP','2023-08-23','Gris antracita',19000,78),('5432-XYZ','2023-08-22','Verde lima',25000,55),('7890-JKL','2023-08-21','Naranja quemado',33000,25),('3456-BNM','2023-08-20','Plateado mate',22000,66),('8901-HJK','2023-08-19','Gris tormenta',30000,37),('4567-QRP','2023-08-18','Azul cobalto',26000,49),('9012-XYZ','2023-08-17','Amarillo limón',29000,79),('6543-JKL','2023-08-16','Rosa pastel',18000,8),('2109-XYZ','2023-08-15','Verde menta',32000,60),('5432-BNM','2023-08-14','Negro brillante',17000,72),('8765-HJK','2023-08-13','Azul eléctrico',25000,87),('1234-JKL','2023-08-12','Blanco perla',31000,23),('5678-QRP','2023-08-11','Marrón chocolate',23000,38),('9876-BNM','2023-08-10','Platino',27000,96),('4321-HJK','2023-08-09','Amarillo oro',24000,9),('8765-XYZ','2023-08-08','Verde bosque',29000,98),('2345-QRP','2023-08-07','Azul zafiro',20000,75),('6789-HJK','2023-08-06','Gris pizarra',34000,54),('5432-JKL','2023-08-05','Turquesa brillante',19000,32),('7890-XYZ','2023-08-04','Naranja brillante',28000,68),('3456-HJK','2023-08-03','Verde esmeralda',21000,41),('8901-QRP','2023-08-02','Azul celeste',33000,84),('4567-BNM','2023-08-01','Rojo rubí',28000,91);

-- Carga de datos revisiones de algunos de los coches
insert into Flota.Revisiones (Descripcion_Revision,Kilometros_Revision,Fecha_Revision,Importe_Revision,ID_Moneda,ID_Coche) values ('Problema con la transmisión',15000,'2023-09-10',350.50,4,18),('Fallo en el sistema de frenos',22000,'2023-08-28',450.75,6,7),('Motor sobrecalentado',18000,'2023-09-03',550.25,2,12),('Problema eléctrico',30000,'2023-08-15',650.00,7,22),('Neumáticos desgastados',25000,'2023-08-20',375.80,5,28),('Fallo en la dirección',19000,'2023-09-05',720.90,3,19),('Problema con el aire acondicionado',28000,'2023-08-22',420.60,1,8),('Fuga de aceite',16000,'2023-09-08',580.30,8,3),('Ruido en el motor',27000,'2023-08-18',510.40,2,25),('Problema en la suspensión',21000,'2023-08-31',690.70,7,13),('Fallo en la transmisión',14000,'2023-09-12',475.20,4,26),('Luces intermitentes no funcionan',32000,'2023-08-10',325.95,6,9),('Problema en el escape',20000,'2023-08-25',800.15,3,20),('Fallo en el sistema de encendido',17000,'2023-09-07',600.45,5,17),('Problema en la batería',24000,'2023-08-24',410.70,1,5),('Freno de mano no funciona',26000,'2023-09-01',720.80,8,11),('Ruido en la suspensión',23000,'2023-08-29',540.25,2,16),('Problema con el radiador',17000,'2023-09-11',480.90,7,29),('Fallo en el sistema de luces',19000,'2023-08-14',395.75,6,1),('Neumático pinchado',29000,'2023-08-17',725.60,4,14),('Problema en el alternador',18000,'2023-09-02',570.30,3,24),('Fallo en el sistema de inyección',15000,'2023-08-27',640.45,5,27),('Problema en el embrague',31000,'2023-08-19',365.20,1,10),('Ruido en la dirección',22000,'2023-08-30',460.75,8,6),('Fallo en el sistema de escape',19000,'2023-09-06',790.90,2,15),('Fallo en el sistema de suspensión',28000,'2023-08-23',610.60,7,21),('Problema en el sistema de climatización',21000,'2023-08-16',420.30,6,4),('Fallo en el sistema de dirección',27000,'2023-08-21',555.40,4,23),('Problema en el sistema de frenado',25000,'2023-09-09',690.70,3,2),('Motor no arranca',17000,'2023-08-26',500.20,1,30),('Problema en el sistema eléctrico',16000,'2023-09-04',725.80,8,19),('Fallo en el sistema de suspensión',24000,'2023-08-13',395.45,7,7),('Problema en el sistema de dirección',19000,'2023-09-10',620.60,6,28),('Fallo en el sistema de frenos',22000,'2023-08-20',445.70,5,9),('Problema en el sistema de encendido',15000,'2023-08-31',530.40,2,13),('Ruido en el motor',31000,'2023-09-12',470.90,1,22),('Fallo en la transmisión',18000,'2023-08-10',665.15,4,17),('Problema con el radiador',26000,'2023-08-25',720.25,8,15),('Motor sobrecalentado',27000,'2023-09-05',400.60,3,12),('Problema en la batería',32000,'2023-08-22',600.80,7,6),('Fuga de aceite',21000,'2023-08-15',550.70,6,1),('Problema en el sistema de escape',28000,'2023-08-24',325.45,5,11),('Fallo en el sistema de inyección',19000,'2023-09-08',475.30,2,16),('Freno de mano no funciona',22000,'2023-08-28',800.90,1,26),('Neumáticos desgastados',15000,'2023-08-18',380.60,4,27),('Problema en el sistema de climatización',19000,'2023-09-07',610.75,7,10),('Fallo en el alternador',26000,'2023-08-19',690.45,8,4),('Luces intermitentes no funcionan',23000,'2023-09-03',420.20,3,21),('Problema en el sistema de dirección',20000,'2023-08-29',550.80,2,29),('Problema en el embrague',29000,'2023-08-27',730.30,5,14);

-- Carga de polizas de los coches
insert into Flota.Polizas (Poliza,Fecha_Alta,ID_Coche,ID_Aseguradora) values ('123456','2023-09-15',7,19),('234567','2023-08-25',14,10),('345678','2023-08-10',29,8),('456789','2023-09-12',11,15),('567890','2023-08-31',26,21),('678901','2023-08-20',22,12),('789012','2023-09-05',9,7),('890123','2023-09-10',15,18),('901234','2023-08-29',18,4),('012345','2023-08-15',28,13),('123456','2023-08-27',3,23),('234567','2023-08-22',13,9),('345678','2023-09-04',12,19),('456789','2023-08-18',17,20),('567890','2023-08-17',7,1),('678901','2023-08-24',1,3),('789012','2023-09-08',2,10),('890123','2023-09-11',25,22),('901234','2023-09-14',8,11),('012345','2023-08-19',23,2),('123456','2023-08-30',5,6),('234567','2023-08-14',10,17),('345678','2023-08-28',21,5),('456789','2023-09-01',16,16),('567890','2023-09-03',19,14),('678901','2023-08-23',24,8),('789012','2023-09-07',6,21),('890123','2023-09-09',27,12),('901234','2023-09-06',4,7),('012345','2023-08-21',20,15),('123456','2023-08-26',11,23),('234567','2023-09-02',14,9),('345678','2023-08-16',12,19),('456789','2023-08-29',17,20),('567890','2023-09-03',7,1),('678901','2023-08-25',1,3),('789012','2023-09-08',28,10),('890123','2023-08-27',25,22),('901234','2023-08-30',8,11),('012345','2023-08-19',23,2),('123456','2023-09-05',5,6),('234567','2023-08-14',10,17),('345678','2023-09-01',21,5),('456789','2023-08-18',16,16),('567890','2023-08-17',19,14),('678901','2023-08-23',24,8),('789012','2023-09-07',6,21),('890123','2023-09-09',27,12),('901234','2023-09-06',4,7);

-- Consulta final propuesta por el enunciado
select -- Voy a cargar todos los datos de la consulta con sus correspondientes alias y join creados mas adelante en la select
	md.Modelo, 
    mr.Marca,
	gr.Grupo,
    TO_CHAR(co.Fecha_Compra, 'DD/MM/YYYY') AS fecha_de_compra, --Formateo la fecha para que quede en sistema español
	co.Matricula,
    co.Color,
    co.Kilometros_Totales,
    ag.Aseguradora,
    po.Poliza
from Flota.Coches co  -- Voy creando alias de las tablas para poder hacer join entre ellas y poder relacionar todos los datos para una consulta unica
join Flota.Modelos md on co.ID_Modelo = md.ID_Modelo -- Voy haciendo join entre las relaciones que me interesan en sucesivas lineas
join Flota.Marcas mr on md.ID_Marca = mr.ID_Marca
join Flota.Grupos_Marcas gr on mr.ID_Grupo = gr.ID_Grupo
join Flota.Polizas po on co.ID_Coche = po.ID_Coche
join Flota.Aseguradoras ag on po.ID_Aseguradora = ag.ID_Aseguradora;