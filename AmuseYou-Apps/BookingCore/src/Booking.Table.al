namespace AmuseYou.BookingCore;

table 50001 Booking
{
    Caption = 'Booking';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Booking No."; Code[20])
        {
            Caption = 'Booking No.';
            DataClassification = CustomerContent;
        }
        field(2; "Equipment No."; Code[20])
        {
            Caption = 'Equipment No.';
            DataClassification = CustomerContent;
            TableRelation = Equipment."No.";
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Days Until Start" := "Start Date" - Today;
            end;
        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum BookingStatus)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(60; "Days Until Start"; Integer)
        {
            Caption = 'Days Until Start';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Booking No.")
        {
            Clustered = true;
        }
    }
}
