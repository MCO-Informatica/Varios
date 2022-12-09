#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------+
!                          RELATORIO DE ORÇAMENTOS - TELEVENDAS              !
+------------------+---------------------------------------------------------+
!Nome              ! ADVTEC - YURI PORTO                                     !
+------------------+---------------------------------------------------------+
!Data de Criacao   !  12/09/2013                                             !
+------------------+--------------------------------------------------------*/




User Function RELSUB()
Private oArial15  	:=	TFont():New("Arial",,15,,.F.,,,,,.F.,.F.)
Private oArial10N	:=	TFont():New("Arial",,10,,.T.,,,,,.F.,.F.)
Private oArial11N	:=	TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("MyFunction")


  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

//local oSecao1 := oReport:Section(1)


BEGINSQL ALIAS "REL"

SELECT UA_CLIENTE
		FROM %table:SUA% SUA
ENDSQL








  oPrinter:Box(0044,0046,3255,2403)/*Margem*/
//---------------caixas
  oPrinter:Box(0044,0046,0237,2401)
  oPrinter:Box(0531,0046,0764,2401)
  oPrinter:Box(0766,0049,1191,2401)
  oPrinter:Box(0284,0046,0531,2401)
//--------------------------CABEC
  
  oPrinter:Say(0122,0893,"Relatorio de Orcamentos ",oArial15,,0)
  oPrinter:Say(0064,2156,"Data ",oArial10N,,0)
  oPrinter:Say(0377,0072,"Nome do cliente",oArial11N,,0)
  oPrinter:Say(0324,0067,"Cod Cliente ",oArial11N,,0)
  oPrinter:Say(0390,0600,UA_CLIENTE)
  oPrinter:Say(0433,0072,"Endereco ",oArial11N,,0)
  oPrinter:Say(0568,0077,"Atendimento :",oArial11N,,0)
  oPrinter:Say(0628,0079,"Contato :",oArial11N,,0)
  oPrinter:Say(0691,0074,"Vendedor :",oArial11N,,0)
  oPrinter:Say(0602,1869,"Emissao ",oArial11N,,0)
  oPrinter:Say(0648,1864,"Validade ",oArial11N,,0)

//----------------------------------------------------------

  oPrinter:Say(0771,0107,"Cod ",oArial10N,,0)
  oPrinter:Say(0773,0879,"Descricao :",oArial10N,,0)
  oPrinter:Say(0768,0273,"Tipo :",oArial10N,,0)
  oPrinter:Say(0777,1551,"Qtd :",oArial11N,,0)
  oPrinter:Say(0773,1715,"Vl Unit :",oArial10N,,0)
  oPrinter:Say(0786,2191,"Vl Item :",oArial10N,,0)
  oPrinter:Say(0777,1922,"Desc :",oArial10N,,0)
  oPrinter:Say(1468,0105,"Total :",oArial11N,,0)

Return
