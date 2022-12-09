//*=====================*=======8==================*==================*
//|PROGRAMA: TKFILCONT  | AUTOR | RICARDO CAVALINI | DATA: 23-11-2017 |
//*=====================*=======8==================*==================*
//| ESTE PONTO DE ENTRADA VAI FILTAR OS CONTATOS NA TELA DO CALL      |
//| CENTER, NO MOMENTO DA SELEÇÃO. PARA SEU FUNCIONAMENTO BASTA       |
//| PREENCHER O CAMPO DE ATIVO IGUAL A NAO                            |
//*===================================================================*
USER FUNCTION TKFILCONT()      
_CFILTRO := ""
_CFILTRO := SU5->U5_ATIVO == "1"
RETURN(_CFILTRO)