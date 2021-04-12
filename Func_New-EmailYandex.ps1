
function New-EmailYandex {
    <#
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

   .NOTES
    Author: @Chentsov_VS
   #>
   param (
       [string]$NickName = "",
       [string]$SurName = "", 
       [string]$FirstName = "",
       [int]$Department = 1,
       [string]$Password = "P@ssw0rd",
       [string]$Position = "",
       [Parameter(Mandatory = $true)]
       [ValidateSet(
           'OneUser', 
           'MassUser')]
       $WorkLine,
       $PathFile = "",
       [string]$Token = "Paste_Youre_Token"
   )
   
   # формируем стандартные ссылки + заголовки с телом запроса
   $ApiURL = 'https://api.directory.yandex.net'
   $ApiUser = '/v6/users/'
   $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
   $Headers.Add("Authorization", "OAuth $Token")
   $WorkURL = "$ApiURL" + "$ApiUser" 
   switch ($WorkLine) {

       # Создание одиночного пользователя в яндекс коннект 
       OneUser { 
           $body = "{
               `"department_id`": $Department,
               `"password`": `"$Password`",
               `"nickname`": `"$NickName`",
               `"position`": `"$Position`",
               `"name`": {
                         `"first`": `"$FirstName`",
                         `"last`": `"$SurName`"
                        }
               `n}"
           
               # отправляем пост запрос с данными для регистрации пользователя 
           $Response = Invoke-WebRequest -Uri $WorkURL -Method Post -Headers $Headers -Body $Body -ContentType "application/json;charset=utf-8" 
       }

       # Массовое создание пользователей через csv
       MassUser {
           $AllData = Import-Csv -Path $PathFile -Delimiter "," -Encoding UTF8 -Header NickName,SurName,FirstName,Position
               foreach ($Data in $AllData) {
                   [string]$NickNameData = $Data.NickName
                   [string]$SurNameData = $Data.SurName
                   [string]$FirstNameData = $Data.FirstName
                   [string]$Position = $Data.position
                   [int]$Department = $Department
                   
                   $Body = "{
                       `"department_id`": $Department,
                       `"password`": `"$Password`",
                       `"nickname`": `"$NickNameData`",
                       `"position`": `"$Position`",
                       `"name`": {
                           `"first`": `"$FirstNameData`",
                           `"last`": `"$SurNameData`"
                       }
                   }"
                   
                   # отправляем пост запрос с данными для регистрации пользователей 
                   $Response = Invoke-RestMethod -Uri $WorkURL -Method Post -Headers $Headers -Body $Body -ContentType "application/json;charset=utf-8"
               }
           }
       
   }
   return $Response
}
