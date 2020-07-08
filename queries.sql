-- # Запросы

-- ## Вставка данных

-- ### Добавляем новый заказ и его товары
start transaction;
insert into orders (status) value (1);
select @o := last_insert_id();
insert into order_items (order_id, device_id) values (@o, 2), (@o, 4), (@o, 7);
commit;

-- ## Обновление данных

-- ### Изменяем статус заказа
update orders set status = 2 where id = 15;

-- Удаление данных

-- ### Удаляем товар из заказа
delete from order_items where id = 1056;

-- ## Выборка данных

-- ### Все интерфейсы
select * from devices;

-- ### Все безпроводные устройства
select * from devices d
    left join types t on d.type_id = t.id
where t.wireless = true;

-- ### Все безпроводные устройства похожие на 3Com
select * from devices d
    left join types t on d.type_id = t.id
where t.wireless = true and d.name LIKE '%3Com%';

-- ### Количество проданных (оплаченных и не возвращённых) интерфейсов дороже 40
select count(d.id) as result from devices d
    left join types t on d.type_id = t.id
    left join order_items oi on d.id = oi.device_id
    left join orders o on oi.order_id = o.id
where t.wireless = false
    and d.cost > 40
    and o.status between 2 and 7



