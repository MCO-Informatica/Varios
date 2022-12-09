//---------------------------------------------------------------------------------
// Rotina | FA300OCO  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | PE - Reposiciona registros para o tipo 'P' - Pagamento Sispag
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function FA300OCO()
Return( dbSeek(xFilial("SEB")+cBanco+Padr(Substr(cRetorno,1,3),3)+"P") )