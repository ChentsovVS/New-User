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