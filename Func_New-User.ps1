
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
   