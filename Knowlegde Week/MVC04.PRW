#Include 'Protheus.ch'
#Include 'fwmvcdef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC04
Exemplo de otherObject e folder na view.
Exemplo de modelo com 3 tabelas (pai x filho x neto)

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC04()
Local oBrowse
Static oGrafBar

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC04' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC04' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC04' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC04' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC04' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC04' OPERATION 9 ACCESS 0

//ExecBlock("MD_TURMA_ALUNO",.F.,.F.,{NIL,"MENUDEF","MENUDEF"})

Return aRotina

Static Function ModelDef() 
Local oModel 
Local oStruZB5 := FWFormStruct(1,"ZB5") 
Local oStruZB6 := FWFormStruct(1,"ZB6") 
Local oStruZB7 := FWFormStruct(1,"ZB7") 

    oModel := MPFormModel():New("MD_TURMA_ALUNO")  
    oModel:setDescription("Cadastro de Turma x Aluno x Nota")    

    oModel:addFields('MASTERZB5',,oStruZB5)
    oModel:getModel('MASTERZB5'):SetDescription('Dados da Turma')  

    oModel:addGrid('DETAILZB6','MASTERZB5',oStruZB6)    
    oModel:getModel('DETAILZB6'):SetDescription('Dados do Aluno') 
    oModel:setRelation("DETAILZB6", ;       
 					{{"ZB6_FILIAL",'xFilial("ZB6")'},;        
 						{"ZB6_CODTUR","ZB5_CODTUR"  }}, ;       
 						ZB6->(IndexKey(1)))         

    oModel:addGrid('DETAILZB7','DETAILZB6',oStruZB7)
    oModel:getModel('DETAILZB7'):SetDescription('Dados das Notas do Aluno')     						
    oModel:setRelation("DETAILZB7", ;       
 					{{"ZB7_FILIAL",'xFilial("ZB7")'},;        
 					{"ZB7_CODTUR","ZB6_CODTUR"  },;        
 					{"ZB7_RA","ZB6_RA"}}, ;       
 					ZB7->(IndexKey(1))) 				
 
Return oModel 

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')
Local oStruZB7:= FWFormStruct(2, 'ZB7')
    
    oStrZB6:RemoveField('ZB6_CODTUR')

    oStruZB7:RemoveField('ZB7_CODTUR')
    oStruZB7:RemoveField('ZB7_RA')
	
	oView := FWFormView():New()  
	oView:SetModel(oModel)    

	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  
	oView:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')     
	
	oView:AddOtherObject("GRAF",{|oPanel| CriaGrafico(oPanel) },,{|oPanel| GraRefresh() })
	
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 15)  

 	oView:CreateHorizontalBox( 'BOXFOLDER', 85)
	oView:CreateFolder( 'FOLDER', 'BOXFOLDER')
	oView:addSheet("FOLDER","ABA1","Alunos")
	oView:addSheet("FOLDER","ABA2","Notas")	
	
	oView:createHorizontalBox("BOX_ALUNOS",100,,,"FOLDER","ABA1")
	oView:createHorizontalBox("BOX_BASE_ABA03",100,,,"FOLDER","ABA2")

 	oView:CreateVerticalBox( 'BOX_NOTA', 70, 'BOX_BASE_ABA03',,"FOLDER","ABA2") 
 	oView:CreateVerticalBox( 'BOX_GRAFICO', 30, 'BOX_BASE_ABA03',,"FOLDER","ABA2") 
 	
 	oView:SetOwnerView('FORM_NOTA','BOX_NOTA')   	  
 	oView:SetOwnerView('FORM_ALUNOS','BOX_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')   
 	oView:SetOwnerView("GRAF","BOX_GRAFICO") 	
	
	oView:AddUserButton('Incluir Aluno','',{|oView|NovoAluno(oView)},'Inclui um novo aluno',VK_F12,{MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE})
	
Return oView 
 
Static Function NovoAluno()
	FWExecView("Novo Aluno","MVC01",MODEL_OPERATION_INSERT)
Return 

Static Function CriaGrafico(oPanel, lReDraw)
Local oModel	 := FWModelActive()
Local oModelNotas  := oModel:GetModel('DETAILZB7')
Local nI
Local nNotaGeral := 0
Local aMedia := {}
Local cDisc
Local nNotaDisc
Local nPos

Default lReDraw := .F.

    FWSaveRows()

    For nI := 1 To oModelNotas:Length()
        oModelNotas:GoLine(nI)
        If !oModelNotas:IsDeleted()
            nNotaDisc := oModelNotas:GetValue("ZB7_NOTA")
            cDisc := oModelNotas:GetValue("ZB7_CODDIS")
        
            nNotaGeral += nNotaDisc
            
            nPos := aScan(aMedia, {|x| x[1] == cDisc})
            
            If nPos == 0
                aAdd(aMedia, {cDisc, nNotaDisc, oModelNotas:GetValue('ZB7_DESDIS')} )
            Else
                aMedia[nPos][2] += nNotaDisc
            EndIf
        EndIf
    Next

    If !lReDraw
        oGrafBar := FWChartFactory():New()
        oGrafBar := oGrafBar:GetInstance( BARCHART )
        oGrafBar:Init( oPanel, .F., .F. )
        oGrafBar:SetMaxY( 5 )
        oGrafBar:SetTitle( "Media das Notas por Disciplina", CONTROL_ALIGN_CENTER )
        oGrafBar:SetLegend( CONTROL_ALIGN_RIGHT )
    Else
        oGrafBar:Reset()
    EndIf

    For nI:=1 to Len(aMedia)
        oGrafBar:addSerie( aMedia[nI][3]    , aMedia[nI][2] )
    Next nI 

    oGrafBar:build()

    FWRestRows()

Return

Static Function GraRefresh()
CriaGrafico( oGrafBar:oOwner, .T. )
Return NIL