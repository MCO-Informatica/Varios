#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER CHR(13)+CHR(10)

//----------------------------------------------------------------------------------------
// PONTO DE ENTRADA PARA TRAZER IMPOSTOS NA OBSERVAÇÃO DA RPS...
//----------------------------------------------------------------------------------------

USER FUNCTION MTDESCRNFE()
//Declaração de Variáveis
    Private _cMsg := ""          //Variável de Retorno da Função
    Private _aArea := getArea()  //Armazena a área selecionada
//Variáveis de Valores de Impostos
    Private _nVlrIR 	:= 0
    Private _nVlrPIS	:= 0
    Private _nVlrCOF	:= 0
    Private _nVlrCSL	:= 0
    Private _nVlrLiq 	:= 0
    Private _nVlrBrt 	:= 0

    Private _cCodPro   := " "
    Private _cMenota   := " "
    Private _dDataVenc := " "
//Variáveis das Alíquitas de Impostos
//Passam de parâmetros
    Private _cNF  := ParamIXB[1] //Numero da NF, posicionado no SF3
    Private _cSer := ParamIXB[2] //Série da NF
    Private _cCli := ParamIXB[3] //Cliente
    Private _cLoja:= ParamIXB[4] //Loja Cliente
    Private mSQL	:= ""
