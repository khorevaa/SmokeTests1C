﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ОбъектыМетаданных;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОбъектыМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КоллекцияОбъектовМетаданных Из ОбъектыМетаданных Цикл
		Если КоллекцияОбъектовМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(КоллекцияОбъектовМетаданных.Ключ, Ложь);
		Для Каждого ОбъектМетаданных Из КоллекцияОбъектовМетаданных.Значение Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьЧтоЕстьПраваНаЧтениеRLS", 
				НаборТестов.ПараметрыТеста(ОбъектМетаданных.ПолноеИмя), 
				ОбъектМетаданных.Имя);	
		КонецЦикла;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
		
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ОбъектыМетаданных") Тогда
		ОбъектаМетаданных(Настройки);
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ИсключенияИзпроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбъектаМетаданных(Настройки)
	
	ОбъектыМетаданных = Новый Структура;
	
	Для Каждого КоллекцияОбъектовМетаданных Из Настройки[ИмяТеста()].ОбъектыМетаданных Цикл
		
		Если Не КоллекцияМетаданныхДоступнаДляПроверки(КоллекцияОбъектовМетаданных.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		
		Если КоллекцияОбъектовМетаданных.Значение.Найти("*") <> Неопределено Тогда
			МассивОбъектовМетаданных = ВсеОбъектыКоллекцииМетаданных(КоллекцияОбъектовМетаданных.Ключ);
		Иначе
			
			МассивОбъектовМетаданных = Новый Массив;
			Для Каждого ЭлементКоллекцииОбъектовМетаданных Из КоллекцияОбъектовМетаданных.Значение Цикл
				ПолноеИмя = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
								"%1.%2", 
								КоллекцияОбъектовМетаданных.Ключ, 
								ЭлементКоллекцииОбъектовМетаданных);
				СтруктураИмен = Новый Структура;
				СтруктураИмен.Вставить("Имя", ЭлементКоллекцииОбъектовМетаданных); 
				СтруктураИмен.Вставить("ПолноеИмя", ПолноеИмя);
				МассивОбъектовМетаданных.Добавить(СтруктураИмен);
			КонецЦикла;
			
		КонецЕсли;
		
		ОбъектыМетаданных.Вставить(КоллекцияОбъектовМетаданных.Ключ, МассивОбъектовМетаданных);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки[ИмяТеста()].ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧтоЕстьПраваНаЧтениеRLS(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	Право = "Чтение";
	
	Результат = ПроверитьЧтоЕстьПраваНаЧтениеRLS(ПолноеИмяМетаданных, Право, ИсключенияИзПроверок);
	
	Если Результат <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат = "", ТекстСообщения(ПолноеИмяМетаданных, Право, Результат));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЧтоЕстьПраваНаЧтениеRLS(ПолноеИмяМетаданных, Право, ИсключенияИзПроверок)

	Результат = "";
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);	
	СписокПолей = ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ПолноеИмяМетаданных);
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если ИсключенияИзПроверок.Получить(ВРег(Роль.ПолноеИмя())) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
				
		Если Метаданные.ОсновныеРоли.Содержит(Роль) Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьПраво = ПравоДоступа(Право, ОбъектМетаданных, Роль);
		ЕстьRLS = ПараметрыДоступа(Право, ОбъектМетаданных, СписокПолей, Роль).ОграничениеУсловием;
		
		Если ЕстьПраво И Не ЕстьRLS Тогда
			Разделитель = ?(ЗначениеЗаполнено(Результат), Символы.ПС, "");
			Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1%2%3", Результат, Разделитель, Роль.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных, Право, Результат)

	ШаблонСообщения = НСтр("ru = 'Есть роли с правом ""%1"" без RLS на объект ""%2"":%3%4'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
						ШаблонСообщения, 
						Право, 
						ПолноеИмяМетаданных, 
						Символы.ПС, 
						Результат);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция КоллекцияМетаданныхДоступнаДляПроверки(ИмяКоллекции)
	
	КоллекцииОбъектовМетаданных = Новый Массив;
		
	КоллекцииОбъектовМетаданных.Добавить("ПланОбмена");
	КоллекцииОбъектовМетаданных.Добавить("Константа");
	КоллекцииОбъектовМетаданных.Добавить("Документ");
	КоллекцииОбъектовМетаданных.Добавить("Справочник");
	КоллекцииОбъектовМетаданных.Добавить("ЖурналДокументов");
	КоллекцииОбъектовМетаданных.Добавить("Последовательность");
	КоллекцииОбъектовМетаданных.Добавить("ПланВидовХарактеристик");
	КоллекцииОбъектовМетаданных.Добавить("ПланСчетов");
	КоллекцииОбъектовМетаданных.Добавить("ПланВидовРасчета");
	КоллекцииОбъектовМетаданных.Добавить("РегистрСведений");
	КоллекцииОбъектовМетаданных.Добавить("РегистрНакопления");
	КоллекцииОбъектовМетаданных.Добавить("РегистрБухгалтерии");
	КоллекцииОбъектовМетаданных.Добавить("РегистрРасчета");
	КоллекцииОбъектовМетаданных.Добавить("БизнесПроцесс");
	КоллекцииОбъектовМетаданных.Добавить("Задача");
	
	Возврат КоллекцииОбъектовМетаданных.Найти(ИмяКоллекции);

