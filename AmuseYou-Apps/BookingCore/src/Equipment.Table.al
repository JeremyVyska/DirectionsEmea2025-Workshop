namespace AmuseYou.BookingCore;

table 50000 Equipment
{
    Caption = 'Equipment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the equipment number.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the equipment description.';
        }
        field(3; "Equipment Type"; Enum EquipmentType)
        {
            Caption = 'Equipment Type';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the type of equipment.';
        }
        field(4; "Daily Rental Rate"; Decimal)
        {
            Caption = 'Daily Rental Rate';
            DataClassification = CustomerContent;
            MinValue = 0;
            ToolTip = 'Specifies the daily rental rate.';
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies if the equipment is blocked from booking.';
        }
        field(6; "Last Maintenance Date"; Date)
        {
            Caption = 'Last Maintenance Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the last maintenance date.';
        }
        field(7; Status; Enum EquipmentStatus)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            ToolTip = 'Shows the current equipment status.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(TypeKey; "Equipment Type")
        {
        }
    }
}
