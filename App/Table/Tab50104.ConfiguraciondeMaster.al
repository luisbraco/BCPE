table 50104 "Configuracion de Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Gran Familia"; Code[20])
        {
            TableRelation = "Item Category".Code;
            ValidateTableRelation = false;
        }
        field(2; Familia; Code[20])
        {
            // ValidateTableRelation = false;
        }
        field(3; Codigo; Code[15]) { }
        field(4; Descripcion; Text[80]) { }
        field(5; Tipo; Integer) { }
        field(6; Grupo; Code[50])
        {
            TableRelation = "No. Series".Code;
            ValidateTableRelation = false;
        }
        field(7; Vendor; Code[20])
        {
            CaptionML = ENU = 'Vendor', ESM = 'Proveedor';
        }
        field(8; Delegacion; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = FILTER(2));
        }
        field(9; Importe; Decimal)
        {
        }
        field(10; "Tipo Validacion"; Option)
        {
            OptionCaptionML = ENU = ',Certificate,Contracts,Detail,Cabecera,Total',
            ESP = ' ,Certificado,Contrato,Detalle,Cabecera,Total',
            ESM = ' ,Certificado,Contrato,Detalle,Cabecera,Total';
            OptionMembers = "","Certificate","Contracts","Detail","Cabecera","Total";
        }
        field(11; "Numero Maximo"; Integer)
        {
        }
        field(12; Formula; Text[250])
        {
        }
    
