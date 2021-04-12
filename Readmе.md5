Пример функций и модуля создания пользователей в домене и на почтовике Яндекс.

Вложены файлы:
* func_GeneratePass - Функция генерации пароля. Умеет генерировать пароль с буквами, цифрами, символами. Вместе и по отдельности
    Описание работы - внутри самой функции. 

* Func_Get-Translit - Функция перевода с кириллицы на латиницу. 
    Как пользоваться - описано внутри функции. 

* Func_New-EmailYandex - Функция создания Email под управлением yandex connect 
    Имеет 2 режима работы - массовое создание (из CSV) и одиночное. Подробности в описании 

* Func_New-User - Функция создания пользователя домена. Инициализирует все остальные функции и принимает данные из CSV и вбитые вручную
    Подробности в хелпе функции 

* Func-CreateADUser.psm1  - модуль для встраивания в powershell 

Как встроить модуль:
    1. Создать каталог с именем модуля по пути  $env:PSModulePath 
    2. Скопировать туда модуль 
    3. Так же вложить файл в корень $env:PSModulePath  (название каталога и модуля должны быть идентичными)


Как работать с модулем:
    Примеры:
        1. New-User -SurName 'apitest' -FirstName 'test' -StatusPassword RandomPassword -WorkLine OneUser -Position "Testing Specialist" -Token "Paste_Youre_Token" 
        Создадим нового пользователя с фамилией apitest, именем test, сгенерируем пароль, зададим режим работы одиночного пользователя, Введем должность и токен API yandex.connect
        Пароль генериуется из 12 знаком с буквами и цифрами. - Если требуются еще спец сиволы, поменяй в модуле.

        $Password = GeneratePass -long 12 -WorkLine OnlyLetter+Number 
        на 
        $Password = GeneratePass -long 12 -WorkLine AllSymbols

        2. New-User -WorkLine MassUser -Password "P@ssw0rd" -PathFile C:\temp\massuser.csv -Token "Paste_Youre_Token"
        Создадим пользователя их CSV с предустановленным паролем, CSV лежит в C:\temp\massuser.csv, вводим токен yandex.connect


