SELECT * FROM sql_cx_live.laptop;

SELECT * FROM laptop;

CREATE TABLE laptop_backup LIKE laptop;

INSERT INTO laptop_backup
SELECT * FROM laptop;

SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sql_cx_live'
AND TABLE_NAME = 'laptop';

SELECT * FROM laptop;

ALTER TABLE laptop DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptop;

DELETE FROM laptops
WHERE `index` IN (SELECT `index` FROM laptop
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL);

ALTER TABLE laptop MODIFY COLUMN Inches DECIMAL(10,1);

SELECT * FROM laptop;

UPDATE laptop 
SET Ram = REPLACE(Ram,'GB','') ;

SELECT * FROM laptop;

ALTER TABLE laptop MODIFY COLUMN Ram INTEGER;

SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sql_cx_live'
AND TABLE_NAME = 'laptops';

UPDATE laptop l1
SET Weight = REPLACE(Weight,'kg','');
           
SELECT * FROM laptop;

UPDATE laptop
SET Price =round(price);
            
ALTER TABLE laptop MODIFY COLUMN Price INTEGER;

SELECT DISTINCT OpSys FROM laptop;

-- mac
-- windows
-- linux
-- no os
-- Android chrome(others)

SELECT OpSys,
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM laptop;

UPDATE laptop
SET OpSys = 
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END;

SELECT * FROM laptop;

ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

SELECT * FROM laptop;

update laptop set gpu_brand= substring_index(gpu,' ',1);
update laptop set gpu_name=replace(gpu,gpu_brand,'') ;
SELECT * FROM laptop;

ALTER TABLE laptop DROP COLUMN Gpu;

SELECT * FROM laptop;

ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

SELECT * FROM laptop;

update laptop set cpu_brand=substring_index(cpu,' ',1) ;

-- Sirf valid CPUs update karo
UPDATE laptop
SET cpu_speed = REPLACE(SUBSTRING_INDEX(cpu, ' ', -1), 'GHz', '')
WHERE cpu LIKE '%GHz%';

-- Check karo
SELECT DISTINCT cpu_speed FROM laptop;

-- Column ko FLOAT me convert karo
ALTER TABLE laptop MODIFY COLUMN cpu_speed FLOAT;

update laptop
set cpu_name=substring_index(substring_index(cpu,' ',3),' ',-2) ;
                    
SELECT * FROM laptop;

ALTER TABLE laptop DROP COLUMN Cpu;

SELECT ScreenResolution,
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1)
FROM laptop;

ALTER TABLE laptop
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

SELECT * FROM laptop;

UPDATE laptop
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1);



ALTER TABLE laptop
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

SELECT ScreenResolution LIKE '%Touch%' FROM laptop;

UPDATE laptop
SET touchscreen = ScreenResolution LIKE '%Touch%';

SELECT * FROM laptop;

ALTER TABLE laptop
DROP COLUMN ScreenResolution;

SELECT * FROM laptop;

SELECT cpu_name,
SUBSTRING_INDEX(TRIM(cpu_name),' ',2)
FROM laptop;

UPDATE laptop
SET cpu_name = SUBSTRING_INDEX(TRIM(cpu_name),' ',2);

SELECT DISTINCT cpu_name FROM laptop;

SELECT Memory FROM laptop;

ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

SELECT Memory,
CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END AS 'memory_type'
FROM laptop;

UPDATE laptop
SET memory_type = CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END;

SELECT Memory,
REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END
FROM laptop;

UPDATE laptop
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;

SELECT 
primary_storage,
CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage,
CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END
FROM laptop;

UPDATE laptop
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

SELECT * FROM laptop;

ALTER TABLE laptop DROP COLUMN gpu_name;

SELECT * FROM laptop;


## EDA

USE sql_cx_live;

SELECT * FROM laptop;

-- head, tail and sample
SELECT * FROM laptop
ORDER BY `index` LIMIT 5;

SELECT * FROM laptop
ORDER BY `index` DESC LIMIT 5;

SELECT * FROM laptop
ORDER BY rand() LIMIT 5;

-- univariate analysis
   -- for numerical cols
set @row=0;    
  
select 
  (select count(price) from laptop) as count_price,
  (select min(price) from laptop) as min_price,
  (select max(price) from laptop) as max_price,
  (select avg(price) from laptop) as avg_price,
  (select std(price) from laptop) as std_price,
  avg(case when rownum = q1_row then price end) as Q1,
  avg(case when rownum = q2_row then price end) as Median,
  avg(case when rownum = q3_row then price end) as Q3
from (
 
  select price, @row:=@row+1 as rownum
  from laptop
  order by price
) as ordered
join (
  select 
    floor(count(*) * 0.25) as q1_row,
    floor(count(*) * 0.5) as q2_row,
    floor(count(*) * 0.75) as q3_row
  from laptop
) as percentiles;
-- missing value
select count(price) from laptop where price is null;

-- outliers
set @minimum=32448-1.5*(79813-32448);
set @maximum=79813+1.5*(79813-32448);

delete from laptop
where price in (
  select * from (
    select price from laptop
    where price < @minimum or price > @maximum
  ) as outliers
);

select * from laptop;
-- histogram
SELECT
    CASE
        WHEN Price BETWEEN 0 AND 25000 THEN '0-25k'
        WHEN price BETWEEN 25001 AND 50000 THEN '25k-50k'
        WHEN price BETWEEN 50001 AND 75000 THEN '50k-75k'
        WHEN Price BETWEEN 75001 AND 100000 THEN '75k-100k'
        ELSE '>100k'
    END AS bucket,
    COUNT(*) AS count_laptop,
    AVG(price) AS avg_price
FROM laptop
GROUP BY bucket
ORDER BY count_laptop DESC;


-- categorical cols
select * from laptop;
select company, count(company) from laptop
group by company order by count(company) desc;

-- bivariate analysis
select corr(price, weight) from laptop;

select
  (
    avg(price * weight) - avg(price) * avg(weight)
  ) /
  (std(price) * std(weight)) as correlation
from laptop
where price is not null and weight is not null;

select * from laptop;

-- categorical and numerical
select company,min(price) as min_price, max(price) as max_price,
std(price) as std_price,avg(price) as avg_price from laptop
group by company;

set sql_safe_updates=0;
--  missing value treatment
#there are no missing values, lets make some of them
update laptop set price=null  where `index` in (7,869,1148);
-- replace with mean
update laptop
set price = (
  select avg_price from (
    select round(avg(price)) as avg_price from laptop
  ) as temp
)
where price is null;

update laptop l1
join (
  select company, avg(price) as avg_price
  from laptop
  where price is not null
  group by company
) as l2
on l1.company = l2.company
set l1.price = l2.avg_price
where l1.price is null;


select * from laptop;