//Posiciona no SF2, para que o programa abaixo consiga gerar corretamente os impostos retidos


    If Select( "TMP" ) > 0
        dbSelectArea( "TMP" )
        TMP->( dbCloseArea() )
    EndIf

    mSQL := " SELECT * FROM "+RetSQLName("SD2")
    mSQL += " WHERE D_E_L_E_T_ <> '*' AND ED_FILIAL = '"+xFilial("SD2")+"' AND "
    mSQL += " D2_DOC='"+_cNF+"' AND D2_SERIE='"+_cSer+"' AND D2_CLIENTE ='"+_cCli+"' AND D2_LOJA='"+_cLoja+"'"

    dbUseArea(.T., "TOPCONN", TCGenQry(,,mSQL),"TMP", .F., .T.)

    dbSelectArea( "TMP" )
    TMP->( dbGoTop() )
    If TMP->(!Eof())


    Endif

    DBSELECTAREA("SE1")
    DBSETORDER(2)
    DBSEEK(XFILIAL("SE1")+_cCli+_cLoja+_cSer+_cNF,.F.)

    _cQuery := " SELECT * FROM "+RETSQLNAME("SE1")+ENTER
    _cQuery += " WHERE D_E_L_E_T_ = '' AND E1_PREFIXO = '"+_cSer+"' AND E1_NUM = '"+_cNF+"' AND E1_CLIENTE ='"+_cCli+"' AND E1_LOJA ='"+_cLoja+"'"+ENTER

    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
    WHILE QUERY->(!EOF())
        If QUERY->E1_TIPO = 'IR-'
            _nVlrIR := QUERY->E1_VALOR
        EndIf
        If QUERY->E1_TIPO = 'PI-'
            _nVlrPIS := QUERY->E1_VALOR
        EndIf
        If QUERY->E1_TIPO = 'CF-'
            _nVlrCOF := QUERY->E1_VALOR
        EndIf
        If QUERY->E1_TIPO = 'CS-'
            _nVlrCSL := QUERY->E1_VALOR
        EndIf
        QUERY->(DBSKIP())
    ENDDO
    QUERY->(DBCLOSEAREA())
    //Mensagem Incial

    _cQuery := " SELECT * FROM "+RETSQLNAME("SFT")+ENTER
    _cQuery += " WHERE D_E_L_E_T_ = '' AND FT_SERIE = '"+_cSer+"' AND FT_NFISCAL = '"+_cNF+"' AND FT_TIPOMOV = 'S' "+ENTER

    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
    WHILE QUERY->(!EOF())
        _cCodPro	:= QUERY->FT_PRODUTO
        _nVlrBrt	:= QUERY->FT_VALCONT
        QUERY->(DBSKIP())
    ENDDO
    QUERY->(DBCLOSEAREA())

    DBSELECTAREA("SB1")
    DBSETORDER(1)
    DBSEEK(XFILIAL("SB1")+_cCodPro,.F.)

    _cMsg := SB1->B1_DESC + Space(1) + Chr(124) + Space(1) + Space(1) + Chr(124) + Space(1)

    _cQuery := " SELECT * FROM "+RETSQLNAME("SC5")+ENTER
    _cQuery += " WHERE D_E_L_E_T_ = '' AND C5_SERIE = '"+_cSer+"' AND C5_NOTA = '"+_cNF+"'"+ENTER
    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
    _cMenota := ""
    WHILE QUERY->(!EOF())
        _cMenota  := ALLTRIM(QUERY->C5_MENNOTA)
        QUERY->(DBSKIP())
    ENDDO
    QUERY->(DBCLOSEAREA())

    IF ALLTRIM(_cMenota) != ""
        _cMsg += _cMenota + Space(1) + Chr(124) + Space(1) + Space(1) + Chr(124) + Space(1)
    ENDIF

    _cQuery := " SELECT * FROM "+RETSQLNAME("SE1")+ENTER
    _cQuery += " WHERE D_E_L_E_T_ = '' AND E1_TIPO = 'NF' AND E1_NUM = '"+_cNF+"'"+ENTER
    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
    _dDataVenc := ""
    WHILE QUERY->(!EOF())
        _dDataVenc += DTOC(Stod(QUERY->E1_VENCTO)) +", "
        QUERY->(DBSKIP())
    ENDDO
    QUERY->(DBCLOSEAREA())
    IF LEN(_dDataVenc) >0
        _dDataVenc := SUBSTR(_dDataVenc,1,LEN(_dDataVenc)-2)
        _cMsg += "Vencimento em : "+ _dDataVenc + Space(1) + Chr(124) + Space(1)+ Space(1) + Chr(124) + Space(1)
    ENDIF

    //Gerando a Observação que vai ser impressa na Nota Fiscal de Serviços Eletrônica (NF-e)
    //IMPOSTO DE RENDA
    If _nVlrIR != 0
        _cMsg += "IR.    1,50% (R$ "
        _cMsg += AllTrim(Transform(_nVlrIR,"@E 999,999.99"))
        _cMsg += + ")" + Space(1) + Chr(124) + Space(1) // Conforme orientação a quebra é feita pelo Pipe '|' entre espaços
    EndIf

    IF _nVlrPIS+_nVlrCOF+_nVlrCSL > 0
        _cMsg += "Impostos via Apuração (Destaque):"+Space(1) + Chr(124) + Space(1)
        //PIS
        If _nVlrPIS != 0
            _cMsg += "PIS    0,65% (R$ "
            _cMsg += AllTrim(Transform(_nVlrPIS,"@E 999,999.99"))
            _cMsg += + ")" + Space(1) + Chr(124) + Space(1) // Conforme orientação a quebra é feita pelo Pipe '|' entre espaços
        EndIf
        //COFINS
        If _nVlrCOF != 0
            _cMsg += "COFINS 3,00% (R$ "
            _cMsg += AllTrim(Transform(_nVlrCOF,"@E 999,999.99"))
            _cMsg += + ")" + Space(1) + Chr(124) + Space(1) // Conforme orientação a quebra é feita pelo Pipe '|' entre espaços
        EndIf
        //CSLL
        If _nVlrCSL != 0
            _cMsg += "CSLL  1,00% (R$ "
            _cMsg += AllTrim(Transform(_nVlrCSL,"@E 999,999.99"))
            _cMsg += + ")" + Space(1) + Chr(124) + Space(1) // Conforme orientação a quebra é feita pelo Pipe '|' entre espaços
        EndIf

        _nVlrLiq :=  (_nVlrBrt-(_nVlrIR+_nVlrPIS+_nVlrCOF+_nVlrCSL))
        _cMsg += "Valor liquido R$ "
        _cMsg += AllTrim(Transform(_nVlrLiq,"@E 999,999.99")) + Space(1) + Chr(124) + Space(1) + Space(1) + Chr(124) + Space(1)



        _cMsg += "Atenção: de acordo com a Lei 10.925, a Retenção de PIS/COFINS/CSLL se dará caso os pagamentos efetuados no "//+ Space(1) + Chr(124) + Space(1)
        _cMsg += "mesmo mês excedam o montante de R$ 5.000,00. Caso a somatória dos pagamentos no mês exceda este valor,     "//+ Space(1) + Chr(124) + Space(1)
        _cMsg += "deverão ser retidos os impostos referentes as NF's pagas."+ Space(1) + Chr(124) + Space(1)
    ENDIF

    RestArea(_aArea)//Restaura a área selecionada no começo do programa
RETURN _cMsg