Описания функций:
    func_GeneratePass:
        .SYNOPSIS
        Генерирует случайные пароли.  

        .DESCRIPTION
        Функция позволяет генерировать случайные символы в зависимости от выбранной workline 

        .PARAMETER -long 
        Формирует максимальное кол-во символов 

        .PARAMETER -WorkLine
        Применяется для выбора режима генерации. Есть 5 режимов:
        AllSymbols = Буквы + Цифры + Спец.Символы
        OnlyLetter = только Буквы
        OnlyLetter+Number = только Буквы и Цифры
        OnlyLetter+Symbols = только Буквы и Спец.Символы
        OnlyNumber = только Цифры 
     
        .EXAMPLE
        GeneratePass -long 12 -WorkLine AllSymbols
        Получаем пароль в котором присутствуют как спец символы, так и цифры с буквами


    Func_Get-Translit
        .SYNOPSIS
        Транслитируем кирриллицу в латинницу.  

        .DESCRIPTION
        Функция позволяет переводить кириллицу в латиницу на основе хэш таблицы 

        .PARAMETER -TranslateText 
        Принимает string - вводим текст для транслитерации 
         
        .EXAMPLE
        Get-Translit -TranslateText Иванов.И
        Получаем перебранный на латинице текст ivanov.i  

        .NOTES
        пример взят отсюда - https://windowsnotes.ru/powershell-2/ispolzovanie-transliteracii-v-powershell-pri-sozdanii-polzovatelej/
        и немного переделан под себя 


    Func_New-EmailYandex
       .SYNOPSIS
        Создает почтовый ящик или несколько почтовых ящиков.  

        .DESCRIPTION
        Функция позволяет работать с API Яндекс Коннекта для создания ящика
        Или ящиков. Функция может принимать значения Surname,Nickname,Position (должность) и department 

        .PARAMETER -NickName
        Принимает string - вводим желаемый логин пользователя 

        .PARAMETER -SurName
        Принимает string - фамилию пользователя 

        .PARAMETER -FirstName
        Принимает string - имя пользователя 

        .PARAMETER -Department
        Принимает int - отдел (у яндекс коннекта может быть несколько отделов
        Требуется ввести ID требующегося отдела. По стандарту используется общий (id = 1)) 

        .PARAMETER -Password
        Принимает string - пароль пользователя 

        .PARAMETER -WorkLine
        Принимает string - Флаг работы функции (делаем массовое создание из csv или создаем одиночный ящик)
        С помощью tab - можно переключать флаг 
        Флага 2 -   'OneUser' - создает одиночного пользователя.
                    'MassUser' - массовое создание из файла csv 
           Пример csv файла:
               (
               i.ivanov;Иванов;Иван;Кредитный специалист
               p.petrov;Петров;Петр;Кредитный специалист
               )
           Headers  - NickName,SurName,FirstName,Position

        .PARAMETER -PathFile
        Принимает string - вводим месторасположение и имя файла 
        Пример: C:\temp\massemail.csv 

        .PARAMETER -Token
        Принимает string - вводим токен, или вводим нужный токен в функцию напрямую 
        (в поле [string]$Token = "Paste_Youre_Token" - вместо Paste_Youre_Token)
         
        .EXAMPLE
        New-EmailYandex -NickName 'apitest' -SurName 'test' -FirstName 'api' -WorkLine OneUser -Position "Testing Specialist" -Password "P@ssw0rd" -Token "Paste_Youre_Token" -department 1
        Создаем одиночный почтовый ящик из функции с данными пользователя (логин, фамилия, имя, тип создания - одиночный пользователь, должность, пароль, токен)

        .EXAMPLE
        New-EmailYandex -WorkLine MassUser -Password "P@ssw0rd" -PathFile C:\temp\massemail.csv -Token "Paste_Youre_Token"
        Делаем массовое создание пользователей c паролем P@ssw0rd из csv файла C:\temp\massemail.csv с токеном "Paste_Youre_Token". 
            Пример csv файла:
               (
               i.ivanov;Иванов;Иван;Кредитный специалист
               p.petrov;Петров;Петр;Кредитный специалист
               )
            Headers  - NickName,SurName,FirstName,Position


    Func_New-User
        .SYNOPSIS
        Создает пользователя в AD, генерирует ему пароль, создает логин и почту.  

        .DESCRIPTION
        Функция вызывает еще ряд вышеобозначенных функций для генерации пароля, логина и создания почтового ящика
        В функцию встроен флаг Token для создания почтового ящика для нового пользователя 
        Логин пользователем не вносится, а береться первый символ имени + . + фамилия  
        Переводится функцией  Get-Translit  и вносится в переменную Login
        GeneratePass - генерирует пароль пользователя из 12 символов (Буквы и цифры)
        New-EmailYandex - создает пользователя в яндекс почте (нужен токен)

        .PARAMETER -SurName
        Принимает string - фамилию пользователя 

        .PARAMETER -FirstName
        Принимает string - имя пользователя 

        .PARAMETER -Position
        Принимает string - должность сотрудника 
    
        .PARAMETER -Password
        Принимает string - пароль пользователя (либо вводится вручную либо генерируется, в зависимости от флага StatusPassword)

        .PARAMETER -EmailDomain
        Принимает string в качестве почтового домена 
        прим. @Youre_domain.com

        .PARAMETER -WorkLine
        Принимает string - Флаг работы функции (делаем массовое создание из csv или создаем одиночного пользователя)
        С помощью tab - можно переключать флаг 
        Флага 2 -   'OneUser' - создает одиночного пользователя.
                    'MassUser' - массовое создание из файла csv 
            Пример csv файла:
               (
               Иванов;Иван;Кредитный специалист;Наименование_Филиала
               )
           Headers  - SurName,FirstName,Position,OP

        .PARAMETER -PathFile
        Принимает string - вводим месторасположение и имя файла 
        Пример: C:\temp\massuser.csv 
         
        .EXAMPLE
        New-User -SurName 'apitest' -FirstName 'test' -StatusPassword RandomPassword -WorkLine OneUser -Position "Testing Specialist" -Token "Paste_Youre_Token" 
        Создаем одного пользователя из функции с данными (фамилия, имя, тип создания - одиночный пользователь, должность, пароль (генерируемый), токен от учетной записи администратора почты)

        .EXAMPLE
        New-User -WorkLine MassUser -Password "P@ssw0rd" -PathFile C:\temp\massuser.csv -Token "Paste_Youre_Token"
        Делаем массовое создание пользователей c паролем P@ssw0rd из csv файла C:\temp\massuser.csv с токеном "Paste_Youre_Token". 
            Пример csv файла:
               (
               Иванов;Иван;Кредитный специалист;Наименование_Филиала
               Петров;Петр;Кредитный специалист;Наименование_Филиала
               )
            Headers  - SurName,FirstName,Position,OP