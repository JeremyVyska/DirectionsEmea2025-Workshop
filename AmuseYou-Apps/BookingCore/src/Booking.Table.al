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
        }
        field(2; "Equipment No."; Code[20])
        {
            Caption = 'Equipment No.';
            TableRelation = Equipment."No.";
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                "Days Until Start" := "Start Date" - Today;
            end;
        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(6; Status; Enum BookingStatus)
        {
            Caption = 'Status';
        }
        field(7; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            MinValue = 0;
        }
        field(8; "Customer Email"; Text[250])
        {
            Caption = 'Customer Email';
            ExtendedDatatype = EMail;
        }
        field(60; "Days Until Start"; Integer)
        {
            Caption = 'Days Until Start';
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
