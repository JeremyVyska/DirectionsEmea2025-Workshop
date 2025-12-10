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
            ToolTip = 'Specifies the booking number.';
        }
        field(2; "Equipment No."; Code[20])
        {
            Caption = 'Equipment No.';
            TableRelation = Equipment."No.";
            ToolTip = 'Specifies the equipment number.';
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            ToolTip = 'Specifies the customer name.';
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            ToolTip = 'Specifies the rental start date.';

            trigger OnValidate()
            begin
                "Days Until Start" := "Start Date" - Today;
            end;
        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
            ToolTip = 'Specifies the rental end date.';
        }
        field(6; Status; Enum BookingStatus)
        {
            Caption = 'Status';
            ToolTip = 'Specifies the booking status.';
        }
        field(7; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            MinValue = 0;
            ToolTip = 'Specifies the total rental amount.';
        }
        field(8; "Customer Email"; Text[250])
        {
            Caption = 'Customer Email';
            ExtendedDatatype = EMail;
            ToolTip = 'Specifies the customer email address.';
        }
        field(9; "Internal Notes"; Text[250])
        {
            Caption = 'Internal Notes';
            DataClassification = CustomerContent;
            ToolTip = 'Contains internal staff-only notes about the rental.';
        }
        field(60; "Days Until Start"; Integer)
        {
            Caption = 'Days Until Start';
            ToolTip = 'Shows the number of days until the rental starts.';
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
