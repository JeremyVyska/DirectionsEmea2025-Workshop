namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

table 50205 "Maintenance Log"
{
    Caption = 'Maintenance Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(10; "Equipment No."; Code[20])
        {
            Caption = 'Equipment No.';
            DataClassification = CustomerContent;
            TableRelation = Equipment."No.";
        }
        field(20; "Maintenance Date"; Date)
        {
            Caption = 'Maintenance Date';
            DataClassification = CustomerContent;
        }
        field(30; "Technician Name"; Text[100])
        {
            Caption = 'Technician Name';
            DataClassification = CustomerContent;
        }
        field(40; "Maintenance Notes"; Blob)
        {
            Caption = 'Maintenance Notes';
            DataClassification = CustomerContent;
        }
        field(41; "Inspection Photo"; Blob)
        {
            Caption = 'Inspection Photo';
            DataClassification = CustomerContent;
        }
        field(50; "Cost"; Decimal)
        {
            Caption = 'Cost';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(EquipmentDate; "Equipment No.", "Maintenance Date")
        {
        }
    }
}
