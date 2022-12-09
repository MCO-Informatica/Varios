//VERIFICA SE CONTEÚDO DO CAMPO A1_PINSCR CONTÉM "2", SE SIM ATRIUBUI "**** ISENTO ****" À cInscri E RETORNA cInscri PARA O GATILHO
//DOMÍNIO A1_A1_PINSCR CONTRA: A1_INSCR
User function RFATG18()

Local cInscri := ""


If M->A1_PINSCR= "2"
cInscri := "                         **** ISENTO **** "

EndIf

Return(cInscri)
