namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50201 "Equipment Card"
{
    AboutText = 'Manage master data for equipment, including type, rate, and status.';
    AboutTitle = 'About Equipment Card';
    ApplicationArea = All;
    Caption = 'Equipment Card';
    Extensible = true;
    HelpLink = 'https://github.com/finnpedersenkazes/DirectionsEmea2025-Workshop';
    PageType = Card;
    SourceTable = Equipment;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field("Daily Rental Rate"; Rec."Daily Rental Rate")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Maintenance Date"; Rec."Last Maintenance Date")
                {
                }
            }
        }
    }
}
