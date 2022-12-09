//M->A1_CCLANT É DOMÍNIO E CONTRA-DOMÍNIO
/*ATRIBUI O CONTEÚDO DE A1_CCLANT À _cCodAnt; IF VERIFICA SE NA STRING CONTIDA EM _cCodAnt CONTÉM O CARACTER "-", SE SIM, EXECUTA ALERT E RETORNA BRANCO PARA O CAMPO*/
/* SEGUNDO IF VERIFICA SE "0" É O PRIMEIRO CARACTERE DA STRING CONTIDA EM _cCodAnt , SE SIM, EXECUTA ALERT E RETORNA BRANCO, SENÃO, RETORN O CÓDIGO DIGITADO VÁLIDO*/
User Function RFATG21()

local _cCodAnt := M->A1_CCLANT
Local _cPesq1   := "-"
Local _cPesq2   := "0"


If AT(_cPesq1, _cCodAnt ) <> 0
  Alert("O campo -- CÓDIGO ANTIGO DO CLIENTE -- admite apenas caracteres numéricos. Por favor, digite novamente no formato correto")
  _cCodAnt := ""
EndIf

If AT(_cPesq2, _cCodAnt ) == 1
  Alert("O primeiro caracter do campo -- CÓDIGO ANTIGO DO CLIENTE -- não pode iniciar com 0 (zero). Por favor, digite novamente no formato correto")
  _cCodAnt := ""
EndIf


Return(_cCodAnt)


