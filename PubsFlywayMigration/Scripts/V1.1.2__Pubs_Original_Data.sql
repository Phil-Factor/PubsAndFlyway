
INSERT authors
VALUES
( N'172-32-1176', N'White', N'Johnson', '408 496-7223', N'10932 Bigge Rd.', N'Menlo Park', 'CA', '94025', 1 ), 
( N'213-46-8915', N'Green', N'Marjorie', '415 986-7020', N'309 63rd St. #411', N'Oakland', 'CA', '94618', 1 ), 
( N'238-95-7766', N'Carson', N'Cheryl', '415 548-7723', N'589 Darwin Ln.', N'Berkeley', 'CA', '94705', 1 ), 
( N'267-41-2394', N'O''Leary', N'Michael', '408 286-2428', N'22 Cleveland Av. #14', N'San Jose', 'CA', '95128', 1 ), 
( N'274-80-9391', N'Straight', N'Dean', '415 834-2919', N'5420 College Av.', N'Oakland', 'CA', '94609', 1 ), 
( N'341-22-1782', N'Smith', N'Meander', '913 843-0462', N'10 Mississippi Dr.', N'Lawrence', 'KS', '66044', 0 ), 
( N'409-56-7008', N'Bennet', N'Abraham', '415 658-9932', N'6223 Bateman St.', N'Berkeley', 'CA', '94705', 1 ), 
( N'427-17-2319', N'Dull', N'Ann', '415 836-7128', N'3410 Blonde St.', N'Palo Alto', 'CA', '94301', 1 ), 
( N'472-27-2349', N'Gringlesby', N'Burt', '707 938-6445', N'PO Box 792', N'Covelo', 'CA', '95428', 1 ), 
( N'486-29-1786', N'Locksley', N'Charlene', '415 585-4620', N'18 Broadway Av.', N'San Francisco', 'CA', '94130', 1 ), 
( N'527-72-3246', N'Greene', N'Morningstar', '615 297-2723', N'22 Graybar House Rd.', N'Nashville', 'TN', '37215', 0 ), 
( N'648-92-1872', N'Blotchet-Halls', N'Reginald', '503 745-6402', N'55 Hillsdale Bl.', N'Corvallis', 'OR', '97330', 1 ), 
( N'672-71-3249', N'Yokomoto', N'Akiko', '415 935-4228', N'3 Silver Ct.', N'Walnut Creek', 'CA', '94595', 1 ), 
( N'712-45-1867', N'del Castillo', N'Innes', '615 996-8275', N'2286 Cram Pl. #86', N'Ann Arbor', 'MI', '48105', 1 ), 
( N'722-51-5454', N'DeFrance', N'Michel', '219 547-9982', N'3 Balding Pl.', N'Gary', 'IN', '46403', 1 ), 
( N'724-08-9931', N'Stringer', N'Dirk', '415 843-2991', N'5420 Telegraph Av.', N'Oakland', 'CA', '94609', 0 ), 
( N'724-80-9391', N'MacFeather', N'Stearns', '415 354-7128', N'44 Upland Hts.', N'Oakland', 'CA', '94612', 1 ), 
( N'756-30-7391', N'Karsen', N'Livia', '415 534-9219', N'5720 McAuley St.', N'Oakland', 'CA', '94609', 1 ), 
( N'807-91-6654', N'Panteley', N'Sylvia', '301 946-8853', N'1956 Arlington Pl.', N'Rockville', 'MD', '20853', 1 ), 
( N'846-92-7186', N'Hunter', N'Sheryl', '415 836-7128', N'3410 Blonde St.', N'Palo Alto', 'CA', '94301', 1 ), 
( N'893-72-1158', N'McBadden', N'Heather', '707 448-4982', N'301 Putnam', N'Vacaville', 'CA', '95688', 0 ), 
( N'899-46-2035', N'Ringer', N'Anne', '801 826-0752', N'67 Seventh Av.', N'Salt Lake City', 'UT', '84152', 1 ), 
( N'998-72-3567', N'Ringer', N'Albert', '801 826-0752', N'67 Seventh Av.', N'Salt Lake City', 'UT', '84152', 1 )


GO

RAISERROR('Now at the inserts to publishers ....', 0, 1);

GO

INSERT publishers VALUES
( '0736    ', N'New Moon Books', N'Boston', 'MA', 'USA' ), 
( '0877    ', N'Binnet & Hardley', N'Washington', 'DC', 'USA' ), 
( '1389    ', N'Algodata Infosystems', N'Berkeley', 'CA', 'USA' ), 
( '1622    ', N'Five Lakes Publishing', N'Chicago', 'IL', 'USA' ), 
( '1756    ', N'Ramona Publishers', N'Dallas', 'TX', 'USA' ), 
( '9901    ', N'GGG&G', N'M?nchen', NULL, 'Germany' ), 
( '9952    ', N'Scootney Books', N'New York', 'NY', 'USA' ), 
( '9999    ', N'Lucerne Publishing', N'Paris', NULL, 'France' )

GO

RAISERROR('Now at the inserts to pub_info ....', 0, 1);

GO

