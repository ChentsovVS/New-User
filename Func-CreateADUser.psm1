function GeneratePass {
    <#
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

    .NOTES 
    Author: @Chentsov_VS
#>    
    param (
    $long=12,
    [Parameter(Mandatory = $true)]
    [ValidateSet(
      'OnlyLetter', 
      'OnlyNumber',
      'OnlyLetter+Number',
      'OnlyLetter+Symbols',
      'AllSymbols')]
      $WorkLine
    )  

switch ($WorkLine) {
    'OnlyLetter' { 
        $PassNumber | ForEach-Object -process {
            $PassResult = -join (1..$long | % { [char[]]'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | Get-Random })
            $PassResult
        }
     }

    'OnlyNumber' { 
        $PassNumber | ForEach-Object -process {
            $PassResult = -join (1..$long | % { [char[]]'0123456789' | Get-Random })
            $PassResult
        }
     }

    'OnlyLetter+Number' { 
        $PassNumber | ForEach-Object -process {
            $PassResult = -join (1..$long | % { [char[]]'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' | Get-Random })
            $PassResult
        }
     }

    'OnlyLetter+Symbols' { 
        $PassNumber | ForEach-Object -process {
            $PassResult = -join (1..$long | % { [char[]]'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"§$%&/()=?}][{@#*+' | Get-Random })
            $PassResult
        }
     }

    'AllSymbols' { 
        $PassNumber | ForEach-Object -process {
            $PassResult = -join (1..$long | % { [char[]]'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"§$%&/()=?}][{@#*+' | Get-Random })
            $PassResult
        }
     }
}

# формирования пароля в UTF8 для дальнейших работ
    $Path = $pwd.Path
    $FileEncoding = "$Path\fileencoding.txt"
    $pass | Out-File $FileEncoding -Encoding utf8
    $pass = Get-Content $FileEncoding -Encoding UTF8
    Remove-Item $FileEncoding -Force

return $pass
}

function Get-Translit {
<#
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
    
    Author: @Chentsov_VS
#>    

    param (
	$TranslateText 
	)
	
    $Translit = @{

        [char]'а' = "a"
        [char]'А' = "a"
        [char]'б' = "b"
        [char]'Б' = "b"
        [char]'в' = "v"
        [char]'В' = "v"
        [char]'г' = "g"
        [char]'Г' = "g"
        [char]'д' = "d"
        [char]'Д' = "d"
        [char]'е' = "e"
        [char]'Е' = "e"
        [char]'ё' = "e"
        [char]'Ё' = "e"
        [char]'ж' = "zh"
        [char]'Ж' = "zh"
        [char]'з' = "z"
        [char]'З' = "z"
        [char]'и' = "i"
        [char]'И' = "i"
        [char]'й' = "y"
        [char]'Й' = "y"
        [char]'к' = "k"
        [char]'К' = "k"
        [char]'л' = "l"
        [char]'Л' = "l"
        [char]'м' = "m"
        [char]'М' = "m"
        [char]'н' = "n"
        [char]'Н' = "n"
        [char]'о' = "o"
        [char]'О' = "o"
        [char]'п' = "p"
        [char]'П' = "p"
        [char]'р' = "r"
        [char]'Р' = "r"
        [char]'с' = "s"
        [char]'С' = "s"
        [char]'т' = "t"
        [char]'Т' = "t"
        [char]'у' = "u"
        [char]'У' = "u"
        [char]'ф' = "f"
        [char]'Ф' = "f"
        [char]'х' = "kh"
        [char]'Х' = "kh"
        [char]'ц' = "ts"
        [char]'Ц' = "ts"
        [char]'ч' = "ch"
        [char]'Ч' = "ch"
        [char]'ш' = "sh"
        [char]'Ш' = "sh"
        [char]'щ' = "sch"
        [char]'Щ' = "sch"
        [char]'ъ' = ""
        [char]'Ъ' = ""
        [char]'ы' = "y"
        [char]'Ы' = "y"
        [char]'ь' = ""
        [char]'Ь' = ""
        [char]'э' = "e"
        [char]'Э' = "e"
        [char]'ю' = "yu"
        [char]'Ю' = "yu"
        [char]'я' = "ya"
        [char]'Я' = "ya"
        [char]'.' = "."
        [char]' ' = "" 
        
    }
    $chars = $translateText.ToCharArray();

    foreach ($char in $chars) {$outString += $Translit[$char]}
return $outString;
}

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


function New-User {  
    <#
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

   .NOTES
    Author: @Chentsov_VS
   #>
    param (
        [string]$SurName = "", 
        [string]$FirstName = "",
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'RandomPassword', 
            'StaticPassword'
            )]
        $StatusPassword,
       
        [string]$Password = "P@ssw0rd", 
        [string]$Position = "",
        [string]$EmailDomain = "@Youre_domain.com",
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'OneUser', 
            'MassUser'
            )]
        $WorkLine,
        $PathFile = "",
        [ValidateSet(
            'MSK', 
            'SPb',
            'Regions'
            )]
        $OP = "",
        [ArgumentCompleter( {
            param ( $commandName,
                    $parameterName,
                    $wordToComplete,
                    $commandAst,
                    $fakeBoundParameters )

            $possibleValues = @{
                MSK = @('PVL', 'DBR', 'NVB')
                SPb = @('SPS', 'FTK','BLK')
                Regions = @('NSB','SMR','KZN','VLD','IRK','EKB')
            }
            if ($fakeBoundParameters.ContainsKey('OP'))
            {
                $possibleValues[$fakeBoundParameters.Type] | Where-Object {
                    $_ -like "$wordToComplete*"
                }
            }
            else
            {
                $possibleValues.Values | ForEach-Object {$_}
            }
        } )]
        $Value,
        $Token = "Paste_Your_Email_Token"
    )
        
    switch ($WorkLine) {
        OneUser { 
            $ParseOldUser = Get-ADUser -filter 'name -like "*"' -Property * `
                | Where-Object {$_.Description -like "*$Position*"} `
                | Sort-Object TimeCreate -Descending
            $ParseMember = $ParseOldUser[0].memberof

            $ParseName = $FirstName.chars(0)
            $DataLogin = $ParseName + "." + $SurName
            $Login =  Get-Translit -TranslateText $DataLogin
            
            if ($StatusPassword -like 'RandomPassword') {
                $Password = GeneratePass -long 12 -WorkLine OnlyLetter+Number
            }

            $ErrorParseUser = "Пользователь с должностью $Position не найден в домене. 
            Ctrl + C = Отмена.
            Enter = Продолжить (внесу вручную)"
            $OkParseUser = "Я нашел пользователя с такой должностью, я сделаю пользователя с группами
                $ParseMember
                ____________
                Ctrl + C = Отмена.
                Enter = Продолжить."
            
            if ($Null -eq $ParseMember) {
                Read-Host "$ErrorParseUser"
            }
            
            else {
                Read-Host "$OkParseUser"
            }            
            
            $Email = $Login + $EmailDomain  
            $Name = "$Surname " + $FirstName

            New-ADuser -Name $Name -Verbose `
                -DisplayName $Name `
                -Surname $SurName `
                -GivenName $FirstName `
                -sAMAccountName $Login `
                -Description $Position `
                -Mail $Email `
                -CannotChangePassword $false `
                -PasswordNeverExpires $false `
                -PasswordNotRequired $true `
                -ChangePasswordAtLogon $true `
                -Enabled $True `
                -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force)
            
            New-EmailYandex -NickName $Login `
                -SurName $SurName `
                -FirstName $FirstName `
                -Password $Password `
                -Position $Position `
                -WorkLine $WorkLine `
                -Token $Token
              
            $DataNewUser = @(Login="$Login";Password="$Password";Email="$Email")
            }
            
        MassUser {
            $AllData = Import-Csv -Path $PathFile -Delimiter "," -Encoding UTF8 -Header SurName,FirstName,Position,OP
            $DataNewUser = foreach ($Data in $AllData) {
                [string]$SurName = $Data.SurName
                [string]$FirstName = $Data.FirstName
                [string]$Position = $Data.position
                [string]$OP = $Data.OP
                        
                $ParseOldUser = Get-ADUser -filter 'name -like "*"' -Property * `
                    | Where-Object {$_.Description -like "*$Position*"} `
                    | Sort-Object TimeCreate -Descending
                $ParseMember = $ParseOldUser[0].memberof
        
                $ParseName = $FirstName.chars(0)
                $DataLogin = $ParseName + "." + $SurName
                $Login =  Get-Translit -TranslateText $DataLogin
        
                if ($StatusPassword -like 'RandomPassword') {
                    $Password = GeneratePass -long 12 -WorkLine OnlyLetter+Number
                    }
        
                $ErrorParseUser = "Пользователь с должностью $Position не найден в домене. 
                    Ctrl + C = Отмена.
                    Enter = Продолжить (внесу вручную)"
                $OkParseUser = "Я нашел пользователя с такой должностью, я сделаю пользователя с группами
                    $ParseMember
                    ____________
                    Ctrl + C = Отмена.
                    Enter = Продолжить."
                        
                if ($Null -eq $ParseMember) {
                    Read-Host "$ErrorParseUser"
                    }
                        
                else {
                    Read-Host "$OkParseUser"
                    }            
                        
                $Email = $Login + $EmailDomain  
                $Name = "$Surname " + $FirstName
            
                New-ADuser -Name $Name -Verbose `
                    -DisplayName $Name `
                    -Surname $SurName `
                    -GivenName $FirstName `
                    -sAMAccountName $Login `
                    -Description $Position `
                    -EmailAddress $Email `
                    -CannotChangePassword $false `
                    -PasswordNeverExpires $false `
                    -PasswordNotRequired $true `
                    -ChangePasswordAtLogon $true `
                    -Enabled $True `
                    -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force)
                        
                New-EmailYandex -NickName $Login `
                    -SurName $SurName `
                    -FirstName $FirstName `
                    -Password $Password `
                    -Position $Position `
                    -WorkLine OneUser `
                    -Token $Token
                          
                @(Login="$Login";Password="$Password";Email="$Email";Name="$Name";Surname="$SurName";FirstName="$FirstName")

                }
            }
        }
    return $DataNewUser 
    }
   