КонецФункции

&НаСервереБезКонтекста
Функция ВсеОбъектыКоллекцииМетаданных(ИмяКоллекции)
	
	Результат = Новый Массив;
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	СоответствиеОбъектовМетаданных = Новый Соответствие;
	СоответствиеОбъектовМетаданных.Вставить("ПланОбмена", "ПланыОбмена");
	СоответствиеОбъектовМетаданных.Вставить("Константа", "Константы");
	СоответствиеОбъектовМетаданных.Вставить("Документ", "Документы");
	СоответствиеОбъектовМетаданных.Вставить("Справочник", "Справочники");
	СоответствиеОбъектовМетаданных.Вставить("ЖурналДокументов", "ЖурналыДокументов");
	СоответствиеОбъектовМетаданных.Вставить("Последовательность", "Последовательности");
	СоответствиеОбъектовМетаданных.Вставить("ПланВидовХарактеристик", "ПланыВидовХарактеристик");
	СоответствиеОбъектовМетаданных.Вставить("ПланСчетов", "ПланыСчетов");
	СоответствиеОбъектовМетаданных.Вставить("ПланВидовРасчета", "ПланыВидовРасчета");
	СоответствиеОбъектовМетаданных.Вставить("РегистрСведений", "РегистрыСведений");
	СоответствиеОбъектовМетаданных.Вставить("РегистрНакопления", "РегистрыНакопления");
	СоответствиеОбъектовМетаданных.Вставить("РегистрБухгалтерии", "РегистрыБухгалтерии");
	СоответствиеОбъектовМетаданных.Вставить("РегистрРасчета", "РегистрыРасчета");
	СоответствиеОбъектовМетаданных.Вставить("БизнесПроцесс", "БизнесПроцессы");
	СоответствиеОбъектовМетаданных.Вставить("Задача", "Задачы");
	
	Для Каждого ОбъектМетаданных Из Метаданные[СоответствиеОбъектовМетаданных.Получить(ИмяКоллекции)] Цикл
		
		ПолноеИмя = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.%2", ИмяКоллекции, ОбъектМетаданных.Имя);
		
		СтруктураИмен = Новый Структура;
		СтруктураИмен.Вставить("Имя", ОбъектМетаданных.Имя); 
		СтруктураИмен.Вставить("ПолноеИмя", ПолноеИмя);
		
		Результат.Добавить(СтруктураИмен);
	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
              									   ПолноеИмя,
                                                   ОбъектИБ = Неопределено,
                                                   ПолучитьМассивИмен = Ложь)
	
	ИмяТипа = Лев(ПолноеИмя, СтрНайти(ПолноеИмя, ".") - 1);
	ИменаКоллекций = ИменаКоллекций(ИмяТипа);
		
	ИменаПолей = Новый Массив;
	Если ОбъектИБ = Неопределено Тогда
		ТипХранилищеЗначения = Тип("ХранилищеЗначения");
	Иначе
		ТипХранилищеЗначения = ОбъектИБ.NewObject("ОписаниеТипов", "ХранилищеЗначения").Типы().Получить(0);
	КонецЕсли;

	Для Каждого ИмяКоллекции Из ИменаКоллекций Цикл
		Если ИмяКоллекции = "ТабличныеЧасти"
		 ИЛИ ИмяКоллекции = "СтандартныеТабличныеЧасти" Тогда
			Для Каждого ТабличнаяЧасть Из ОбъектМетаданных[ИмяКоллекции] Цикл
				ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ТабличнаяЧасть.Имя, ИменаПолей, ОбъектИБ);
				ОбработатьРеквизитыТабличнойЧасти(
					ТипХранилищеЗначения, 
					ОбъектМетаданных, 
					ТабличнаяЧасть, 
					ИмяКоллекции, 
					ИменаПолей, 
					ОбъектИБ);
			КонецЦикла;
		Иначе
			ОбработатьПоляОбъектаМетаданных(
				ИмяТипа, 
				ОбъектМетаданных, 
				ИмяКоллекции, 
				ТипХранилищеЗначения, 
				ИменаПолей, 
				ОбъектИБ);
		КонецЕсли;
	КонецЦикла;
	
	Если ПолучитьМассивИмен Тогда
		Возврат ИменаПолей;
	КонецЕсли;
	
	СписокПолей = "";
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		СписокПолей = СписокПолей + ", " + ИмяПоля;
	КонецЦикла;
	
	Возврат Сред(СписокПолей, 3);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОбработатьРеквизитыТабличнойЧасти(ТипХранилищеЗначения, 
											ОбъектМетаданных, 
											ТабличнаяЧасть, 
											ИмяКоллекции, 
											ИменаПолей, 
											ОбъектИБ)

	Реквизиты = ?(ИмяКоллекции = "ТабличныеЧасти", ТабличнаяЧасть.Реквизиты, ТабличнаяЧасть.СтандартныеРеквизиты);
	
	Для Каждого Поле Из Реквизиты Цикл
		Если Поле.Тип.СодержитТип(ТипХранилищеЗначения) Тогда
			Продолжить;
		КонецЕсли;
		ДобавитьПолеОграниченияДоступаОбъектаМетаданных(
			ОбъектМетаданных, 
			ТабличнаяЧасть.Имя + "." + Поле.Имя, 
			ИменаПолей, 
			ОбъектИБ);
	КонецЦикла;
	Если ИмяКоллекции = "СтандартныеТабличныеЧасти" И ТабличнаяЧасть.Имя = "ВидыСубконто" Тогда
		Для Каждого Поле Из ОбъектМетаданных.ПризнакиУчетаСубконто Цикл
			ДобавитьПолеОграниченияДоступаОбъектаМетаданных(
				ОбъектМетаданных, 
				"ВидыСубконто." + Поле.Имя, 
				ИменаПолей, 
				ОбъектИБ);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьПоляОбъектаМетаданных(ИмяТипа, 
										  ОбъектМетаданных, 
										  ИмяКоллекции, 
										  ТипХранилищеЗначения, 
										  ИменаПолей, 
										  ОбъектИБ)

	Для Каждого Поле Из ОбъектМетаданных[ИмяКоллекции] Цикл
		Если ПропускатьПоле(ИмяТипа, Поле, ИмяКоллекции) Тогда
			Продолжить;
		КонецЕсли;
		Если ИмяКоллекции = "Графы"
		 Или Поле.Тип.СодержитТип(ТипХранилищеЗначения) Тогда
			Продолжить;
		КонецЕсли;
		Если ЭтоБалансовоеПоле(Поле, ИмяКоллекции, ОбъектИБ, Метаданные, ОбъектМетаданных) Тогда
			// Дт
			ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, Поле.Имя + "Дт", ИменаПолей, ОбъектИБ);
			// Кт
			ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, Поле.Имя + "Кт", ИменаПолей, ОбъектИБ);
		Иначе
			ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, Поле.Имя, ИменаПолей, ОбъектИБ);
		КонецЕсли;
	КонецЦикла;   

