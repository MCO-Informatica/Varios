//M->A1_CCLANT ? DOM?NIO E CONTRA-DOM?NIO
/*ATRIBUI O CONTE?DO DE A1_CCLANT ? _cCodAnt; IF VERIFICA SE NA STRING CONTIDA EM _cCodAnt CONT?M O CARACTER "-", SE SIM, EXECUTA ALERT E RETORNA BRANCO PARA O CAMPO*/
/* SEGUNDO IF VERIFICA SE "0" ? O PRIMEIRO CARACTERE DA STRING CONTIDA EM _cCodAnt , SE SIM, EXECUTA ALERT E RETORNA BRANCO, SEN?O, RETORN O C?DIGO DIGITADO V?LIDO*/
User Function RFATG21()

local _cCodAnt := M->A1_CCLANT
Local _cPesq1   := "-"
Local _cPesq2   := "0"


If AT(_cPesq1, _cCodAnt ) <> 0
  Alert("O campo -- C?DIGO ANTIGO DO CLIENTE -- admite apenas caracteres num?ricos. Por favor, digite novamente no formato correto")
  _cCodAnt := ""
EndIf

If AT(_cPesq2, _cCodAnt ) == 1
  Alert("O primeiro caracter do campo -- C?DIGO ANTIGO DO CLIENTE -- n?o pode iniciar com 0 (zero). Por favor, digite novamente no formato correto")
  _cCodAnt := ""
EndIf


Return(_cCodAnt)


