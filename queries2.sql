-- ### Задание 1. Карты некоторого типа
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

-- 5.1) Датчики со скидкой больше 10
select * from datchiki where id in (
    select c.datchik_id from ceny c
        left join datchiki_promo dp on c.datchik_id = dp.datchik_id
        left join promo p on dp.promo_id = p.id
    where skidka > 10
    );

-- 5.2) Датчики для которых предусмотрены акционые предложения
select * from datchiki d where exists (
    select * from ceny c
        left join datchiki_promo dp on c.datchik_id = dp.datchik_id
        left join promo p on dp.promo_id = p.id
    where d.id = dp.datchik_id
    );

-- 5.3) Датчики цена которых меньше цены всех датчиков со скидкой больше 10
select * from datchiki d
    left join ceny c on d.id = c.datchik_id
where c.cena < ALL (
    select c2.cena from datchiki d2
        left join ceny c2 on c2.datchik_id = d2.id
        left join datchiki_promo dp on d2.id = dp.datchik_id
        left join promo p on dp.promo_id = p.id
    where p.skidka > 10
);

-- 5.4) Датчики цена которых больше любого датчика со скидкой больше 10
select * from datchiki d
    left join ceny c on d.id = c.datchik_id
where c.cena > ANY (
    select c2.cena from datchiki d2
        left join ceny c2 on c2.datchik_id = d2.id
        left join datchiki_promo dp on d2.id = dp.datchik_id
        left join promo p on dp.promo_id = p.id
    where p.skidka > 10
);

-- 5.5) Производители для которых есть датчики со скидкой

select * from proizvoditel p
    where exists (
        select * from datchiki d
            inner join datchiki_promo dp on dp.datchik_id = d.id
            left join promo pr on pr.id = dp.promo_id
        where p.id = d.proizv_id
        );

-- 5.6) Производители для которых есть датчики со скидкой

select * from proizvoditel p
    where id in (
        select d.id from datchiki d
            inner join datchiki_promo dp on dp.datchik_id = d.id
            left join promo pr on pr.id = dp.promo_id
        where p.id = d.proizv_id
        );

-- 5.7) Производители для которых датчики стоят не более 4000

select * from proizvoditel p
    where 4000 >= all (
        select cena from ceny c
            inner join datchiki d on d.id = c.datchik_id
        where d.proizv_id = p.id
        );

-- 5.8) Производители для которых есть датчики ценой не более 4000

select * from proizvoditel p
    where 4000 >= any (
        select cena from ceny c
            inner join datchiki d on d.id = c.datchik_id
        where d.proizv_id = p.id
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
