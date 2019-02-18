#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC12
Exemplo de uso da função FWMVCRotAuto

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC13()
Local aTurma := {}
Local aAlunos := {}
Local aLinha 

PRIVATE lMsErroAuto := .F.

    aadd(aTurma,{"ZB5_CODTUR","A03",Nil})

    aLinha := {}
    aadd(aLinha,{"ZB6_RA","0014"})    
    aadd(aAlunos,aLinha)

    aLinha := {}
    aadd(aLinha,{"ZB6_RA","0015"})    
    aadd(aAlunos,aLinha)   

    FWMVCRotAuto(FWLoadModel("MVC03"),"ZB5",3,{{"MASTERZB5",aTurma},{"DETAILZB6",aAlunos}},,.T.)
    
    If !lMsErroAuto
		ConOut("Rotina Executada com sucesso! ")
	Else
		ConOut("Erro na execução da rotina automatica")
	EndIf

Return