КонецПроцедуры

&НаСервереБезКонтекста
Функция ИменаКоллекций(ИмяТипа)

	ИменаТипов = Новый Массив;
	ИменаТипов.Добавить("Справочник");
	ИменаТипов.Добавить("Документ");
	ИменаТипов.Добавить("ПланВидовХарактеристик");
	ИменаТипов.Добавить("БизнесПроцесс");
	
	ИменаТиповРегистров = Новый Массив;
	ИменаТиповРегистров.Добавить("РегистрСведений");
	ИменаТиповРегистров.Добавить("РегистрНакопления");
	ИменаТиповРегистров.Добавить("РегистрБухгалтерии");
	ИменаТиповРегистров.Добавить("РегистрРасчета");
		
	ИменаКоллекций = Новый Массив;
		
	Если ИменаТипов.Найти(ИмяТипа) <> Неопределено Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");		
	ИначеЕсли ИмяТипа = "ЖурналДокументов" Тогда
		ИменаКоллекций.Добавить("Графы");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");		
	ИначеЕсли ИмяТипа = "ПланСчетов" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("ПризнакиУчета");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		ИменаКоллекций.Добавить("СтандартныеТабличныеЧасти");	
	ИначеЕсли ИмяТипа = "ПланВидовРасчета" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		ИменаКоллекций.Добавить("СтандартныеТабличныеЧасти");		
	ИначеЕсли ИменаТиповРегистров.Найти(ИмяТипа) <> Неопределено Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");		
	ИначеЕсли ИмяТипа = "Задача" Тогда
		ИменаКоллекций.Добавить("РеквизитыАдресации");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");		
	Иначе
		ИменаКоллекций.Добавить("");
	КонецЕсли;
	
	Возврат ИменаКоллекций;

