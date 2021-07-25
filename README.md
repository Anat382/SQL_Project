# SQL_Project

## Проект созданного хранилища

## Проект направлен на разработку хранилища данных под бизнес-потребности предприятия. У предприятия есть CRM система, в данном проекте создана имитация передача данных в хранилище из *(CRM -- БД StageLevel2021 -- БД DataBase2021 -- БД DWH)*

## БП предприятия:
- получение заявок из веб сервисов (источники привлечения клиентов)
- обработка заявок ОП и заключение договора на оказание юридических услуг


### Цели проекта:
- Разработать аналитичикую отчетность и BI мониторинг с целью принятия управленченских решений

### Задачи проекта:
- Разработать БД для загрузки исходных данных, ELT
- Разработать БД и ETL
- Разработка DWH и витрин
- Разработать куб и создать отчет в MS Excel

## Созданы 3 базы данных
- StageLevel2021 (озеро данных)
- DataBase2021 (stage)
- DWH_2021 (prodaction)

### [**StageLevel2021_dacpac** - DataBase](https://github.com/Anat382/SQL_Project/tree/master/StageLevel2021_dacpac). 
- харанение исходных данных

### [**DataBase2021_dacpac** - DataBase](https://github.com/Anat382/SQL_Project/tree/master/DataBase2021_dacpac). 
- Обработанные данные, тип cистемы - OLTP, нормализация приведена к 3F, методы - хранимые процедуры

### [**DWH_2021_dacpac** - DataBase](https://github.com/Anat382/SQL_Project/tree/master/DWH2021_dacpac). 
- Витрины данных, тип cистемы - OLAP, денормализация, метод получения данных в БД - SSIS

### [**DWH_2021_DML** - SSIS](https://github.com/Anat382/SQL_Project/tree/master/DWH_2021_DML)
- настроенный ETL процесс из DataBase2021 в DWH_2021

### [**CUB** - SSAS](https://github.com/Anat382/SQL_Project/tree/master/CUB)
- Куб, тип модели - многомерная
- Отчетность построенная в MS Excel

## ***Созданные объекты в хранилище данных***

**JOB**
- Сриншот созданных задач в планировщике [*job.png*](https://github.com/Anat382/SQL_Project/blob/master/CreatedJob.png).

**DB MASTER**
- Хранимая процедура для обслуживания индексов [*uspCleanUP_index*](https://github.com/Anat382/SQL_Project/blob/master/MasterDacPac/MasterDacPac/dbo/Stored%20Procedures/uspCleanUP_index.sql).

**DB DWH2021**
- Схема базы данных DWH2021 [*СхемаБД*](https://github.com/Anat382/SQL_Project/blob/master/DWH2021_dacpac/Схема%20БД%20DWH2021.png).
- Хранимая процедура для создания таблиц(ручная) [*uspCreateTableDWH2021*](https://github.com/Anat382/SQL_Project/blob/master/DWH2021_dacpac/DWH2021_dacpac/dbo/Stored%20Procedures/uspCreateTableDWH2021.sql).
- Пользовательская скалярная функция для получения списка полей в таблице [*ufnString_agg*](https://github.com/Anat382/SQL_Project/blob/master/DWH2021_dacpac/DWH2021_dacpac/dbo/Functions/ufnString_agg.sql).

**DB DataBase2021**
- Схема базы данных DWH2021 [*СхемаБД*](https://github.com/Anat382/SQL_Project/blob/master/DataBase2021_dacpac/Схема%20БД%20DataBase2021.png).
- Хранимая процедура для генерации и обработки исходных данных полученные из БД StageLevel2021 (ручная) [*uspCreateDataBase2021*](https://github.com/Anat382/SQL_Project/blob/master/DataBase2021_dacpac/DataBase2021_dacpac/dbo/Stored%20Procedures/uspCreateDataBase2021.sql).
- Хранимая процедура для обноовлении таблиц  добалением записей из исходных данных  из БД StageLevel2021 (job)  [*uspUdateDataBase2021*](https://github.com/Anat382/SQL_Project/blob/master/DataBase2021_dacpac/DataBase2021_dacpac/dbo/Stored%20Procedures/uspUdateDataBase2021.sql).

**SSIS для DWH**
- Скрин интеграционный проекта для передачи данных из DataBase2021 [*SSIS_DWH*](https://github.com/Anat382/SQL_Project/blob/master/DWH_2021_DML/SSIS%20DWH.png).

**CUB**
- Схема многомерной модели куба [*Схема*](https://github.com/Anat382/SQL_Project/blob/master/CUB/Схема%20звезда%20Cub.png).
- Ааналитический отчёт по продажам [*Report*](https://github.com/Anat382/SQL_Project/blob/master/CUB/v1_Cub_Аналитика%20по%20продажам.xlsx).
- Скриншот отчёта [*Report.png*](https://github.com/Anat382/SQL_Project/blob/master/CUB/Скрин%20отчёта%20в%20Excel%20(подключение%20к%20cub).png).








`

