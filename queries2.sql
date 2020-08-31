-- ### Задание 1. Устройства некоторого типа
select * from devices where type_id = 2;


-- ### Задание 2. Оплаченные заказы
select * from orders o, statuses s
    where o.status = s.id
      and s.name = 'оплачен';


-- ### Задание 3. Расширенный запрос заказов
select * from orders o, order_items oi, devices d
    where d.id = oi.device_id
        and oi.order_id = o.id
        and o.status = 2;


-- ### Задание 4
select * from devices d, devices d2;


-- ### Задание 5

-- 5.1) Устройства для которых есть заказы
select * from devices where id in (
    select oi.device_id from orders o
        left join order_items oi on o.id = oi.order_id
    );

-- 5.2) Устройства для которых существует отменённый заказ
select * from devices d where exists (
    select oi.device_id from orders o
        left join order_items oi on o.id = oi.order_id
    where d.id = oi.device_id and o.status = 8
    );

-- 5.3) Устройства цена которых меньше всех устройств в полученных заказах
select * from devices d where cost < all (
    select cost from devices d2
        left join order_items oi on d2.id = oi.device_id
        left join orders o on o.id = oi.order_id
    where o.status = 7
);

-- 5.4) Устройства цена которых больше любого устройства в полученных заказах
select * from devices d where cost > any (
    select cost from devices d2
        left join order_items oi on d2.id = oi.device_id
        left join orders o on o.id = oi.order_id
    where o.status = 7
);

-- 5.5) Устройства для которых существует отменённый заказ
select * from devices d where exists (
    select oi.device_id from orders o
        left join order_items oi on o.id = oi.order_id
    where d.id = oi.device_id and o.status = 8
    );

-- 5.6) Устройства для которых есть врзвращённые заказы
select * from devices where id in (
    select oi.device_id from orders o
        left join order_items oi on o.id = oi.order_id
    where o.status = 10
    );

-- 5.7) Устройства, которые стоят не более 40

select * from devices d
    where 40 >= all (
        select cost from devices d2
            left join types t on d2.type_id = t.id
        where d.type_id = d2.type_id
        );

-- 5.8) Типы устройств для которых есть устройства ценой не более 40

select * from types t
    where 40 >= any (
        select cost from devices d
            inner join types t2 on d.type_id = t2.id
        where t.id = t2.id
        );


-- ### Задание 6

-- 6.1) Устройства двух избранных типов
select * from devices where type_id = 2
union
select * from devices where type_id = 3;

-- 6.2) Датчики производителя фигурирующего во всех группах
select * from devices where type_id in (2, 3)
intersect
select * from devices where type_id in (2);

-- 6.3) Датчики неупомянутого хотя бы в одной группе производителя
select * from devices where type_id in (2, 3)
except
select * from devices where type_id in (2);


-- ### Задание 7

create view testview as
    select o.id, oi.device_id, d.cost from orders o
        left join order_items oi on o.id = oi.order_id
        left join devices d on oi.device_id = d.id;

select * from testview where cost > 50;

-- drop view testview;

-- ### Задание 8

-- 8.1) Датчики с ценами
select * from devices d
    join types t on d.type_id = t.id;

-- 8.2)
select * from devices d
    cross join devices d2;

-- 8.4) Устройства с типами
select * from devices d
    left outer join types t on d.type_id = t.id;

-- 8.5) Журнал изменения статуса заказов
select * from orders
    natural left outer join status_changes;

-- 8.6) Заказы с изменением статуса
select * from devices
    natural right outer join status_changes;

-- ### Задание 9, 10, 11 Количество заказов каждого устройсва

select count(o.id) as cnt, device_id, name from orders o
    left join order_items oi on o.id = oi.order_id
    left join devices d on d.id = oi.device_id
group by device_id
having cnt > 2;

-- ### Задание 12

-- 12.1) Заказы включающие некоторые устройства
select * from orders o where id in (
    select o2.id from orders o2
        left join order_items oi on o2.id = oi.order_id
    where oi.device_id = 3 and oi.order_id = o.id);

-- 12.2) Заказы изключающие некоторые устройства
select * from orders o where id not in (
    select o2.id from orders o2
        left join order_items oi on o2.id = oi.order_id
    where oi.device_id = 3 and oi.order_id = o.id);


-- ## Триггеры


-- ### Задание 13

create trigger if not exists zadanie_13
    before update on types
for each row
    update devices set type_id = NEW.id where type_id = OLD.id;


-- ### Задание 14

delimiter //
create trigger if not exists zadanie_14
    before update on orders
for each row
begin
    if OLD.status != NEW.status then
        insert into status_changes (id, old_status, new_status) values (OLD.id, OLD.status, NEW.status);
    end if;
end; //
delimiter ;