КонецФункции

&НаСервереБезКонтекста
Функция ПропускатьПоле(ИмяТипа, Поле, ИмяКоллекции)

	Возврат ИмяТипа = "ЖурналДокументов"       И Поле.Имя = "Тип"
		ИЛИ ИмяТипа = "ПланВидовХарактеристик" И Поле.Имя = "ТипЗначения"
		ИЛИ ИмяТипа = "ПланСчетов"             И Поле.Имя = "Вид"
		ИЛИ ИмяТипа = "РегистрНакопления"      И Поле.Имя = "ВидДвижения"
		ИЛИ ИмяТипа = "РегистрБухгалтерии"     И ИмяКоллекции = "СтандартныеРеквизиты" И СтрНайти(Поле.Имя, "Субконто") > 0;

КонецФункции 
	
&НаСервереБезКонтекста
Функция ЭтоБалансовоеПоле(Поле, ИмяКоллекции, ОбъектИБ, Метаданные, ОбъектМетаданных)

	мОбъектМетаданных = ?(ОбъектИБ = Неопределено, Метаданные, ОбъектИБ.Метаданные);
	ЭтоРегистраБухгалтерии = мОбъектМетаданных.РегистрыБухгалтерии.Содержит(ОбъектМетаданных);
	
	Возврат (ИмяКоллекции = "Измерения" ИЛИ ИмяКоллекции = "Ресурсы") И ЭтоРегистраБухгалтерии И НЕ Поле.Балансовый;
		
КонецФункции
			   
&НаСервереБезКонтекста
Процедура ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
                                                          ИмяПоля,
                                                          ИменаПолей,
                                                          ОбъектИБ)
	
	Попытка
		Если ОбъектИБ = Неопределено Тогда
			ПараметрыДоступа("Чтение", ОбъектМетаданных, ИмяПоля, Метаданные.Роли.ПолныеПрава);
		Иначе
			ОбъектИБ.ПараметрыДоступа(
				"Чтение",
				ОбъектМетаданных,
				ИмяПоля,
				ОбъектИБ.Метаданные.Роли.ПолныеПрава);
		КонецЕсли;
		ПараметрыДоступаМожноПолучить = Истина;
	Исключение
		ПараметрыДоступаМожноПолучить = Ложь;
	КонецПопытки;
	
	Если ПараметрыДоступаМожноПолучить Тогда
		ИменаПолей.Добавить(ИмяПоля);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 

&НаСервере
Функция ИмяТеста()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Истина;
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Параметры") 
		И Настройки.Параметры.Свойство(ИмяТеста()) Тогда
		ВыполнятьТест = Настройки.Параметры[ИмяТеста()];	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти