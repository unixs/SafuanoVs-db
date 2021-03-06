INSERT INTO `devices` VALUES (1,'Intel 123',1,10),(2,'Intel 456',2,20),
                             (3,'Intel 789',3,30),(4,'Broadcom 321',4,40),
                             (5,'D-Link 015',5,50),(6,'D-Link 150',6,60),
                             (7,'3Com 777',7,70),(8,'Zuxel 555',8,80),
                             (9,'Realtek 002',9,90),(10,'Asus 652',10,100),
                             (11,'Asus 256',1,11),(12,'Realtek 200',2,21),
                             (13,'Zuxel 556',3,32),(14,'3Com 778',4,45),
                             (15,'D-Link 051',5,57),(16,'D-Link 510',6,68),
                             (17,'Broadcom 123',7,97);
INSERT INTO `order_items` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
                                 (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),
                                 (11,11,11),(12,12,12),(13,13,13),(14,14,14),
                                 (15,15,15),(16,16,16),(17,1,17),(18,2,1),
                                 (19,3,2),(20,4,3),(21,5,4),(22,6,5),(23,7,6),
                                 (24,8,7),(25,9,8),(26,10,9),(27,11,10),
                                 (28,12,11),(29,13,12),(30,14,13),(31,15,14),
                                 (32,16,15),(33,1,16),(34,2,17);
INSERT INTO `orders` VALUES (1,1),(2,1),(3,2),(4,2),(5,7),(6,7),(7,7),(8,6),
                            (9,3),(10,4),(11,5),(12,8),(13,9),(14,10),(15,7),
                            (16,7);
INSERT INTO `statuses` VALUES (1,'создан'),(2,'оплачен'),(3,'комплектовка'),
                              (4,'готов'),(5,'отправка'),(6,'в пути'),
                              (7,'получен'),(8,'отменён'),(9,'есть изменения'),
                              (10,'возврат');
INSERT INTO `types` VALUES (1,'ethernet 100M',0),(2,'ethernet 10M',0),
                           (3,'ethernet 1000M',0),(4,'bluetooth 4',1),
                           (5,'bluetooth 5',1),(6,'IEEE 802.3av PON',0),
                           (7,'IEEE 800.11g',1),(8,'IEEE 800.11n',1),
                           (9,'IEEE 800.11ac',1);
