pageextension 50203 UsersExt extends Users
{
    actions
    {
        addfirst(processing)
        {
            action(ChangeUserFullName)
            {
                ApplicationArea = All;
                Caption = 'Change User Full Name';
                Promoted = true;
                PromotedCategory = Process;
                Image = Open;
                trigger OnAction()
                var
                    ChangeFullNameDialog: Page "Change Full Name Dialog";
                    User: Record User;
                begin
                    User.Reset();
                    CurrPage.SetSelectionFilter(User);
                    if User.FindFirst() then begin
                        ChangeFullNameDialog.SetUserInfo(User."User Security ID", User."User Name", User."Full Name");
                        if ChangeFullNameDialog.RunModal() = Action::OK then
                            ChangeFullNameDialog.ChangeUserFullName();
                    end;
                end;
            }
        }
    }
}

page 50200 "Change Full Name Dialog"
{
    PageType = StandardDialog;
    Caption = 'Change Full Name Dialog';

    layout
    {
        area(content)
        {
            field(UserSecurityID; UserSecurityID)
            {
                ApplicationArea = All;
                Caption = 'User Security ID';
                Editable = false;
            }
            field(UserName; UserName)
            {
                ApplicationArea = All;
                Caption = 'User Name';
                Editable = false;
            }
            field(OldFullName; OldFullName)
            {
                ApplicationArea = All;
                Caption = 'Old Full Name';
                Editable = false;
            }
            field(NewFullName; NewFullName)
            {
                ApplicationArea = All;
                Caption = 'New Full Name';
            }
        }
    }

    var
        UserSecurityID: Guid;
        UserName: Code[50];
        OldFullName: Text[80];
        NewFullName: Text[80];

    procedure SetUserInfo(NewUserSecurityID: Guid; NewUserName: Code[50]; NewFullName: Text[80])
    begin
        UserSecurityID := NewUserSecurityID;
        UserName := NewUserName;
        OldFullName := NewFullName;
    end;

    procedure ChangeUserFullName()
    var
        User: Record User;
    begin
        if User.Get(UserSecurityID) then begin
            User."Full Name" := NewFullName;
            User.Modify(true);
        end;
    end;
}