//         field(13; TipoAnticipo; Option)
//         {
// // OptionCaptionML = ESM =' ,Creacion,Aplicacion';
//         }  
           
        field(14;MostrarCierreMensual; Boolean   )
        {

        }
        field(24;Currency;Code[10])
        {
            TableRelation = Currency.Code;
            CaptionML =[ENU =Currency Code;
            ESP ='C¢d. Divisa',ESM ='C¢d. Divisa'; 
}
        field(28;No. Series;Code[10];TableRelation="No. Series";
                                                   OnLookup=VAR
                                                              lclRecNoSeries@1000000000 : Record 308;
                                                              lclFrmNoSeries@1000000001 : Form 456;
                                                            BEGIN
                                                              lclRecNoSeries.RESET;
                                                              CLEAR(lclFrmNoSeries);
                                                              lclFrmNoSeries.LOOKUPMODE(TRUE);
                                                              lclFrmNoSeries.SETTABLEVIEW(lclRecNoSeries);
                                                              lclFrmNoSeries.SETRECORD(lclRecNoSeries);
                                                              IF lclFrmNoSeries.RUNMODAL= ACTION::LookupOK THEN BEGIN
                                                                 lclFrmNoSeries.GETRECORD(lclRecNoSeries);
                                                                 "No. Series" := lclRecNoSeries.Code;
                                                                 lclFrmNoSeries.LOOKUPMODE(FALSE);
                                                              END;
                                                            END;

                                                   CaptionML=[ENU=No. Series;
                                                              ESP=Nos. serie];
                                                   Editable=No }
    field( 50000;  Cuenta Contable     ;Code[20]        ;TableRelation="G/L Account";
                                                   Description=ULNPERU.60::REG::07/06/16 }
    field( 50001;  Capataz             ;Text[80]         }
    field( 50002;  Orden               ;Integer        }
    field( 50003;  Visualizar          ;Boolean       ;Description=JER Visualizar en GIA }
    field( 50004;  Tipo Cierre Curso   ;Option        ;OptionCaptionML=ESM=" ,Gasto Curso,Obra Curso,Gasto General,Tasa Activos";
                                                  OptionString=[ ,Gasto Curso,Obra Curso,Gasto General,Tasa Activos] }
    field( 50005;  No. Cuenta          ;Code[20]        ;TableRelation="G/L Account" }
    field( 50006;  Naturaleza Cobra    ;Code[20]         }
    field( 50007;  No Generar Automaticamente;Boolean  }
    field( 50008;  Vendor Posting Group Code;Code[10]   ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[ENU=Vendor Posting Group Code;
                                                              ESP=Grupo Contable Proveedor;
                                                              ESM=Grupo Contable Proveedor] }
    field( 50009;  Cuenta OT           ;Code[20]        ;TableRelation="G/L Account";
                                                   CaptionML=[ENU=Cuenta OT;
                                                              ESP=Cuenta OT;
                                                              ESM=Cuenta OT];
                                                   Description=ULNPERU.60::RRR::12/07/18 }
    field( 50010;  Buy-from Vendor No. ;Code[20]        ;TableRelation=Vendor;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ESM=Compra a-N§ proveedor }
    field( 50011;  Vendor Posting Group Adicional;Code[10];
                                                   TableRelation="Vendor Posting Group";
                                                   CaptionML=[ENU=Vendor Posting Group add;
                                                              ESP=Grupo contable proveedor Adicional;
                                                              ESM=Grupo contable proveedor Adicional];
                                                   Description=JRN;
                                                   Editable=Yes }
    field( 50012;  Flujo Operaciones   ;Option        ;OptionCaptionML=[ENU=" ,G/C,G/G,AP";
                                                                    ESM=" ,G/C,G/G,AP"];
                                                   OptionString=[ ,G/C,G/G,AP] }
    field( 50013;  Cuenta GG           ;Text30        ;TableRelation="G/L Account";
                                                   CaptionML=[ENU=Cuenta GG;
                                                              ESM=Cuenta GG] }
    field( 50014;  No Valida Dimensiones;Boolean      ;CaptionML=[ENU=No Valida Dimensiones;
                                                              ESM=No Valida Dimensiones] }
    field( 50072;  ;Estatus Replica     ;Option        ;CaptionML=[ENU=Estatus Replica;
                                                              ESM=Estatus Replica];
                                                   OptionCaptionML=[ENU=Nuevo,Modificado,Replicado;
                                                                    ESM=Nuevo,Modificado,Replicado];
                                                   OptionString=Nuevo,Modificado,Replicado }
    field( 50100;  ;FA Class Code       ;Code[10]        ;TableRelation="FA Class";
                                                   CaptionML=[ENU=FA Class Code;
                                                              ESP=A/F C¢d. clase] }
    field( 50101;  ;FA Subclass Code    ;Code[10]        ;TableRelation="FA Subclass";
                                                   CaptionML=[ENU=FA Subclass Code;
                                                              ESP=A/F C¢d. subclase] }
    field( 50102;  ;FA Family Code      ;Code[10]        ;TableRelation="Configuracion de Master".Codigo WHERE ("Gran Familia"=FIELD(FA Subclass Code));
                                                   OnValidate=VAR
                                                                lclConfMaster@1000000000 : Record 50008;
                                                              BEGIN
                                                              END;

                                                   OnLookup=VAR
                                                              lclConfMaster@1100215001 : Record 50008;
                                                              lclSelectLinesFields@1100215000 : Form 50440;
                                                              getSubClase@1100215002 : Record 5608;
                                                            BEGIN
                                                              TESTFIELD("FA Subclass Code");

                                                              lclConfMaster.RESET;
                                                              lclConfMaster.FILTERGROUP(2);
                                                              lclConfMaster.SETRANGE(""Gran Familia"","FA Subclass Code");
                                                              lclConfMaster.FILTERGROUP(0);

                                                              getSubClase.RESET;
                                                              getSubClase.SETRANGE(getSubClase.Code,"FA Subclass Code");
                                                              IF NOT getSubClase.FIND('-') THEN
                                                                 CLEAR(getSubClase);

                                                              CLEAR(lclSelectLinesFields);
                                                              lclSelectLinesFields.LOOKUPMODE(TRUE);
                                                              lclSelectLinesFields.SetDescription("FA Subclass Code" + ' - ' + getSubClase.Name);
                                                              lclSelectLinesFields.SETTABLEVIEW(lclConfMaster);
                                                              lclSelectLinesFields.SETRECORD(lclConfMaster);
                                                              IF lclSelectLinesFields.RUNMODAL=ACTION::LookupOK THEN
                                                              BEGIN
                                                                 lclSelectLinesFields.GETRECORD(lclConfMaster);
                                                                 lclSelectLinesFields.LOOKUPMODE(FALSE);
                                                                 "FA Family Code" := lclConfMaster.Codigo;
                                                                 MODIFY;
                                                              END;
                                                            END;

                                                   CaptionML=[ENU=FA Family Code;
                                                              ESP=AF. C¢d. Familia;
                                                              ESM=AF. C¢d. Familia] }
    field( 50103;  ;Cod. Cuenta Movil   ;Text50        ;CaptionML=[ENU=Cod. Cuenta Movil;
                                                              ESM=Cod. Cuenta Movil];
                                                   Description=Costo Sistemas }
    field( 50104;  ;Multi-Empresa       ;Boolean       ;CaptionML=[ENU=Multi-Empresa;
                                                              ESM=Multi-Empresa] }
    field( 50105;  ;Tipo de Gasto Periodificacion;Option;
                                                   CaptionML=[ENU=Tipo de Gasto Periodificacion;
                                                              ESP=Tipo de Gasto Periodificacion;
                                                              ESM=Tipo de Gasto Periodificacion];
                                                   OptionCaptionML=[ENU=" ,Cuenta Gasto,Cuenta Ingreso Positivo,Cuenta Ingreso Negativo,Mano Obra,CP Mano Obra,CP Cuenta Gasto,CP Ingreso Positivo,CP Ingreso Negativo,CC Mano Obra,CC Cuenta Gasto,CC Ingreso Positivo,CC Ingreso Negativo";
                                                                    ESP=" ,Cuenta Gasto,Cuenta Ingreso Positivo,Cuenta Ingreso Negativo,Mano Obra,CP Mano Obra,CP Cuenta Gasto,CP Ingreso Positivo,CP Ingreso Negativo,CC Mano Obra,CC Cuenta Gasto,CC Ingreso Positivo,CC Ingreso Negativo";
                                                                    ESM=" ,Cuenta Gasto,Cuenta Ingreso Positivo,Cuenta Ingreso Negativo,Mano Obra,CP Mano Obra,CP Cuenta Gasto,CP Ingreso Positivo,CP Ingreso Negativo,CC Mano Obra,CC Cuenta Gasto,CC Ingreso Positivo,CC Ingreso Negativo"];
                                                   OptionString=[ ,Cuenta Gasto,Cuenta Ingreso Positivo,Cuenta Ingreso Negativo,Mano Obra,CP Mano Obra,CP Cuenta Gasto,CP Ingreso Positivo,CP Ingreso Negativo,CC Mano Obra,CC Cuenta Gasto,CC Ingreso Positivo,CC Ingreso Negativo] }
    field( 50106;  ;Tipo Generacion Terceros;Option    ;CaptionML=[ENU=Tipo Generacion Terceros;
                                                              ESP=Tipo Generacion Terceros;
                                                              ESM=Tipo Generacion Terceros];
                                                   OptionCaptionML=ESM=H2H,Planilla,Ambos;
                                                   OptionString=H2H,Planilla,Ambos;
                                                   Description=H2H Adryan }
    field( 50107;  ;Cuenta H2H          ;Code[10]        ;TableRelation="G/L Account";
                                                   CaptionML=[ENU=Cuenta H2H;
                                                              ESP=Cuenta H2H;
                                                              ESM=Cuenta H2H];
                                                   Description=H2H Adryan }
    field( 50500;  ;Journal Template Name;Code[10]       ;TableRelation="Gen. Journal Template";
                                                   CaptionML=[ENU=Journal Template Name;
                                                              ESP=Nombre libro diario];
                                                   NotBlank=Yes;
                                                   Description=Generaci¢n de Diario }
    field( 50501;  ;Tipo de Operacion Diario;Option    ;OptionCaptionML=[ESP=" ,Nota Conta.,Factoring,Planilla Movilidad,Anticipo,Reclasificacion G/I,Concesiones,Apertura,Aplicacion Anticipo,Devengado,Aplicacion Devengado,Reclasificacion C/Balance,Boleto/Viaje-Terrestre,Proviciones,Reembolso,Multiple Dimension,Rendiciones,Provicion/Naturaleza,Aplicaciones P/C,Adelanto/Prestmo,Fondo Fijo";
                                                                    ESM=" ,Nota Conta.,Factoring,Planilla Movilidad,Anticipo,Reclasificacion G/I,Concesiones,Apertura,Aplicacion Anticipo,Devengado,Aplicacion Devengado,Reclasificacion C/Balance,Boleto/Viaje-Terrestre,Proviciones,Reembolso,Multiple Dimension,Rendiciones,Provicion/Naturaleza,Aplicaciones P/C,Adelanto/Prestmo,Fondo Fijo,Descuentos Aplicar/trabajadores"];
                                                   OptionString=[ ,Nota Conta.,Factoring,Planilla Movilidad,Anticipo,Reclasificacion G/I,Concesiones,Apertura,Aplicacion Anticipo,Devengado,Aplicacion Devengado,Reclasificacion C/Balance,Boleto/Viaje-Terrestre,Proviciones,Reembolso,Multiple Dimension,Rendiciones,Provicion/Naturaleza,Aplicaciones P/C,Adelanto/Prestmo,Fondo Fijo,Descuentos Aplicar/trabajadores];
                                                   Description=Generaci¢n de Diario }
    field( 50502;  ;Abreviatura Diario  ;Code6         ;NotBlank=Yes;
                                                   Description=Generaci¢n de Diario }
    field( 50503;  ;ID Formulario       ;Integer        }
    field( 50504;  ;Rate                ;Decimal       ;CaptionML=[ENU=Rate;
                                                              ESP=Tasa;
                                                              ESM=Tasa] }
    field( 50505;  ;Forma Pago H2H      ;Option        ;CaptionML=[ENU=Forma Pago H2H;
                                                              ESM=Forma Pago H2H];
                                                   OptionCaptionML=[ENU=" ,Pago a terceros,Pago de haberes";
                                                                    ESM=" ,Pago a terceros,Pago de haberes"];
                                                   OptionString=[ ,Pago a terceros,Pago de haberes];
                                                   Description=Determina la exportacion del H2H en el diario de Pagos }
    field( 50506;  ;Subtipo Planilla Haberes;Code2     ;CaptionML=[ENU=Subtipo Planilla Haberes;
                                                              ESP=Subtipo Planilla Haberes;
                                                              ESM=Subtipo Planilla Haberes];
                                                   Description=Determina el subtipo de planilla de haberes en la exportacion H2H en el diario de Pagos }
    field( 50550;  ;Modificado GIA      ;Boolean       ;CaptionML=[ENU=Modificado GIA;
                                                              ESP=Modificado GIA;
                                                              ESM=Modificado GIA];
                                                   Description=Indica si se ha actualizado el registro para que el GIA lo procese }
    field( 50600;  ;Origen para Calculo ;Option        ;OptionCaptionML=[ENU=" ,Cuenta Contable,Marca Tabla,Historico Compras";
                                                                    ESM=" ,Cuenta Contable,Marca Tabla,Historico Compras"];
                                                   OptionString=[ ,Cuenta Contable,Marca Tabla,Historico Compras] }
    field( 50601;  ;Show detail         ;Boolean       ;CaptionML=[ENU=Show detail;
                                                              ESP=Ver Detallado;
                                                              ESM=Ver Detallado] }
    field( 50602;  ;File No             ;Code[10]        ;CaptionML=[ENU=File No;
                                                              ESP=Cod. Fila;
                                                              ESM=Cod. Fila] }
    field( 50603;  ;Description         ;Text50        ;CaptionML=[ENU=Description File;
                                                              ESP=Descripci¢n Fila;
                                                              ESM=Descripci¢n Fila] }
    field( 50604;  ;Totaling Type       ;Option        ;OnValidate=BEGIN
                                                                CASE "Totaling Type" OF
                                                                  field("Totaling Type"::Account,"Totaling Type"::"Total Accounts":
                                                                    BEGIN
                                                                      GLAcc.RESET;
                                                                      GLAcc.SETFILTER("No.",Totaling);
                                                                      IF GLAcc.FINDSET THEN BEGIN
                                                                         GLAcc.CALCFIELDS(Balance);
                                                                         Balance := GLAcc.Balance;
                                                                      END;
                                                                    END;}
                                                                  "Totaling Type"::Formula :
                                                                    BEGIN
                                                                      Totaling := UPPERCASE(Totaling);
                                                                      CheckFormula(Totaling);
                                                                    END;
                                                                END;
                                                              END;

                                                   OptionCaptionML=[ENU=" ,Input,Nature,Formula,Account";
                                                                    ESP=" ,Ingreso,Naturaleza,Formula,Cuenta";
                                                                    ESM=" ,Ingreso,Naturaleza,Formula,Cuenta"];
                                                   OptionString=[ ,Input,Nature,Formula,Account] }
    field( 50605;  ;Totaling            ;Text250       ;OnValidate=BEGIN
                                                                CASE "Totaling Type" OF
                                                                  field("Totaling Type"::Account,"Totaling Type"::"Total Accounts":
                                                                    BEGIN
                                                                      GLAcc.RESET;
                                                                      GLAcc.SETFILTER("No.",Totaling);
                                                                      IF GLAcc.FINDSET THEN BEGIN
                                                                         GLAcc.CALCFIELDS(Balance);
                                                                         Balance := GLAcc.Balance;
                                                                      END;
                                                                    END;}
                                                                  "Totaling Type"::Formula :
                                                                    BEGIN
                                                                      Totaling := UPPERCASE(Totaling);
                                                                      CheckFormula(Totaling);
                                                                    END;
                                                                  "Totaling Type"::Input :
                                                                    BEGIN
                                                                      IF NOT (Totaling IN ['PRODUCCIàN','CERTIFICACIàN','OBRA EN CURSO']) THEN
                                                                         ERROR(Text021);
                                                                    END;
                                                                END;
                                                              END;
                                                               }
    field( 50606;  ;Line No             ;Integer        }
    field( 50607;  ;Balance             ;Decimal       ;CaptionML=[ENU=Balance;
                                                              ESP=Datos del Periodo (MES);
                                                              ESM=Datos del Periodo (MES)] }
    field( 50608;  ;Balance First Day Year;Decimal     ;CaptionML=[ENU=Year Data Origen;
                                                              ESP=Datos Origen (A¤o);
                                                              ESM=Datos Origen (A¤o)] }
    field( 50609;  ;Balance Start of times;Decimal     ;CaptionML=[ENU=Origen Data Job;
                                                              ESP=Datos Origen (Obra);
                                                              ESM=Datos Origen (Obra)] }
    field( 50610;  ;Show Opposite Sign  ;Boolean       ;CaptionML=[ENU=Show Opposite Sign;
                                                              ESP=Invertir Signo en Resultado;
                                                              ESM=Invertir Signo en Resultado] }
    field( 50611;  ;Highlight Line      ;Boolean       ;CaptionML=[ENU=Highlight Line;
                                                              ESP=Resaltar Linea;
                                                              ESM=Resaltar Linea] }
    field( 50612;  ;Entry Type          ;Option        ;CaptionML=[ENU=Entry Type;
                                                              ESP=Tipo Entrada;
                                                              ESM=Tipo Entrada];
                                                   OptionCaptionML=[ENU=" ,Individual,Multiple";
                                                                    ESP=" ,Individual,Multiple";
                                                                    ESM=" ,Individual,Multiple"];
                                                   OptionString=[ ,Individual,Multiple];
                                                   Description=Campo para otras solicitudes }
    field( 50613;  ;Applied Person Type ;Option        ;CaptionML=[ENU=Applied Person Type;
                                                              ESP=Tipo Persona Aplica;
                                                              ESM=Tipo Persona Aplica];
                                                   OptionCaptionML=[ENU=" ,Vendor,Employee";
                                                                    ESP=" ,Proveedor,Empleado";
                                                                    ESM=" ,Proveedor,Empleado"];
                                                   OptionString=[ ,Vendor,Employee];
                                                   Description=Campo para otras solicitudes }
    field( 50700;  ;Relation Table      ; Code[10]        ;
                                 OnLookup =VAR
                                                              ConfiguracionMasterL@1100215000 : Record 50008;
                                 MaestroCostosSistemasL@1100215001 : Form 50464;
                                                            BEGIN
                                                              ConfiguracionMasterL.RESET;
                                                              CLEAR(MaestroCostosSistemasL);

                                                              CASE ""Gran Familia"" OF
                                                                 'SISTEMAS' :
                                                                       BEGIN
                                                                          ConfiguracionMasterL.SETRANGE(""Gran Familia"",'TASAS');
                                                                          ConfiguracionMasterL.SETRANGE(Familia,'');
                                                                          MaestroCostosSistemasL.ShowTasaSetup;
                                                                       END;
                                                                 'SERVICIOS' :
                                                                       BEGIN
                                                                          ConfiguracionMasterL.SETRANGE(""Gran Familia"",'TASAS');
                                                                          ConfiguracionMasterL.SETRANGE(Familia,'');
                                                                          MaestroCostosSistemasL.ShowServiciosSetup;
                                                                       END;
                                                                 'COMUNICACION' :
                                                                       BEGIN
                                                                          ConfiguracionMasterL.SETRANGE(""Gran Familia"",'TASAS');
                                                                          ConfiguracionMasterL.SETRANGE(Familia,'');
                                                                          MaestroCostosSistemasL.ShowComunicacionSetup;
                                                                       END;
                                                                 'HARDWARE' :
                                                                       BEGIN
                                                                          ConfiguracionMasterL.SETRANGE(""Gran Familia"",'TASAS');
                                                                          ConfiguracionMasterL.SETRANGE(Familia,'');
                                                                          MaestroCostosSistemasL.ShowTasaSetup;
                                                                       END;
                                                                 'TASAS' :
                                                                       BEGIN
                                                                          ConfiguracionMasterL.SETRANGE(""Gran Familia"",'TASAS');
                                                                          ConfiguracionMasterL.SETFILTER(Familia,'<>%1','');
                                                                          MaestroCostosSistemasL.ShowSubTasaSetup;
                                                                       END;
                                                              END;

                                                              //IF FORM.RUNMODAL(FORM::"Maestro Costos Sistemas",ConfiguracionMasterL) = ACTION::LookupOK THEN
                                                              MaestroCostosSistemasL.SETTABLEVIEW(ConfiguracionMasterL);
                                                              MaestroCostosSistemasL.SETRECORD(ConfiguracionMasterL);
                                                              MaestroCostosSistemasL.LOOKUPMODE(TRUE);
                                                              IF MaestroCostosSistemasL.RUNMODAL = ACTION::LookupOK THEN
                                                              BEGIN
                                                                 MaestroCostosSistemasL.GETRECORD(ConfiguracionMasterL);
                                                                 "Relation Table" := ConfiguracionMasterL.Codigo;
                                                              END;
                                                            END;

                                                   CaptionML=[ENU=Relacion Tabla;
                                                              ESM=Relacion Tabla];
                                                   Description=C01.0004 }
    field( 50701;  ;Tasa %              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Configuracion de Master".Importe WHERE ("Gran Familia"=FILTER(TASAS),
                                                                                                            Familia=FIELD(Codigo)));
                                                   OnLookup=VAR
                                                              ConfiguracionMasterL@1100215001 : Record 50008;
                                                              MaestroCostosSistemasL@1100215000 : Form 50464;
                                                            BEGIN
                                                              ConfiguracionMasterL.RESET;
                                                              CLEAR(MaestroCostosSistemasL);

                                                              ConfiguracionMasterL.SETRANGE(""Gran Familia"",'TASAS');
                                                              ConfiguracionMasterL.SETRANGE(Familia,Codigo);
                                                              MaestroCostosSistemasL.ShowSubTasaSetup;

                                                              MaestroCostosSistemasL.SETTABLEVIEW(ConfiguracionMasterL);
                                                              MaestroCostosSistemasL.SETRECORD(ConfiguracionMasterL);
                                                              MaestroCostosSistemasL.LOOKUPMODE(TRUE);
                                                              IF MaestroCostosSistemasL.RUNMODAL = ACTION::LookupOK THEN;
                                                            END;

                                                   CaptionML=[ENU=Tasa %;
                                                              ESM=Tasa %];
                                                   Description=C01.0004 }
    field( 50702;  ;Tasa Months         ;Integer       ;CaptionML=[ENU=Tasa Meses;
                                                              ESM=Tasa Meses];
                                                   Description=C01.0004 }
    field( 50703;  ;Qty Users           ;Integer       ;CaptionML=[ENU=Cantidad Usuarios;
                                                              ESM=Cantidad Usuarios];
                                                   Description=C01.0004 }
    field( 50704;  ;Calculo Manual      ;Boolean       ;CaptionML=[ENU=Calculo Manual;
                                                              ESM=Calculo Manual];
                                                   Description=C01.0004 }
    field( 50705;  ;Qty Users Real      ;Integer       ;CaptionML=[ENU=Cantidad Usuarios Real;
                                                              ESM=Cantidad Usuarios Real];
                                                   Description=C01.0004 }
    field( 50706;  ;Qty Users Detalle   ;Integer       ;CaptionML=[ENU=Cantidad Usuarios Detalle;
                                                              ESM=Cantidad Usuarios Detalle] }
    field( 50708;  ;Hardware Default Value;Boolean     ;Description=C01.0004 }
    field( 50709;  ;Programacion Pagos  ;Boolean       ;CaptionML=[ENU=Programacion Pagos;
                                                              ESM=Programacion Pagos] }
    field( 50720;  ;TipoDoc             ;Code[10]        ;TableRelation="C talos tributarios (Sunat)".Codigo WHERE (No_=CONST(10)) }
    field( 50721;  ;Tipo Diario         ;Option        ;OptionCaptionML=[ENU=" ,Distribucion";
                                                                    ESM=" ,Distribucion"];
                                                   OptionString=[ ,Distribucion] }
    field( 50722;  ;Cod. Servicio       ;Code[10]        ;TableRelation=Servicios.No. WHERE (Tipo Operacion=FILTER(Provision Directa)) }
    field( 50723;  ;Payment Method Code ;Code[10]        ;TableRelation="Payment Method";
                                                   CaptionML=[ENU=Payment Method Code;
                                                              ESP=C¢d. forma pago] }
    field( 50724;  ;Tiene Doc. Origen   ;Boolean       ;CaptionML=[ENU=Tiene Doc. Origen;
                                                              ESM=Tiene Doc. Origen];
                                                   Description=Otros Docuentos }
    field( 50725;  ;Validar Importe Total;Boolean      ;CaptionML=[ENU=Validar Importe Total;
                                                              ESM=Validar Importe Total];
                                                   Description=Otros Docuentos }
    field( 55030;  ;Factoring           ;Boolean       ;Description=EXC }
    field( 60000;  ;Payroll Gen. Jnl. Template;Code[10]  ;Description=Adryan }
    field( 60001;  ;Payroll Gen. Jnl. Batch;Code[10]     ;Description=Adryan }
    field( 60002;  ;Payroll Payment Terms Code;Code[10]  ;TableRelation="Payment Terms";
                                                   OnValidate=VAR
                                                                lclGenJournalBatch@1000000000 : Record 232;
                                                              BEGIN
                                                              END;

                                                   CaptionML=[ENU=Payment Terms Code;
                                                              ESP=C¢d. t‚rminos pago];
                                                   Description=Adryan }
    field( 60003;  ;Payroll Payment Method Code;Code[10] ;TableRelation="Payment Method";
                                                   CaptionML=[ENU=Payment Method Code;
                                                              ESP=C¢d. forma pago];
                                                   Description=Adryan }
    field( 80000;  ;CashFlow Last Entry No.;Integer    ;Description=CashFlow }
    field( 80001;  ;CashFlow Last Exec. Date;Date      ;Description=CashFlow }
    field( 80002;  ;CashFlow Last Exec. Time;Time      ;Description=CashFlow }
    field( 80003;  ;CashFlow Last Exec. UserID;Code30  ;Description=CashFlow }
    field( 80004;  ;CashFlow Last Start Datetime;DateTime;
                                                   Description=CashFlow }
    field( 80005;  ;CashFlow Last Rec. Entry No.;Integer;
                                                   Description=CashFlow }
    field( 80006;  ;CashFlow Last Pay. Entry No.;Integer;
                                                   Description=CashFlow }
    field( 80007;  ;CashFlow Last Credit Entry No.;Integer;
                                                   Description=CashFlow }
    field( 80008;  ;CashFlow Last Debit Entry No.;Integer;
                                                   Description=CashFlow }
    field( 80010;  ;CashFlow Type       ;Option        ;OptionCaptionML=[ENU=Receivables,Payables,Formula,Account,Bank,Income;
                                                                    ESM=Cuentas por cobrar,Cuentas por pagar,Formula,Cuenta,Banco,Ingresos;
                                                                    ESN=Cuentas por cobrar,Cuentas por pagar,Formula,Cuenta,Banco,Ingresos];
                                                   OptionString=Receivables,Payables,Formula,Account,Bank,Income;
                                                   Description=CashFlow }
    field( 80011;  ;Debit/Credit        ;Option        ;CaptionML=[ENU=Debit/Credit;
                                                              ESP=Debe/Haber;
                                                              ESM=Debe/Haber];
                                                   OptionCaptionML=[ENU=Both,Debit,Credit;
                                                                    ESP=Ambos,Debe,Haber;
                                                                    ESM=Ambos,Debe,Haber];
                                                   OptionString=Both,Debit,Credit;
                                                   Description=CashFlow }
    field( 80012;  ;Status              ;Boolean        }
    field( 80013;  ;Bank Account No.    ;Code[20]        ;TableRelation="Bank Account" }
    }
    
    keys
    {
        key(Key1; MyField)
        {
            Clustered = true;
        }
    }
    
    var
        myInt: Integer;
    
    trigger OnInsert()
    begin
        
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}