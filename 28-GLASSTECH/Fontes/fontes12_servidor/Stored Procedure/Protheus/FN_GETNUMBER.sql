/*
-- função para eliminar qualquer caractere q não seja um numero de uma string

exemplo de uso: select dbo.GetNumber('12w3a780097')
*/

alter FUNCTION GetNumber (@variavel varchar(100))
RETURNS VARCHAR(100)
as
BEGIN
    DECLARE @ls int
    DECLARE @i int
    DECLARE @str varchar(100)

    SET @ls  = len(@variavel)
    SET @i   = 1;
    SET @str = '';
    
	WHILE @i <= @ls
	begin
        IF (substring(@variavel, @i,1) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9'))
		begin
            SET @str = @str + substring(@variavel, @i, 1) ;           
        END

        SET @i = @i  + 1;
    END
	
    RETURN RIGHT(@str, 6);

END