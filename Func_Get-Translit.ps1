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