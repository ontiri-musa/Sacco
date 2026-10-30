page 59385 "Default Notification"
{
    Editable = true;
    PageType = Card;
    SourceTable = "Default Notification Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; No)
                {
                }
                field("Member No"; "Member No")
                {
                }
                field("Loan No"; "Loan No")
                {
                }
                field(Stage; Stage)
                {
                }
                field("SMS Date"; "SMS Date")
                {
                }
                field(SMSText; SMSText)
                {
                    Caption = 'SMS Text';
                    MultiLine = true;
                    trigger OnValidate();
                    begin
                        TestField("SMS Date");
                        SetSMSTemplate(SMSText);
                    end;
                }
                field("Created By"; "Created By")
                {
                }
            }
            part(Control6; "Default Notification Lines")
            {
                Editable = PageEditable;
                SubPageLink = "Document No" = FIELD(No);
                SubPageView = WHERE("Member Phone No" = FILTER(<> ''));
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup9)
            {
                action("Send SMS")
                {
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //   Visible = SendSmsVisible;

                    trigger OnAction();
                    var
                        TotalLinesCount: Integer;
                        TotalUnselectedCount: Integer;
                    begin
                        TestField("SMS Date");


                        TotalLinesCount := 0;
                        TotalUnselectedCount := 0;

                        BulkSMSLine.RESET;
                        BulkSMSLine.SETRANGE(BulkSMSLine."Document No", No);
                        if BulkSMSLine.FINDSET then begin
                            TotalLinesCount := BulkSMSLine.Count;
                        end;

                        BulkSMSLine.RESET;
                        BulkSMSLine.SETRANGE(BulkSMSLine."Document No", No);
                        BulkSMSLine.SETRANGE(BulkSMSLine.Select, false);
                        if BulkSMSLine.FINDSET then begin
                            TotalUnselectedCount := BulkSMSLine.Count;
                        end;

                        IF TotalLinesCount = TotalUnselectedCount then
                            Error('You must select atleast a single member to send Default Notification');


                        if CONFIRM('Are you sure you want to send Default Notification to the selected members.?') = true then begin
                            BulkSMSLine.RESET;
                            BulkSMSLine.SETRANGE(BulkSMSLine."Document No", No);
                            BulkSMSLine.SETRANGE(BulkSMSLine.Select, true);
                            BulkSMSLine.SETRANGE(BulkSMSLine."Sent To Phone No", false);
                            if BulkSMSLine.FINDSET then begin
                                repeat
                                    CLEAR(DefaulterNotice);
                                    SMSEntry2.Reset();
                                    if SMSEntry2.FINDLAST then
                                        EntryNo := SMSEntry2."Entry No."
                                    else
                                        EntryNo := 0;
                                    GlobalM.CalculateLoanArrearsAndOverpaymentFactbox(BulkSMSLine."loan No", 0D, Today, LoanArrears[1], LoanArrears[2], LoanArrears[3], LoanArrears[4], LoanOverPay[1], LoanOverPay[2], LoanOverPay[3], LoanOverPay[4]);
                                    TotalArrears := Round((LoanArrears[1] + LoanArrears[2] + LoanArrears[3] + LoanArrears[4]), 1, '=');
                                    // Message('%1', TotalArrears);
                                    if TotalArrears > 0 then begin

                                        if Rec.Stage = Rec.Stage::"Two Months" then begin
                                            DefaulterNotice.ADDTEXT(STRSUBSTNO('Kindly note that member number %1 whose loan you guaranteed has failed to pay 2 of the installments.His / her arrears are Ksh. %2 . As his / her guarantor,please remind him / her to meet his / her obligation as per the loan agreement.For enquiries call 0113995543', Rec."Member No", TotalArrears));
                                        end;
                                        if Rec.Stage = Rec.Stage::"Three Months" then begin
                                            DefaulterNotice.ADDTEXT(STRSUBSTNO('Kindly note that member number %1 whose loan you guaranteed has failed to pay 3 of the installments. His / her arrears are Ksh. %2 . As his / her guarantor, please remind him / her to meet his / her obligation as per the loan agreement,failure to which your savings will be deducted to clear the arrears. For enquiries call 0113995543', Rec."Member No", TotalArrears));
                                        end;
                                        if Rec.Stage = Rec.Stage::"Four Months" then begin
                                            DefaulterNotice.ADDTEXT(STRSUBSTNO('Kindly note that, further to our earlier communication, we have recovered Ksh. %1 from your savings to clear the arrears owed by member number %2', BulkSMSLine."Recovery Amount", Rec."Member No"));
                                        end;

                                    end;
                                    SMSEntry.INIT;
                                    SMSEntry."Entry No." := EntryNo + 1;
                                    SMSEntry."Phone No." := BulkSMSLine."Member Phone No";
                                    SMSEntry."SMS Text".CREATEOUTSTREAM(Ostream);
                                    DefaulterNotice.WRITE(Ostream);
                                    SMSEntry."Created Date" := Rec."SMS Date";
                                    SMSEntry."Created Time" := TIME;
                                    SMSEntry."Source Code" := 'BULKSMS';
                                    SMSEntry.INSERT;

                                    BulkSMSLine2.RESET;
                                    BulkSMSLine2.SETRANGE(BulkSMSLine2."Member Phone No", BulkSMSLine."Member Phone No");
                                    BulkSMSLine2.SETRANGE(BulkSMSLine2."Document No", BulkSMSLine."Document No");
                                    if BulkSMSLine2.FINDSET then begin
                                        repeat
                                            BulkSMSLine2."Sent To Phone No" := true;
                                            BulkSMSLine2.MODIFY;
                                        until BulkSMSLine2.NEXT = 0;
                                    end;
                                until BulkSMSLine.NEXT = 0;
                            end;
                            Rec."SMS Sent" := true;
                            Rec.MODIFY;

                            BulkSMSLine.RESET;
                            BulkSMSLine.SETRANGE(BulkSMSLine."Document No", No);
                            BulkSMSLine.SETRANGE(BulkSMSLine.Select, false);
                            if BulkSMSLine.FINDSET then begin
                                BulkSMSLine.DELETEALL;
                            end;
                        end;

                    end;

                }
                action("Select All")
                {
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = SendSmsVisible;

                    trigger OnAction();
                    begin
                        BulkSMSLine.RESET;
                        BulkSMSLine.SETRANGE(BulkSMSLine."Document No", No);
                        if BulkSMSLine.FINDSET then begin
                            repeat
                                BulkSMSLine.Select := true;
                                BulkSMSLine.MODIFY;
                            until BulkSMSLine.NEXT = 0;
                        end;
                    end;
                }
                action("UnSelect All")
                {
                    Image = SelectLineToApply;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = SendSmsVisible;

                    trigger OnAction();
                    begin
                        BulkSMSLine.RESET;
                        BulkSMSLine.SETRANGE(BulkSMSLine."Document No", No);
                        if BulkSMSLine.FINDSET then begin
                            repeat
                                BulkSMSLine.Select := false;
                                BulkSMSLine.MODIFY;
                            until BulkSMSLine.NEXT = 0;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SMSText := Rec.GetSMSTemplate;
    end;

    trigger OnOpenPage();
    begin
        if "SMS Sent" = true then begin
            SendSmsVisible := false;
            PageEditable := false;
        end
        else begin
            SendSmsVisible := true;
            PageEditable := true;
        end;
    end;

    var
        BulkSMSLine: Record "Default Notification Line";
        SendSmsVisible: Boolean;
        PageEditable: Boolean;
        BulkSMSLine2: Record "Default Notification Line";
        SMSText: Text;
        SMSEntry: Record "SMS Entry";
        SMSEntry2: Record "SMS Entry";
        EntryNo: Integer;
        BigSMS: BigText;
        Ostream: OutStream;
        DefaulterNotice: BigText;
        GlobalM: Codeunit "Global Management";
        LoanArrears: array[10] of Decimal;
        LoanOverPay: array[10] of Decimal;
        TotalArrears: Decimal;
}