INSERT pub_info
VALUES
  ('0736',
0x474946383961D3001F00B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000D3001F004004FFF0C949ABBD38EBCDBBFF60288E245001686792236ABAB03BC5B055B3F843D3B99DE2AB532A36FB15253B19E5A6231A934CA18CB75C1191D69BF62AAD467F5CF036D8243791369F516ADEF9304AF8F30A3563D7E54CFC04BF24377B5D697E6451333D8821757F898D8E8F1F76657877907259755E5493962081798D9F8A846D9B4A929385A7A5458CA0777362ACAF585E6C6A84AD429555BAA9A471A89D8E8BA2C3C7C82DC9C8AECBCECF1EC2D09143A66E80D3D9BC2C41D76AD28FB2CD509ADAA9AAC62594A3DF81C65FE0BDB5B0CDF4E276DEF6DD78EF6B86FA6C82C5A2648A54AB6AAAE4C1027864DE392E3AF4582BF582DFC07D9244ADA2480BD4C6767BFF32AE0BF3EF603B3907490A4427CE21A7330A6D0584B810664D7F383FA25932488FB96D0F37BDF9491448D1A348937A52CAB4A9D3784EF5E58B4A5545D54BC568FABC9A68DD526ED0A6B8AA17331BD91E5AD9D1D390CED23D88F54A3ACB0A955ADDAD9A50B50D87296E3EB9C76A7CDAABC86B2460040DF34D3995515AB9FF125F1AFA0DAB20A0972382CCB9F9E5AEBC368B21EEDB66EDA15F1347BE2DFDEBB44A7B7C6889240D9473EB73322F4E8D8DBBE14D960B6519BCE5724BB95789350E97EA4BF3718CDD64068D751A261D8B1539D6DCDE3C37F68E1FB58E5DCED8A44477537049852EFD253CEE38C973B7E9D97A488C2979FB936FBAFF2CF5CB79E35830400C31860F4A9BE925D4439F81B6A073BEF1575F593C01A25B26127255D45D4A45B65B851A36C56154678568A20E1100003B,
'This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.

This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.');

INSERT pub_info
VALUES
  ('0877',
0x4749463839618B002F00B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C000000008B002F004004FFF0C949ABBD38EBCDBBFFA0048464089CE384A62BD596309CC6F4F58A287EBA79ED73B3D26A482C1A8FC8A47249FCCD76BC1F3058D94135579C9345053D835768560CFE6A555D343A1B6D3FC6DC2A377E66DBA5F8DBEBF6EEE1FF2A805B463A47828269871F7A3D7C7C8A3E899093947F666A756567996E6C519E167692646E7D9C98A42295ABAC24A092AD364C737EB15EB61B8E8DB58FB81DB0BE8C6470A0BE58C618BAC365C5C836CEA1BCBBC4C0D0AAD6D14C85CDD86FDDDFAB5F43A580DCB519A25B9BAE989BC3EEA9A7EBD9BF54619A7DF8BBA87475EDA770D6C58B968C59A27402FB99E2378FC7187010D5558948B15CC58B4E20CE9A762E62B558CAB86839FC088D24AB90854662BCD60D653E832BBD7924F49226469327FDEC91C6AD2538972E6FFEE429720D4E63472901251A33A9D28DB47A5A731A7325D56D50B36ADDAA2463D5AF1EAE82F5F84FAA946656AA21AC31D0C4BF85CBA87912D6D194D4B535C5DDDBA93221CB226D022E9437D89C594305FD321C0CB7DFA5C58223036E088F3139B9032563DD0BE66D2ACD8B2BCB9283CEDEE3C6A53EE39BA7579A62C1294917DC473035E0B9E3183F9A3BB6F7ABDE608B018800003B,
'This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.

This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.

This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.

This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.

This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.');

INSERT pub_info
VALUES
  ('1389',
0x474946383961C2001D00B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000C2001D004004FFF0C949ABBD38EBCDBBFF60288E1C609E2840AE2C969E6D2CCFB339D90F2CE1F8AEE6BC9FEF26EC01413AA3F2D76BAA96C7A154EA7CC29C449AC7A8ED7A2FDC2FED25149B29E4D479FD55A7CBD931DC35CFA4916171BEFDAABC51546541684C8285847151537F898A588D89806045947491757B6C9A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A95A6A3E64169923B0901A775B7566B25D7F8C888A5150BE7B8F93847D8DC3C07983BEBDC1878BCFAF6F44BBD0AD71C9CBD653BFD5CEC7D1C3DFDB8197D8959CB9AAB8B7EBEEEFF0BA92F1B6B5F4A0F6F776D3FA9EBCFD748C01DCB4AB5DBF7C03CF1454070F61423D491C326BA18E211081250C7AB12867619825F37F2ECE1168AC242B6A274556D121D28FA46C11E78564C5B295308F21BBF5CAD6CCE52C7018813932C4ED5C517346B7C1C2683368349D49A19D0439D31538A452A916135A0B19A59AAB9E6A835A0EABD00E5CD11D1D478C1C59714053AA4C4955AB4B9956879AB497F62E1CBA2373DA25B752239F8787119390AB5806C74E1100003B,
'This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.

This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.');

INSERT pub_info
VALUES
  ('1622',
0x474946383961F5003400B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000F50034004004FFF0C949ABBD38EBCDBBFF60288E64D90166AA016CEBBEB02ACF746D67E82DC2ACEEFFC0A02997B31027C521EF25698D8E42230E049D3E8AD8537385BC4179DB6B574C26637BE58BF38A1EB393DF2CE55CA52731F77918BE9FAFCD6180817F697F5F6E6C7A836D62876A817A79898A7E31524D708E7299159C9456929F9044777C6575A563A68E827D9D4C8D334BB3B051B6B7B83A8490B91EB4B3BDC1C251A1C24BC3C8C9C8C5C4BFCCCAD0D135ACC36B2E3BBCB655AD1CDB8F6921DEB8D48AA9ADA46046D7E0DC829B9D98E9988878D9AAE5AEF875BC6DEFF7E7A35C9943F18CCA3175C0A4295C48625F3B8610234A0C17D159C289189515CC7531A3C7891BFF9B59FA4812634820F24AAA94882EA50D8BBB3E8813598B8A3D7C0D6F12CB8710E5BA7536D9ED3C458F8B509CF17CE94CEA658F254D944889528306E83C245089629DDA4F8BD65885049ACBB7ADAB2A5364AFDAF344902752409A6085FA39105EBB3C2DAB2E52FA8611B7ACFA060956CB1370598176DB3E74FB956CCCA77207BB6B8CAAAADEA3FFBE01A48CD871D65569C37E25A458C5C9572E57AADE59F7F40A98B456CB36560F730967B3737B74ADBBB7EFDABF830BE70B11F6C8E1C82F31345E33B9F3A5C698FB7D4E9D779083D4B313D7985ABB77E0C9B07F1F0F3EFA71F2E8ED56EB98BEBD7559306FC72C6995EA7499F3B5DDA403FF17538AB6FD20C9FF7D463D531681971888E0104E45069D7C742D58DB7B29B45454811B381420635135B5D838D6E487612F876D98D984B73D2820877DFD871523F5E161D97DD7FCB4C82E31BEC8176856D9D8487D95E1E5D711401AE2448EF11074E47E9D69359382E8A8871391880C28E5861636399950FEFCA55E315D8279255C2C6AA89899B68588961C5B82C366693359F1CA89ACACB959971D76F6E6607B6E410E9D57B1A9196A52BDD56636CC08BA519C5E1EDA8743688906DA9D53F2E367999656A96292E2781397A6264E62A04E25FE49A59354696958409B11F527639DEAC84E7795553A9AACA85C68E8977D2A7919A5A7F83329A46F0D79698BF60D98688CCC118A6C3F8F38E6D89C8C12F635E49145F6132D69DCCE684725FC0546C3B40875D79E70A5867A8274E69E8BAEAC1FEEC02E92EE3AA7ADA015365BEFBE83F2EB6F351100003B,
'This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.

This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.');

INSERT pub_info
VALUES
  ('1756',
0x474946383961E3002500B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000E30025004004FFF0C949ABBD38EBCDBBFF60288E240858E705A4D2EA4E6E0CC7324DD1EB9CDBBAFCE1AC878DE7ABBD84476452C963369F2F288E933A595B404DB27834E67A5FEC37ACEC517D4EB24E5C8D069966361A5E8ED3C3DCA5AA54B9B2AE2D423082817F848286898386858754887B8A8D939094947E918B7D8780959E9D817C18986FA2A6A75A7B22A59B378E1DACAEB18F1940B6A8B8A853727AB5BD4E76676A37BFB9AF2A564D6BC0776E635BCE6DCFD2C3C873716879D4746C6053DA76E0DAB3A133D6D5B290929F9CEAEDEB6FA0C435EF9E97F59896EC28EEFA9DFF69A21C1BB4CA1E3E63084DB42B970FD6407D05C9E59298B0A2C58B18337AA0E88DA3468DC3FFD0692187A7982F5F2271B152162DE54795CEB0F0DAF8EBDA2A932F1FF203B38C484B6ED07674194ACD639679424B4EDB36279B4D3852FE1095266743955138C5209ADA6D5CB26DCDFC644DD351EACF804BCD32421A562DB6965F25AADD11B056BD7BA436C903E82A1D4A3D024769BAE777B0BB7887F51A0E022E9589BCFCE0DD6527597223C4917502ACBCF8D5E6C49F0B6FA60751A7C2748A3EE7DD6B70B5628F9A5873C6DB5936E57EB843C726043B95EBDE394F3584EC7096ED8DA60D86001EBCB9F3E72F99439F0E7DEC7297BA84D9924EFDB11A65566B8EFB510C7CC258DBB7779F7834A9756E6C97D114F95E5429F13CE5F7F9AAF51C996928604710FF544AFDC79717C10CD85157C6EDD75F7EB49C81D45C5EA9674E5BBBA065941BFB45F3D62D5E99E11488516568A15D1292255F635E8045E0520F3E15A0798DB5C5A08105EE52E3884C05255778E6F5C4A287CCB4D84D1D41CE08CD913C56656482EAEDE8E38D71B974553C199EC324573C3669237C585588E52D1ACE049F85521648659556CD83445D27C9F4D68501CE580E31748ED4948C0E3E88959B257C87E39D0A8EC5D812559234996A9EE5B6E864FE31BA5262971DE40FA5B75D9A487A9A79975C6AB5DD06EA6CCA9DB94FA6A1568AD8A4C33DBA6A5995EE5450AC0AA24A9C6DBAE9F6883CB48976D0ABA8D90AA9A88D6246C2ABA3FE8A1B43CA229B9C58AFC11E071AB1D1BE366DB5C9AE85DCA48595466B83AC95C61DA60D1146EEB3BB817ADA40A08CFBDBB2EB9972EB6EDB66D26D71768D5B2B1FEFC65B11AFA5FA96C93AF50AA6AFBEFE263C1DC0FCA2AB8AC210472C310A1100003B,
'This is sample text data for Ramona Publishers, publisher 1756 in the pubs database. Ramona Publishers is located in Dallas, Texas.');

INSERT pub_info
VALUES
  ('9901',
0x4749463839615D002200B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C000000005D0022004004FFF0C949ABBD38EBCDFB03DF078C249895A386AA68BB9E6E0ACE623ABD1BC9E9985DFFB89E8E366BED782C5332563ABA4245A6744AAD5AAF4D2276CBED5EA1D026C528B230CD38B2C92721D78CC4772526748F9F611EB28DE7AFE25E818283604A1E8788898A7385838E8F55856F6C2C1D86392F6B9730708D6C5477673758A3865E92627E94754E173697A6A975809368949BB2AE7B9A6865AA734F80A2A17DA576AA5BB667C290CDCE4379CFD2CE9ED3D6A7CCD7DAA4D9C79341C8B9DF5FC052A8DEBA9BB696767B9C7FD5B8BBF23EABB9706BCAE5F05AB7E6C4C7488DDAF7251BC062530EFE93638C5B3580ECD4951312C217C425E73E89D38709D79D810D393BD20A528CE0AA704AA2D4D3082E583C89BD2C2D720753E1C8922697D44CF6AE53BF6D4041750B4AD467C54548932A1D7374A9D3A789004400003B,
'This is sample text data for GGG&G, publisher 9901 in the pubs database. GGG&G is located in M�nchen, Germany.');

INSERT pub_info
VALUES
  ('9952',
0x47494638396107012800B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000070128004004FFF0C949ABBD38EBCDBBFF60288E6469660005AC2C7BB56D05A7D24C4F339E3F765FC716980C3824F28418E4D1A552DA8ACCA5517A7B526F275912690D2A9BD11D14AB8B8257E7E9776BDEE452C2279C47A5CBEDEF2B3C3FBF9FC85981821D7D76868588878A898C8B838F1C8D928E733890829399949B979D9E9FA074A1A3A4A5A6A7458F583E69803F53AF4C62AD5E6DB13B6B3DAEAC6EBA64B365B26BB7ABBEB5C07FB428BCC4C8C1CCC7BBB065637C7A9B7BBE8CDADBDA8B7C31D9E1D88E2FA89E9AE9E49AE7EDA48DA2EEF2F3F4F597AEF6F9FAFBFC805D6CD28C0164C64D18BE3AAD88D87AA5C1DBC07FD59CE54293F0E0882AC39ED9CA2886E3308FB3FF262EBC726D591823204F2E0C09A4A3B32CFEACBC24198D86C48FD3E208D43832E3C0671A2D89737167281AA333219AC048D061499A3C83BEC8090BD84E5A99DE808B730DE9516B727CE85AE7C122BF73EAD29255CB76ADDBB6EC549C8504F7AD5DB37343A98D97576EDDBF7CFB0AEE8457EF5D4E83132BAEB1B8B1E3C749204B9EACB830E5CB984DE1F339A4E1CC88C93CB7D989D72234D1D3A672FEF85055C483C80A06742ADB664F3563119E417D5A8F52DFB1512AEC5D82E9C8662A477FB19A72B6F2E714413F8D0654AA75A8C4C648FDBC346ACDCD5487AFC439BE8BC8E8AA7F6BD77D2B7DF4E6C5882E57DFBDE2F56AEE6D87DFB8BFE06BE7E8F1C6CBCE4D2DC15751803C5956567EFA1D47A041E5F1176183CC1D571D21C2850396565CF5B1D5571D8AC21D08E099A15E85269E87207B1736B31E6FE620324E582116F5215178C86763518A9068DF7FE8C9C6207DCD0104A47B6B717388901EFA27238E3482454E43BB61E8D388F7FD44DD32473E79D43A527633232561E6F86536660256891699D175989A6F1A020A9C75C9D5E68274C619D79D91B5C5189F7906CA67297129D88F9E881A3AA83E8AB623E85E8B0EDAE89C892216E9A584B80318A69C7E3269A7A046FA69A8A4B6094004003B,
'This is sample text data for Scootney Books, publisher 9952 in the pubs database. Scootney Books is located in New York City, New York.');

INSERT pub_info
VALUES
  ('9999',
0x474946383961A9002400B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000A90024004004FFF0C949ABBD38EBCDBBFF60F8011A609E67653EA8D48A702CCFF44566689ED67CEFFF23D58E7513B686444A6EA26B126FC8E74AC82421A7ABE5F4594D61B7BBF0D6F562719A68A07ACDC6389925749AFC6EDBEFBCA24D3E96E2FF803D7A1672468131736E494A8B5C848D8633834B916E598B657E4A83905F7D9B7B56986064A09BA2A68D63603A2E717C9487B2B3209CA7AD52594751B4BD80B65D75B799BEC5BFAF7CC6CACB6638852ACC409F901BD33EB6BCCDC1D1CEA9967B23C082C3709662A69FA4A591E7AE84D87A5FA0AB502F43AC5D74EB9367B0624593FA5CB101ED144173E5F4315AE8485B4287FCBE39E446B1624173FEAC59DC2809594623D9C3388A54E4ACD59C642353E2F098E919319530DD61C405C7CBCB9831C5E5A2192C244E983A3FFE1CDA21282CA248ABB18C25336952A389D689E489B0D24483243B66CD8775A315801AA5A60A6B2DAC074E3741D6BBA8902BA687E9A6D1A3B6D6D15C7460C77AA3E3E556D79EBAF4AAAAB2CFCF578671DFDE657598305D51F7BE5E5A25361ED3388EED0A84B2B7535D6072C1D62DB5588BE5CCA5B1BDA377B99E3CBE9EDA31944A951ADF7DB15263A1429B37BB7E429D8EC4D754B87164078F2B87012002003B,
'This is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.

This is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.

This is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.

This is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.');
GO


RAISERROR('Now at the inserts to titles ....', 0, 1);

CREATE TABLE #titles(
	[title_id] NVARCHAR(80) NOT NULL,
	[title] [varchar](80) NOT NULL,
	[type] [char](12) NOT NULL,
	[pub_id] [char](4) NULL,
	[price] [money] NULL,
	[advance] [money] NULL,
	[royalty] [int] NULL,
	[ytd_sales] [int] NULL,
	[notes] [varchar](200) NULL,
	[pubdate] [datetime] NOT NULL)
GO
ALTER TABLE #titles ADD  DEFAULT ('UNDECIDED') FOR [type]
GO

ALTER TABLE #titles ADD  DEFAULT (getdate()) FOR [pubdate]
GO

INSERT into #titles
VALUES
( N'PC8888', 'Secrets of Silicon Valley', 'popular_comp', '1389', 20.0000, 8000.0000, 10, 4095, 
'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', N'1994-06-12T00:00:00' ), 
( N'BU1032', 'The Busy Executive''s Database Guide', 'business    ', '1389', 19.9900, 5000.0000, 10, 4095, 
'An overview of available database systems with emphasis on common business applications. Illustrated.', N'1991-06-12T00:00:00' ), 
( N'PS7777', 'Emotional Security: A New Algorithm', 'psychology  ', '0736', 7.9900, 4000.0000, 10, 3336, 
'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.', N'1991-06-12T00:00:00' ), 
( N'PS3333', 'Prolonged Data Deprivation: Four Case Studies', 'psychology  ', '0736', 19.9900, 2000.0000, 10, 4072,
 'What happens when the data runs dry?  Searching evaluations of information-shortage effects.', N'1991-06-12T00:00:00' ), 
( N'BU1111', 'Cooking with Computers: Surreptitious Balance Sheets', 'business    ', '1389', 11.9500, 5000.0000, 10, 3876, 
'Helpful hints on how to use your electronic resources to the best advantage.', N'1991-06-09T00:00:00' ), 
( N'MC2222', 'Silicon Valley Gastronomic Treats', 'mod_cook    ', '0877', 19.9900, 0.0000, 12, 2032, 
'Favorite recipes for quick, easy, and elegant meals.', N'1991-06-09T00:00:00' ), 
( N'TC7777', 'Sushi, Anyone?', 'trad_cook   ', '0877', 14.9900, 8000.0000, 10, 4095, 
'Detailed instructions on how to make authentic Japanese sushi in your spare time.', N'1991-06-12T00:00:00' ), 
( N'TC4203', 'Fifty Years in Buckingham Palace Kitchens', 'trad_cook   ', '0877', 11.9500, 4000.0000, 14, 15096, 
'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.', N'1991-06-12T00:00:00' ), 
( N'PC1035', 'But Is It User Friendly?', 'popular_comp', '1389', 22.9500, 7000.0000, 16, 8780, 
'A survey of software for the naive user, focusing on the ''friendliness'' of each.', N'1991-06-30T00:00:00' ), 
( N'BU2075', 'You Can Combat Computer Stress!', 'business    ', '0736', 2.9900, 10125.0000, 24, 18722, 
'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.', N'1991-06-30T00:00:00' ), 
( N'PS2091', 'Is Anger the Enemy?', 'psychology  ', '0736', 10.9500, 2275.0000, 12, 2045,
 'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.', N'1991-06-15T00:00:00' ), 
( N'PS2106', 'Life Without Fear', 'psychology  ', '0736', 7.0000, 6000.0000, 10, 111, 
'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.', N'1991-10-05T00:00:00' ), 
( N'MC3021', 'The Gourmet Microwave', 'mod_cook    ', '0877', 2.9900, 15000.0000, 24, 22246,
 'Traditional French gourmet recipes adapted for modern microwave cooking.', N'1991-06-18T00:00:00' ), 
( N'TC3218', 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', 'trad_cook   ', '0877', 20.9500, 7000.0000, 10, 375, 
'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.', N'1991-10-21T00:00:00' ), 
( N'BU7832', 'Straight Talk About Computers', 'business    ', '1389', 19.9900, 5000.0000, 10, 4095, 
'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.', N'1991-06-22T00:00:00' ), 
( N'PS1372', 'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', 'psychology  ', '0877', 21.5900, 7000.0000, 10, 375,
 'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.', N'1991-10-21T00:00:00' )
 
INSERT into #titles (title_id, title, pub_id)
VALUES
  ('MC3026', 'The Psychology of Computer Cooking', '0877');

INSERT into #titles (title_id, title, type, pub_id, notes)
VALUES
  ('PC9999', 'Net Etiquette', 'popular_comp', '1389',
'A must-read for computer conferencing.');

GO

INSERT into titles (title_id, title,  pub_id,
       price, advance, royalty, ytd_sales,
       notes, pubdate)
SELECT #titles.title_id, #titles.title,  #titles.pub_id,
       #titles.price, #titles.advance, #titles.royalty, #titles.ytd_sales,
       #titles.notes, #titles.pubdate FROM #titles

RAISERROR('Now at the inserts to titleauthor ....', 0, 1);
INSERT titleauthor VALUES
( N'172-32-1176', N'PS3333', 1, 100 ), ( N'213-46-8915', N'BU1032', 2, 40 ), 
( N'213-46-8915', N'BU2075', 1, 100 ), ( N'238-95-7766', N'PC1035', 1, 100 ), 
( N'267-41-2394', N'BU1111', 2, 40 ), ( N'267-41-2394', N'TC7777', 2, 30 ), 
( N'274-80-9391', N'BU7832', 1, 100 ), ( N'409-56-7008', N'BU1032', 1, 60 ), 
( N'427-17-2319', N'PC8888', 1, 50 ), ( N'472-27-2349', N'TC7777', 3, 30 ), 
( N'486-29-1786', N'PC9999', 1, 100 ), ( N'486-29-1786', N'PS7777', 1, 100 ), 
( N'648-92-1872', N'TC4203', 1, 100 ), ( N'672-71-3249', N'TC7777', 1, 40 ), 
( N'712-45-1867', N'MC2222', 1, 100 ), ( N'722-51-5454', N'MC3021', 1, 75 ), 
( N'724-80-9391', N'BU1111', 1, 60 ), ( N'724-80-9391', N'PS1372', 2, 25 ), 
( N'756-30-7391', N'PS1372', 1, 75 ), ( N'807-91-6654', N'TC3218', 1, 100 ), 
( N'846-92-7186', N'PC8888', 2, 50 ), ( N'899-46-2035', N'MC3021', 2, 25 ), 
( N'899-46-2035', N'PS2091', 2, 50 ), ( N'998-72-3567', N'PS2091', 1, 50 ), 
( N'998-72-3567', N'PS2106', 1, 100 )

GO

RAISERROR('Now at the inserts to stores ....', 0, 1);

GO

INSERT stores VALUES
( '6380    ', N'Eric the Read Books', N'788 Catamaugus Ave.', N'Seattle', 'WA', '98056' ), 
( '7066    ', N'Barnum''s', N'567 Pasadena Ave.', N'Tustin', 'CA', '92789' ), 
( '7067    ', N'News & Brews', N'577 First St.', N'Los Gatos', 'CA', '96745' ), 
( '7131    ', N'Doc-U-Mat: Quality Laundry and Books', N'24-A Avogadro Way', N'Remulade', 'WA', '98014' ), 
( '7896    ', N'Fricative Bookshop', N'89 Madison St.', N'Fremont', 'CA', '90019' ), 
( '8042    ', N'Bookbeat', N'679 Carson St.', N'Portland', 'OR', '89076' )

GO

RAISERROR('Now at the inserts to sales ....', 0, 1);

GO

INSERT sales VALUES
( '6380    ', N'6871', N'1994-09-14T00:00:00', 5, 'Net 60', N'BU1032' ), 
( '6380    ', N'722a', N'1994-09-13T00:00:00', 3, 'Net 60', N'PS2091' ), 
( '7066    ', N'A2976', N'1993-05-24T00:00:00', 50, 'Net 30', N'PC8888' ), 
( '7066    ', N'QA7442.3', N'1994-09-13T00:00:00', 75, 'ON invoice', N'PS2091' ), 
( '7067    ', N'D4482', N'1994-09-14T00:00:00', 10, 'Net 60', N'PS2091' ), 
( '7067    ', N'P2121', N'1992-06-15T00:00:00', 40, 'Net 30', N'TC3218' ), 
( '7067    ', N'P2121', N'1992-06-15T00:00:00', 20, 'Net 30', N'TC4203' ), 
( '7067    ', N'P2121', N'1992-06-15T00:00:00', 20, 'Net 30', N'TC7777' ), 
( '7131    ', N'N914008', N'1994-09-14T00:00:00', 20, 'Net 30', N'PS2091' ), 
( '7131    ', N'N914014', N'1994-09-14T00:00:00', 25, 'Net 30', N'MC3021' ), 
( '7131    ', N'P3087a', N'1993-05-29T00:00:00', 20, 'Net 60', N'PS1372' ), 
( '7131    ', N'P3087a', N'1993-05-29T00:00:00', 25, 'Net 60', N'PS2106' ), 
( '7131    ', N'P3087a', N'1993-05-29T00:00:00', 15, 'Net 60', N'PS3333' ), 
( '7131    ', N'P3087a', N'1993-05-29T00:00:00', 25, 'Net 60', N'PS7777' ), 
( '7896    ', N'QQ2299', N'1993-10-28T00:00:00', 15, 'Net 60', N'BU7832' ), 
( '7896    ', N'TQ456', N'1993-12-12T00:00:00', 10, 'Net 60', N'MC2222' ), 
( '7896    ', N'X999', N'1993-02-21T00:00:00', 35, 'ON invoice', N'BU2075' ), 
( '8042    ', N'423LL922', N'1994-09-14T00:00:00', 15, 'ON invoice', N'MC3021' ), 
( '8042    ', N'423LL930', N'1994-09-14T00:00:00', 10, 'ON invoice', N'BU1032' ), 
( '8042    ', N'P723', N'1993-03-11T00:00:00', 25, 'Net 30', N'BU1111' ), 
( '8042    ', N'QA879.1', N'1993-05-22T00:00:00', 30, 'Net 30', N'PC1035' )

GO

RAISERROR('Now at the inserts to roysched ....', 0, 1);

GO

INSERT roysched VALUES
( N'BU1032', 0, 5000, 10 ), ( N'BU1032', 5001, 50000, 12 ), ( N'PC1035', 0, 2000, 10 ), 
( N'PC1035', 2001, 3000, 12 ), ( N'PC1035', 3001, 4000, 14 ), ( N'PC1035', 4001, 10000, 16 ), 
( N'PC1035', 10001, 50000, 18 ), ( N'BU2075', 0, 1000, 10 ), ( N'BU2075', 1001, 3000, 12 ), 
( N'BU2075', 3001, 5000, 14 ), ( N'BU2075', 5001, 7000, 16 ), ( N'BU2075', 7001, 10000, 18 ), 
( N'BU2075', 10001, 12000, 20 ), ( N'BU2075', 12001, 14000, 22 ), ( N'BU2075', 14001, 50000, 24 ), 
( N'PS2091', 0, 1000, 10 ), ( N'PS2091', 1001, 5000, 12 ), ( N'PS2091', 5001, 10000, 14 ), 
( N'PS2091', 10001, 50000, 16 ), ( N'PS2106', 0, 2000, 10 ), ( N'PS2106', 2001, 5000, 12 ), 
( N'PS2106', 5001, 10000, 14 ), ( N'PS2106', 10001, 50000, 16 ), ( N'MC3021', 0, 1000, 10 ), 
( N'MC3021', 1001, 2000, 12 ), ( N'MC3021', 2001, 4000, 14 ), ( N'MC3021', 4001, 6000, 16 ), 
( N'MC3021', 6001, 8000, 18 ), ( N'MC3021', 8001, 10000, 20 ), ( N'MC3021', 10001, 12000, 22 ), 
( N'MC3021', 12001, 50000, 24 ), ( N'TC3218', 0, 2000, 10 ), ( N'TC3218', 2001, 4000, 12 ), 
( N'TC3218', 4001, 6000, 14 ), ( N'TC3218', 6001, 8000, 16 ), ( N'TC3218', 8001, 10000, 18 ), 
( N'TC3218', 10001, 12000, 20 ), ( N'TC3218', 12001, 14000, 22 ), ( N'TC3218', 14001, 50000, 24 ), 
( N'PC8888', 0, 5000, 10 ), ( N'PC8888', 5001, 10000, 12 ), ( N'PC8888', 10001, 15000, 14 ), 
( N'PC8888', 15001, 50000, 16 ), ( N'PS7777', 0, 5000, 10 ), ( N'PS7777', 5001, 50000, 12 ), 
( N'PS3333', 0, 5000, 10 ), ( N'PS3333', 5001, 10000, 12 ), ( N'PS3333', 10001, 15000, 14 ), 
( N'PS3333', 15001, 50000, 16 ), ( N'BU1111', 0, 4000, 10 ), ( N'BU1111', 4001, 8000, 12 ), 
( N'BU1111', 8001, 10000, 14 ), ( N'BU1111', 12001, 16000, 16 ), ( N'BU1111', 16001, 20000, 18 ), 
( N'BU1111', 20001, 24000, 20 ), ( N'BU1111', 24001, 28000, 22 ), ( N'BU1111', 28001, 50000, 24 ), 
( N'MC2222', 0, 2000, 10 ), ( N'MC2222', 2001, 4000, 12 ), ( N'MC2222', 4001, 8000, 14 ), 
( N'MC2222', 8001, 12000, 16 ), ( N'MC2222', 12001, 20000, 18 ), ( N'MC2222', 20001, 50000, 20 ), 
( N'TC7777', 0, 5000, 10 ), ( N'TC7777', 5001, 15000, 12 ), ( N'TC7777', 15001, 50000, 14 ), 
( N'TC4203', 0, 2000, 10 ), ( N'TC4203', 2001, 8000, 12 ), ( N'TC4203', 8001, 16000, 14 ), 
( N'TC4203', 16001, 24000, 16 ), ( N'TC4203', 24001, 32000, 18 ), ( N'TC4203', 32001, 40000, 20 ), 
( N'TC4203', 40001, 50000, 22 ), ( N'BU7832', 0, 5000, 10 ), ( N'BU7832', 5001, 10000, 12 ), 
( N'BU7832', 10001, 15000, 14 ), ( N'BU7832', 15001, 20000, 16 ), ( N'BU7832', 20001, 25000, 18 ), 
( N'BU7832', 25001, 30000, 20 ), ( N'BU7832', 30001, 35000, 22 ), ( N'BU7832', 35001, 50000, 24 ), 
( N'PS1372', 0, 10000, 10 ), ( N'PS1372', 10001, 20000, 12 ), ( N'PS1372', 20001, 30000, 14 ), 
( N'PS1372', 30001, 40000, 16 ), ( N'PS1372', 40001, 50000, 18 )
GO

PRINT 'Now at the inserts to discounts ....'

GO

INSERT discounts VALUES
( N'Initial Customer', NULL, NULL, NULL, 10.50 ), 
( N'Volume Discount', NULL, 100, 1000, 6.70 ), 
( N'Customer Discount', '8042    ', NULL, NULL, 5.00 )

GO

PRINT 'Now at the inserts to jobs ....';

GO

INSERT jobs (job_desc, min_lvl, max_lvl)
Values
( 'New Hire - Job not specified', 10, 10 ), 
( 'Chief Executive Officer', 200, 250 ), 
( 'Business Operations Manager', 175, 225 ), 
( 'Chief Financial Officier', 175, 250 ), 
( 'Publisher', 150, 250 ), 
( 'Managing Editor', 140, 225 ), 
( 'Marketing Manager', 120, 200 ), 
( 'Public Relations Manager', 100, 175 ), 
( 'Acquisitions Manager', 75, 175 ), 
(  'Productions Manager', 75, 165 ), 
(  'Operations Manager', 75, 150 ), 
(  'Editor', 25, 100 ), 
(  'Sales Representative', 25, 100 ), 
(  'Designer', 25, 100 )
GO

RAISERROR('Now at the inserts to employee ....', 0, 1);

GO

INSERT employee VALUES
( 'PMA42628M', N'Paolo', 'M', 'Accorti', 13, 35, '0877    ', N'1992-08-27T00:00:00' ), 
( 'PSA89086M', N'Pedro', 'S', 'Afonso', 14, 89, '1389    ', N'1990-12-24T00:00:00' ), 
( 'VPA30890F', N'Victoria', 'P', 'Ashworth', 6, 140, '0877    ', N'1990-09-13T00:00:00' ), 
( 'H-B39728F', N'Helen', ' ', 'Bennett', 12, 35, '0877    ', N'1989-09-21T00:00:00' ), 
( 'L-B31947F', N'Lesley', ' ', 'Brown', 7, 120, '0877    ', N'1991-02-13T00:00:00' ), 
( 'F-C16315M', N'Francisco', ' ', 'Chang', 4, 227, '9952    ', N'1990-11-03T00:00:00' ), 
( 'PTC11962M', N'Philip', 'T', 'Cramer', 2, 215, '9952    ', N'1989-11-11T00:00:00' ), 
( 'A-C71970F', N'Aria', ' ', 'Cruz', 10, 87, '1389    ', N'1991-10-26T00:00:00' ), 
( 'AMD15433F', N'Ann', 'M', 'Devon', 3, 200, '9952    ', N'1991-07-16T00:00:00' ), 
( 'ARD36773F', N'Anabela', 'R', 'Domingues', 8, 100, '0877    ', N'1993-01-27T00:00:00' ), 
( 'PHF38899M', N'Peter', 'H', 'Franken', 10, 75, '0877    ', N'1992-05-17T00:00:00' ), 
( 'PXH22250M', N'Paul', 'X', 'Henriot', 5, 159, '0877    ', N'1993-08-19T00:00:00' ), 
( 'CFH28514M', N'Carlos', 'F', 'Hernadez', 5, 211, '9999    ', N'1989-04-21T00:00:00' ), 
( 'PDI47470M', N'Palle', 'D', 'Ibsen', 7, 195, '0736    ', N'1993-05-09T00:00:00' ), 
( 'KJJ92907F', N'Karla', 'J', 'Jablonski', 9, 170, '9999    ', N'1994-03-11T00:00:00' ), 
( 'KFJ64308F', N'Karin', 'F', 'Josephs', 14, 100, '0736    ', N'1992-10-17T00:00:00' ), 
( 'MGK44605M', N'Matti', 'G', 'Karttunen', 6, 220, '0736    ', N'1994-05-01T00:00:00' ), 
( 'POK93028M', N'Pirkko', 'O', 'Koskitalo', 10, 80, '9999    ', N'1993-11-29T00:00:00' ), 
( 'JYL26161F', N'Janine', 'Y', 'Labrune', 5, 172, '9901    ', N'1991-05-26T00:00:00' ), 
( 'M-L67958F', N'Maria', ' ', 'Larsson', 7, 135, '1389    ', N'1992-03-27T00:00:00' ), 
( 'Y-L77953M', N'Yoshi', ' ', 'Latimer', 12, 32, '1389    ', N'1989-06-11T00:00:00' ), 
( 'LAL21447M', N'Laurence', 'A', 'Lebihan', 5, 175, '0736    ', N'1990-06-03T00:00:00' ), 
( 'ENL44273F', N'Elizabeth', 'N', 'Lincoln', 14, 35, '0877    ', N'1990-07-24T00:00:00' ), 
( 'PCM98509F', N'Patricia', 'C', 'McKenna', 11, 150, '9999    ', N'1989-08-01T00:00:00' ), 
( 'R-M53550M', N'Roland', ' ', 'Mendel', 11, 150, '0736    ', N'1991-09-05T00:00:00' ), 
( 'RBM23061F', N'Rita', 'B', 'Muller', 5, 198, '1622    ', N'1993-10-09T00:00:00' ), 
( 'HAN90777M', N'Helvetius', 'A', 'Nagy', 7, 120, '9999    ', N'1993-03-19T00:00:00' ), 
( 'TPO55093M', N'Timothy', 'P', 'O''Rourke', 13, 100, '0736    ', N'1988-06-19T00:00:00' ), 
( 'SKO22412M', N'Sven', 'K', 'Ottlieb', 5, 150, '1389    ', N'1991-04-05T00:00:00' ), 
( 'MAP77183M', N'Miguel', 'A', 'Paolino', 11, 112, '1389    ', N'1992-12-07T00:00:00' ), 
( 'PSP68661F', N'Paula', 'S', 'Parente', 8, 125, '1389    ', N'1994-01-19T00:00:00' ), 
( 'M-P91209M', N'Manuel', ' ', 'Pereira', 8, 101, '9999    ', N'1989-01-09T00:00:00' ), 
( 'MJP25939M', N'Maria', 'J', 'Pontes', 5, 246, '1756    ', N'1989-03-01T00:00:00' ), 
( 'M-R38834F', N'Martine', ' ', 'Rance', 9, 75, '0877    ', N'1992-02-05T00:00:00' ), 
( 'DWR65030M', N'Diego', 'W', 'Roel', 6, 192, '1389    ', N'1991-12-16T00:00:00' ), 
( 'A-R89858F', N'Annette', ' ', 'Roulet', 6, 152, '9999    ', N'1990-02-21T00:00:00' ), 
( 'MMS49649F', N'Mary', 'M', 'Saveley', 8, 175, '0736    ', N'1993-06-29T00:00:00' ), 
( 'CGS88322F', N'Carine', 'G', 'Schmitt', 13, 64, '1389    ', N'1992-07-07T00:00:00' ), 
( 'MAS70474F', N'Margaret', 'A', 'Smith', 9, 78, '1389    ', N'1988-09-29T00:00:00' ), 
( 'HAS54740M', N'Howard', 'A', 'Snyder', 12, 100, '0736    ', N'1988-11-19T00:00:00' ), 
( 'MFS52347M', N'Martin', 'F', 'Sommer', 10, 165, '0736    ', N'1990-04-13T00:00:00' ), 
( 'GHT50241M', N'Gary', 'H', 'Thomas', 9, 170, '0736    ', N'1988-08-09T00:00:00' ), 
( 'DBT39435M', N'Daniel', 'B', 'Tonini', 11, 75, '0877    ', N'1990-01-01T00:00:00' )
